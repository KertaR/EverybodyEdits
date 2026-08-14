/**
 * World State and Serialization for Everybody Edits
 */

const fs = require('fs');
const path = require('path');

class World {
  constructor(id = 'PW_default', width = 200, height = 200) {
    this.id = id;
    this.title = 'Private World';
    this.owner = 'Admin';
    this.ownerId = 'admin_1';
    this.editKey = '';
    this.width = width;
    this.height = height;
    this.backgroundColor = 0x000000;
    this.borderType = 9; // Default gray border
    this.fillType = 0;   // Default empty fill

    // 3D Array: [layer][y][x]
    // Layer 0: Foreground (blocks, doors, hazard, portals)
    // Layer 1: Background
    this.foreground = Array.from({ length: height }, () => new Uint16Array(width));
    this.background = Array.from({ length: height }, () => new Uint16Array(width));
    this.blockData = {}; // Store extra block properties key: "layer_x_y"

    this.initDefaultWorld();
  }

  initDefaultWorld() {
    // Generate outer border blocks
    for (let x = 0; x < this.width; x++) {
      this.foreground[0][x] = this.borderType;
      this.foreground[this.height - 1][x] = this.borderType;
    }
    for (let y = 0; y < this.height; y++) {
      this.foreground[y][0] = this.borderType;
      this.foreground[y][this.width - 1] = this.borderType;
    }
  }

  setBlock(layer, x, y, blockId, extra = null) {
    if (x < 0 || x >= this.width || y < 0 || y >= this.height) return false;
    
    if (layer === 0) {
      this.foreground[y][x] = blockId;
    } else {
      this.background[y][x] = blockId;
    }

    const key = `${layer}_${x}_${y}`;
    if (extra !== null && extra !== undefined) {
      this.blockData[key] = extra;
    } else {
      delete this.blockData[key];
    }
    return true;
  }

  getBlock(layer, x, y) {
    if (x < 0 || x >= this.width || y < 0 || y >= this.height) return 0;
    return layer === 0 ? this.foreground[y][x] : this.background[y][x];
  }

  clearArea(layer, x1, y1, x2, y2, blockId = 0) {
    const minX = Math.max(0, Math.min(x1, x2));
    const maxX = Math.min(this.width - 1, Math.max(x1, x2));
    const minY = Math.max(0, Math.min(y1, y2));
    const maxY = Math.min(this.height - 1, Math.max(y1, y2));

    for (let y = minY; y <= maxY; y++) {
      for (let x = minX; x <= maxX; x++) {
        this.setBlock(layer, x, y, blockId);
      }
    }
  }

  /**
   * Serializes the world blocks into the "ws" ... "we" parameters format for EE init message
   */
  serializeToInitMessage(msg) {
    msg.add("ws"); // World Start tag

    // Group non-zero blocks by (layer, blockId, extraString)
    const groups = new Map();

    for (let layer = 0; layer < 2; layer++) {
      const grid = layer === 0 ? this.foreground : this.background;

      for (let y = 0; y < this.height; y++) {
        for (let x = 0; x < this.width; x++) {
          const blockId = grid[y][x];
          if (blockId === 0) continue;

          const key = `${layer}_${x}_${y}`;
          const extra = this.blockData[key] || null;
          const extraStr = JSON.stringify(extra);
          const groupKey = `${layer}_${blockId}_${extraStr}`;

          if (!groups.has(groupKey)) {
            groups.set(groupKey, {
              layer,
              blockId,
              extra,
              xs: [],
              ys: []
            });
          }

          const grp = groups.get(groupKey);
          grp.xs.push(x);
          grp.ys.push(y);
        }
      }
    }

    // Append each block chunk to the init message
    for (const group of groups.values()) {
      const xBuf = Buffer.alloc(group.xs.length * 2);
      const yBuf = Buffer.alloc(group.ys.length * 2);

      for (let i = 0; i < group.xs.length; i++) {
        xBuf.writeUInt16BE(group.xs[i], i * 2);
        yBuf.writeUInt16BE(group.ys[i], i * 2);
      }

      msg.add(group.blockId);
      msg.add(group.layer);
      msg.add(xBuf);
      msg.add(yBuf);

      // Add extra parameters depending on block type
      if (group.extra !== null && group.extra !== undefined) {
        if (Array.isArray(group.extra)) {
          for (const item of group.extra) {
            msg.add(item);
          }
        } else if (typeof group.extra === 'object') {
          if (group.extra.args) {
            for (const arg of group.extra.args) {
              msg.add(arg);
            }
          }
        } else {
          msg.add(group.extra);
        }
      }
    }

    msg.add("we"); // World End tag
  }

  saveToFile(dirPath) {
    if (!fs.existsSync(dirPath)) {
      fs.mkdirSync(dirPath, { recursive: true });
    }
    const fgArray = [];
    const bgArray = [];
    for (let y = 0; y < this.height; y++) {
      fgArray.push(Array.from(this.foreground[y]));
      bgArray.push(Array.from(this.background[y]));
    }

    const data = {
      id: this.id,
      title: this.title,
      owner: this.owner,
      ownerId: this.ownerId,
      editKey: this.editKey || '',
      width: this.width,
      height: this.height,
      backgroundColor: this.backgroundColor,
      foreground: fgArray,
      background: bgArray,
      blockData: this.blockData
    };

    const filePath = path.join(dirPath, `${this.id}.json`);
    fs.writeFileSync(filePath, JSON.stringify(data, null, 2), 'utf8');
    console.log(`Saved world ${this.id} to ${filePath}`);
  }

  loadFromFile(filePath) {
    if (!fs.existsSync(filePath)) return false;
    try {
      const raw = fs.readFileSync(filePath, 'utf8');
      const data = JSON.parse(raw);
      this.id = data.id || this.id;
      this.title = data.title || this.title;
      this.owner = data.owner || this.owner;
      this.ownerId = data.ownerId || this.ownerId;
      this.editKey = data.editKey || '';
      this.width = data.width || 200;
      this.height = data.height || 200;
      this.backgroundColor = data.backgroundColor || 0;
      this.blockData = data.blockData || {};

      this.foreground = Array.from({ length: this.height }, () => new Uint16Array(this.width));
      this.background = Array.from({ length: this.height }, () => new Uint16Array(this.width));

      if (data.foreground) {
        for (let y = 0; y < Math.min(this.height, data.foreground.length); y++) {
          for (let x = 0; x < Math.min(this.width, data.foreground[y].length); x++) {
            this.foreground[y][x] = data.foreground[y][x];
          }
        }
      }

      if (data.background) {
        for (let y = 0; y < Math.min(this.height, data.background.length); y++) {
          for (let x = 0; x < Math.min(this.width, data.background[y].length); x++) {
            this.background[y][x] = data.background[y][x];
          }
        }
      }

      console.log(`Loaded world ${this.id} from ${filePath}`);
      return true;
    } catch (e) {
      console.error(`Failed to load world from ${filePath}:`, e);
      return false;
    }
  }
}

module.exports = World;
