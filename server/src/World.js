/**
 * World State and Serialization for Everybody Edits
 */

const fs = require('fs');
const path = require('path');

class World {
  constructor(id = 'PW_default', width = 200, height = 200) {
    this.id = id;
    this.title = 'Private World';
    this.description = 'Welcome to Everybody Edits!';
    this.owner = 'Admin';
    this.ownerId = 'admin_1';
    this.editKey = '';
    this.width = width;
    this.height = height;
    this.spawnX = 16;
    this.spawnY = 16;
    this.backgroundColor = 0x000000;
    this.borderType = 9; // Default gray border
    this.fillType = 0;   // Default empty fill
    this.likes = 0;
    this.favorites = 0;
    this.plays = 1;

    // 3D Array: [layer][y][x]
    // Layer 0: Foreground (blocks, doors, hazard, portals)
    // Layer 1: Background
    this.foreground = Array.from({ length: height }, () => new Uint16Array(width));
    this.background = Array.from({ length: height }, () => new Uint16Array(width));
    this.blockData = {}; // Store extra block properties key: "layer_x_y"

    // Undo history stack (max 10 entries)
    this.history = [];

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

  pushHistory(entry) {
    this.history.push(entry);
    if (this.history.length > 10) {
      this.history.shift();
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

  getBlockExtra(layer, x, y) {
    const key = `${layer}_${x}_${y}`;
    return this.blockData[key] || null;
  }

  fillArea(layer, x1, y1, x2, y2, blockId) {
    const minX = Math.max(1, Math.min(x1, x2));
    const maxX = Math.min(this.width - 2, Math.max(x1, x2));
    const minY = Math.max(1, Math.min(y1, y2));
    const maxY = Math.min(this.height - 2, Math.max(y1, y2));

    const undoChanges = [];
    const changedBlocks = [];

    for (let y = minY; y <= maxY; y++) {
      for (let x = minX; x <= maxX; x++) {
        const oldId = this.getBlock(layer, x, y);
        const oldExtra = this.getBlockExtra(layer, x, y);
        if (oldId !== blockId) {
          undoChanges.push({ layer, x, y, oldId, oldExtra, newId: blockId, newExtra: null });
          this.setBlock(layer, x, y, blockId);
          changedBlocks.push({ layer, x, y, blockId });
        }
      }
    }

    if (undoChanges.length > 0) {
      this.pushHistory({ action: 'fill', changes: undoChanges });
    }

    return { count: changedBlocks.length, minX, minY, maxX, maxY, changedBlocks };
  }

  replaceBlocks(layer, fromBlockId, toBlockId, rect = null) {
    const minX = rect ? Math.max(1, Math.min(rect.x1, rect.x2)) : 1;
    const maxX = rect ? Math.min(this.width - 2, Math.max(rect.x1, rect.x2)) : this.width - 2;
    const minY = rect ? Math.max(1, Math.min(rect.y1, rect.y2)) : 1;
    const maxY = rect ? Math.min(this.height - 2, Math.max(rect.y1, rect.y2)) : this.height - 2;

    const undoChanges = [];
    const changedBlocks = [];

    for (let y = minY; y <= maxY; y++) {
      for (let x = minX; x <= maxX; x++) {
        const currentId = this.getBlock(layer, x, y);
        if (currentId === fromBlockId) {
          const oldExtra = this.getBlockExtra(layer, x, y);
          undoChanges.push({ layer, x, y, oldId: currentId, oldExtra, newId: toBlockId, newExtra: null });
          this.setBlock(layer, x, y, toBlockId);
          changedBlocks.push({ layer, x, y, blockId: toBlockId });
        }
      }
    }

    if (undoChanges.length > 0) {
      this.pushHistory({ action: 'replace', changes: undoChanges });
    }

    return { count: changedBlocks.length, changedBlocks };
  }

  clearArea(layer, x1, y1, x2, y2, blockId = 0) {
    return this.fillArea(layer, x1, y1, x2, y2, blockId);
  }

  clearWorld() {
    const undoChanges = [];
    for (let y = 1; y < this.height - 1; y++) {
      for (let x = 1; x < this.width - 1; x++) {
        const fg = this.foreground[y][x];
        const fgExtra = this.getBlockExtra(0, x, y);
        if (fg !== 0) {
          undoChanges.push({ layer: 0, x, y, oldId: fg, oldExtra: fgExtra, newId: 0, newExtra: null });
          this.foreground[y][x] = 0;
        }
        const bg = this.background[y][x];
        const bgExtra = this.getBlockExtra(1, x, y);
        if (bg !== 0) {
          undoChanges.push({ layer: 1, x, y, oldId: bg, oldExtra: bgExtra, newId: 0, newExtra: null });
          this.background[y][x] = 0;
        }
      }
    }
    this.blockData = {};
    if (undoChanges.length > 0) {
      this.pushHistory({ action: 'clear', changes: undoChanges });
    }
    return { count: undoChanges.length };
  }

  undo() {
    if (this.history.length === 0) return null;
    const last = this.history.pop();
    const restored = [];

    // Reverse iterate to restore original order
    for (let i = last.changes.length - 1; i >= 0; i--) {
      const ch = last.changes[i];
      this.setBlock(ch.layer, ch.x, ch.y, ch.oldId, ch.oldExtra);
      restored.push({ layer: ch.layer, x: ch.x, y: ch.y, blockId: ch.oldId, extra: ch.oldExtra });
    }

    return { action: last.action, count: restored.length, restored };
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
      description: this.description || '',
      owner: this.owner,
      ownerId: this.ownerId,
      editKey: this.editKey || '',
      width: this.width,
      height: this.height,
      spawnX: this.spawnX || 16,
      spawnY: this.spawnY || 16,
      backgroundColor: this.backgroundColor,
      likes: this.likes || 0,
      favorites: this.favorites || 0,
      plays: this.plays || 1,
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
      this.description = data.description || '';
      this.owner = data.owner || this.owner;
      this.ownerId = data.ownerId || this.ownerId;
      this.editKey = data.editKey || '';
      this.width = data.width || 200;
      this.height = data.height || 200;
      this.spawnX = data.spawnX !== undefined ? data.spawnX : 16;
      this.spawnY = data.spawnY !== undefined ? data.spawnY : 16;
      this.backgroundColor = data.backgroundColor || 0;
      this.likes = data.likes || 0;
      this.favorites = data.favorites || 0;
      this.plays = data.plays || 1;
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
