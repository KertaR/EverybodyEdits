/**
 * Everybody Edits Private Server (TCP Sockets & Policy Server)
 */

const net = require('net');
const path = require('path');
const fs = require('fs');
const http = require('http');
const { PlayerIOMessage, PlayerIOProtocol } = require('./PlayerIOProtocol');
const World = require('./World');
const Player = require('./Player');
const UserManager = require('./UserManager');

class Server {
  constructor(config = {}) {
    this.port = config.port || 8184;
    this.host = config.host || '0.0.0.0';
    this.worldsDir = path.join(__dirname, '../worlds');
    this.userManager = new UserManager(path.join(__dirname, '../'));

    // Rooms map: roomId -> { world: World, players: Map<id, Player>, nextPlayerId: number }
    this.rooms = new Map();
    this.tcpServer = null;

    // Block IDs that are rotatable (from ItemId.isBlockRotateable + spikes + NonRotatableHalfBlock)
    // Values extracted from items/ItemId.as constants
    this.ROTATABLE_BLOCKS = new Set([
      // Spikes: SPIKE=361, SPIKE_SILVER=1625, SPIKE_BLACK=1627, SPIKE_RED=1629, SPIKE_GOLD=1631, SPIKE_GREEN=1633, SPIKE_BLUE=1635
      361, 1625, 1627, 1629, 1631, 1633, 1635,
      // Glowy lines: BLUE_STRAIGHT=376, BLUE_SLOPE=375, GREEN_SLOPE=379, GREEN_STRAIGHT=380, YELLOW_SLOPE=377, YELLOW_STRAIGHT=378, RED_SLOPE=438, RED_STRAIGHT=439
      375, 376, 377, 378, 379, 380, 438, 439,
      // One-way: CYAN=1001, ORANGE=1002, YELLOW=1003, PINK=1004, GRAY=1052, BLUE=1053, RED=1054, GREEN=1055, BLACK=1056, WHITE=1092
      1001, 1002, 1003, 1004, 1052, 1053, 1054, 1055, 1056, 1092,
      // Medieval: AXE=275, BANNER=327, COATOFARMS=328, SHIELD=273, SWORD=329, TIMBER=440
      273, 275, 327, 328, 329, 440,
      // Teeth: BIG=338, SMALL=339, TRIPLE=340
      338, 339, 340,
      // Dojo: LIGHT_LEFT=276, LIGHT_RIGHT=277, DARK_LEFT=279, DARK_RIGHT=280
      276, 277, 279, 280,
      // Domestic: LIGHT_BULB=447, TAP=448, PAINTING=449, VASE=450, TV=451, WINDOW=452
      447, 448, 449, 450, 451, 452,
      // Domestic halfblocks: YELLOW=1041, BROWN=1042, WHITE=1043
      1041, 1042, 1043,
      // Halloween 2015: WINDOW_RECT=456, WINDOW_CIRCLE=457, LAMP=458
      456, 457, 458,
      // New Year 2015: BALLOON=464, STREAMER=465
      464, 465,
      // Fairytale halfblocks: ORANGE=1075, GREEN=1076, BLUE=1077, PINK=1078
      1075, 1076, 1077, 1078,
      // Fairytale: FLOWERS=471
      471,
      // Spring: DAFFODIL=477, DAISY=475, TULIP=476
      475, 476, 477,
      // Summer: FLAG=481, AWNING=482, ICECREAM=483
      481, 482, 483,
      // Cave: CRYSTAL=497
      497,
      // Restaurant: CUP=492, PLATE=493, BOWL=494
      492, 493, 494,
      // Halloween 2016: ROTATABLE=499, EYES=1502, PUMPKIN=1500
      499, 1500, 1502,
      // Christmas 2016: LIGHTS_DOWN=1507, LIGHTS_UP=1506
      1506, 1507,
      // Halfblocks colored: WHITE=1116, GRAY=1117, BLACK=1118, RED=1119, ORANGE=1120, YELLOW=1121, GREEN=1122, CYAN=1123, BLUE=1124, PURPLE=1125
      1116, 1117, 1118, 1119, 1120, 1121, 1122, 1123, 1124, 1125,
      // Industrial: PIPE_THIN=1535, PIPE_THICK=1135, TABLE=1134
      1134, 1135, 1535,
      // Domestic pipes: PIPE_STRAIGHT=1536, PIPE_T=1537, FRAME_BORDER=1538
      1536, 1537, 1538,
      // Winter 2018 halfblocks: SNOW=1140, GLACIER=1141
      1140, 1141,
      // Fireworks: 1581
      1581,
      // Toxic/Sewer/Metal: BARREL=1587, PIPE=1588, PLATFORM=1155
      1155, 1587, 1588,
      // Dungeon pillars/arches: PILLAR_BOTTOM=1592, PILLAR_MIDDLE=1593, PILLAR_TOP=1160, ARCH_LEFT=1594, ARCH_RIGHT=1595
      1160, 1592, 1593, 1594, 1595,
      // Shadows: A=1596, B=1605, C=1606, D=1607, F=1609, G=1610, H=1611, I=1612, K=1614, L=1615, M=1616, N=1617
      1596, 1605, 1606, 1607, 1609, 1610, 1611, 1612, 1614, 1615, 1616, 1617,
      // Dungeon torch: 1597
      1597,
      // NonRotatable halfblocks (still sent with rotation arg): RED=1101, GREEN=1102, WHITE=1103, BLUE=1104, YELLOW=1105
      1101, 1102, 1103, 1104, 1105
    ]);

    // NPC block IDs (from ItemId.NpcArray)
    this.NPC_BLOCKS = new Set([
      1550, 1551, 1552, 1553, 1554, 1555, 1556, 1557, 1558, 1559,
      1570, 1569, 1571, 1572, 1573, 1574, 1575, 1576, 1577, 1578, 1579
    ]);
  }

  isRotatableBlock(blockId) {
    return this.ROTATABLE_BLOCKS.has(blockId);
  }

  isNPC(blockId) {
    return this.NPC_BLOCKS.has(blockId);
  }

  getOrCreateRoom(roomId) {
    if (!this.rooms.has(roomId)) {
      const world = new World(roomId);
      const worldFile = path.join(this.worldsDir, `${roomId}.json`);
      if (fs.existsSync(worldFile)) {
        world.loadFromFile(worldFile);
      } else {
        world.saveToFile(this.worldsDir);
      }

      this.rooms.set(roomId, {
        id: roomId,
        world,
        players: new Map(),
        nextPlayerId: 1
      });
      console.log(`[Room] Created room: ${roomId}`);
    }
    return this.rooms.get(roomId);
  }

  start() {
    // Start Local Web Server on Port 8080 for Flash Security Domain Bypass & API Endpoints
    try {
      const webServer = http.createServer((req, res) => {
        let reqPath = req.url.split('?')[0];

        // API Endpoint: Register User
        if (req.method === 'POST' && reqPath === '/api/register') {
          let body = '';
          req.on('data', chunk => { body += chunk.toString(); });
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const user = this.userManager.register(data.username || 'User', data.password || 'user123', data.email || '');
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true, user }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // API Endpoint: Login User
        if (req.method === 'POST' && reqPath === '/api/login') {
          let body = '';
          req.on('data', chunk => { body += chunk.toString(); });
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              let user = this.userManager.getUser(data.username);
              if (!user && data.username) {
                user = this.userManager.register(data.username, data.password || 'user123');
              }
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true, user }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // API Endpoint: Get Shop Items (reads directly from server/shop/items.json)
        if (req.method === 'GET' && reqPath === '/api/shop') {
          try {
            const shopFile = path.join(__dirname, '../shop/items.json');
            if (fs.existsSync(shopFile)) {
              const content = fs.readFileSync(shopFile, 'utf8');
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(content);
            } else {
              res.writeHead(404, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: 'Shop items file not found' }));
            }
          } catch (e) {
            res.writeHead(500, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: false, error: e.message }));
          }
          return;
        }

        // API Endpoint: Get User Data by Name (reads directly from server/users/<name>.json)
        if (req.method === 'GET' && reqPath.startsWith('/api/user/')) {
          const username = decodeURIComponent(reqPath.substring('/api/user/'.length));
          const user = this.userManager.getUser(username);
          if (user) {
            res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: true, user }));
          } else {
            res.writeHead(404, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: false, error: 'User not found' }));
          }
          return;
        }

        // API Endpoint: Get Crews (reads all JSON files from server/crews/ directory)
        if (req.method === 'GET' && reqPath === '/api/crews') {
          try {
            const crewsDir = path.join(__dirname, '../crews');
            const crewsList = [];
            if (fs.existsSync(crewsDir)) {
              const files = fs.readdirSync(crewsDir).filter(f => f.endsWith('.json'));
              for (const file of files) {
                try {
                  const content = JSON.parse(fs.readFileSync(path.join(crewsDir, file), 'utf8'));
                  if (content && content.id && content.name) {
                    crewsList.push({ id: content.id, name: content.name });
                  }
                } catch (err) {}
              }
            }
            res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: true, crews: crewsList }));
          } catch (e) {
            res.writeHead(500, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: false, error: e.message }));
          }
          return;
        }

        // API Endpoint: Get Single Crew (reads server/crews/<id>.json)
        if (req.method === 'GET' && reqPath.startsWith('/api/crew')) {
          try {
            const urlParams = new URLSearchParams(req.url.split('?')[1] || '');
            const crewId = (urlParams.get('id') || 'staff').toLowerCase();
            const crewFile = path.join(__dirname, `../crews/${crewId}.json`);
            if (fs.existsSync(crewFile)) {
              const crew = JSON.parse(fs.readFileSync(crewFile, 'utf8'));
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true, crew }));
            } else {
              res.writeHead(404, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: `Crew ${crewId} not found` }));
            }
          } catch (e) {
            res.writeHead(500, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: false, error: e.message }));
          }
          return;
        }

        // API Endpoint: Buy Shop Item
        if (req.method === 'POST' && reqPath === '/api/buy') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body);
              const username = data.username;
              const itemId = data.itemId;
              const costGems = Number(data.costGems || 0);
              const isEnergy = Boolean(data.isEnergy);
              const useAll = Boolean(data.useAll);

              if (!username) {
                res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Username required' }));
                return;
              }

              const user = this.userManager.getUser(username);
              if (!user) {
                res.writeHead(404, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'User not found' }));
                return;
              }
              if (!Array.isArray(user.payVault)) user.payVault = [];
              if (user.gems === undefined) user.gems = 500;
              if (user.energy === undefined) user.energy = 100;
              if (user.maxEnergy === undefined) user.maxEnergy = 200;
              if (!user.itemEnergyProgress) user.itemEnergyProgress = {};

              let actualVaultId = itemId;
              let sItem = null;
              if (this.shopItems && Array.isArray(this.shopItems)) {
                sItem = this.shopItems.find(i => i && (i.id === itemId || i.payvaultid === itemId));
                if (sItem && sItem.payvaultid) {
                  actualVaultId = sItem.payvaultid;
                }
              }

              const isAlreadyOwned = itemId && (user.payVault.includes(itemId) || (actualVaultId && user.payVault.includes(actualVaultId)));
              if (isAlreadyOwned) {
                res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: true, unlocked: true, error: 'Item already owned', user }));
                return;
              }

              let unlocked = false;
              let energySpent = 0;
              let currentProgress = 0;

              if (isEnergy) {
                const itemCostEnergy = sItem ? Number(sItem.priceEnergy || 0) : 250;
                const clickEnergy = sItem ? Number(sItem.priceEnergyClick || 10) : 10;
                const targetKey = sItem ? sItem.id : itemId;

                currentProgress = Number(user.itemEnergyProgress[targetKey] || 0);
                const neededEnergy = Math.max(0, itemCostEnergy - currentProgress);

                if (neededEnergy > 0) {
                  if (user.energy <= 0) {
                    res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                    res.end(JSON.stringify({ success: true, unlocked: false, noEnergy: true, energyUsed: currentProgress, energySpent: 0, user }));
                    return;
                  }
                  if (useAll) {
                    energySpent = Math.min(user.energy, neededEnergy);
                  } else {
                    energySpent = Math.min(user.energy, clickEnergy, neededEnergy);
                  }
                  user.energy = Math.max(0, user.energy - energySpent);
                  currentProgress += energySpent;
                  user.itemEnergyProgress[targetKey] = currentProgress;
                }

                if (currentProgress >= itemCostEnergy || itemCostEnergy === 0) {
                  unlocked = true;
                }
              } else {
                if (user.gems < costGems) {
                  user.gems = Math.max(user.gems, costGems);
                }
                if (costGems > 0) {
                  user.gems = Math.max(0, user.gems - costGems);
                }
                unlocked = true;
              }

              if (unlocked) {
                if (itemId && !user.payVault.includes(itemId)) {
                  user.payVault.push(itemId);
                }
                if (actualVaultId && !user.payVault.includes(actualVaultId)) {
                  user.payVault.push(actualVaultId);
                }
                if (itemId === 'goldmember' || actualVaultId === 'goldmember') user.goldmember = true;
                if (itemId === 'pro' || actualVaultId === 'pro') user.player_is_beta_member = true;
              }

              this.userManager.saveUser(user.username);
              console.log(`[Shop] User ${user.username} ${unlocked ? 'unlocked' : 'spent energy on'} '${itemId}'. Gems: ${user.gems}, Energy: ${user.energy}/${user.maxEnergy}, Progress: ${currentProgress}`);

              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true, unlocked, energyUsed: currentProgress, energySpent, user }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // API Endpoint: Update User Energy / Gems / MaxEnergy
        if (req.method === 'POST' && reqPath === '/api/user/update') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body);
              const username = data.username;
              if (!username) {
                res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Username required' }));
                return;
              }
              const user = this.userManager.getUser(username);
              if (!user) {
                res.writeHead(404, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'User not found' }));
                return;
              }
              if (data.gems !== undefined) user.gems = Number(data.gems);
              if (data.energy !== undefined) user.energy = Number(data.energy);
              if (data.maxEnergy !== undefined) user.maxEnergy = Number(data.maxEnergy);
              if (data.face !== undefined) user.face = Number(data.face);
              if (data.aura !== undefined) user.aura = Number(data.aura);
              if (data.auraColor !== undefined) user.auraColor = Number(data.auraColor);

              this.userManager.saveUser(user.username);
              console.log(`[User] Updated user ${user.username} -> Gems: ${user.gems}, Energy: ${user.energy}, MaxEnergy: ${user.maxEnergy}`);

              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true, user }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // Crossdomain policy XML for HTTP requests
        if (reqPath === '/crossdomain.xml') {
          const xml = '<?xml version="1.0"?>\n' +
            '<!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd">\n' +
            '<cross-domain-policy>\n' +
            '  <allow-access-from domain="*" to-ports="*" />\n' +
            '</cross-domain-policy>';
          res.writeHead(200, { 'Content-Type': 'text/xml', 'Access-Control-Allow-Origin': '*' });
          res.end(xml);
          return;
        }

        // API Endpoint: Get Worlds List
        if (req.method === 'GET' && reqPath === '/api/worlds') {
          try {
            const files = fs.readdirSync(this.worldsDir).filter(f => f.endsWith('.json'));
            const worldsList = files.map(filename => {
              const worldId = filename.replace('.json', '');
              const filePath = path.join(this.worldsDir, filename);
              let title = worldId === 'PW_default' ? 'Home World' : worldId;
              let owner = '';
              let width = 200;
              let height = 200;
              let plays = 1;
              let likes = 0;
              let favorites = 0;
              try {
                const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
                if (data.title) title = data.title;
                if (data.owner) owner = data.owner;
                if (data.width) width = data.width;
                if (data.height) height = data.height;
              } catch(e) {}
              const room = this.rooms.get(worldId);
              const onlineUsers = room ? room.players.size : 0;
              return {
                id: worldId,
                title,
                owner,
                width,
                height,
                plays,
                likes,
                favorites,
                onlineUsers
              };
            });
            res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify(worldsList));
          } catch(e) {
            res.writeHead(500, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify([]));
          }
          return;
        }

        if (reqPath === '/' || reqPath === '') reqPath = '/index.html';
        const filePath = path.join(__dirname, '../../', reqPath);

        if (fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
          const ext = path.extname(filePath).toLowerCase();
          const mimeTypes = {
            '.html': 'text/html',
            '.swf': 'application/x-shockwave-flash',
            '.js': 'text/javascript',
            '.css': 'text/css',
            '.json': 'application/json'
          };
          const fileSize = fs.statSync(filePath).size;
          console.log(`[Web] GET ${reqPath} (${fileSize} bytes)`);
          res.writeHead(200, {
            'Content-Type': mimeTypes[ext] || 'application/octet-stream',
            'Content-Length': fileSize,
            'Access-Control-Allow-Origin': '*'
          });
          fs.createReadStream(filePath).pipe(res);
        } else {
          console.log(`[Web] 404 ${reqPath}`);
          res.writeHead(404, { 'Content-Type': 'text/plain' });
          res.end('404 Not Found');
        }
      });

      webServer.listen(8080, this.host, () => {
        console.log(`[Web Server] HTTP Web Server active at http://localhost:8080`);
      });
    } catch (e) {
      console.log(`[Web Server] Could not bind port 8080: ${e.message}`);
    }

    // Dedicated Flash Policy Server on Port 843
    try {
      const policyServer = net.createServer((socket) => {
        socket.on('data', () => {
          console.log('[Policy Server 843] Servicing Flash crossdomain policy request');
          const policyResponse = '<?xml version="1.0"?>\n' +
            '<!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd">\n' +
            '<cross-domain-policy>\n' +
            '  <allow-access-from domain="*" to-ports="*" />\n' +
            '</cross-domain-policy>\0';
          socket.write(policyResponse);
          socket.end();
        });
      });
      policyServer.listen(843, this.host, () => {
        console.log(`[Policy Server] Dedicated Flash Policy Server active on port 843`);
      });
      policyServer.on('error', (err) => {
        console.log(`[Policy Server] Port 843 notice: ${err.message}`);
      });
    } catch (e) {
      console.log(`[Policy Server] Could not bind port 843: ${e.message}`);
    }

    this.tcpServer = net.createServer((socket) => {
      let currentBuffer = Buffer.alloc(0);
      let player = null;
      let room = null;

      console.log(`[Client] New socket connection from ${socket.remoteAddress}:${socket.remotePort}`);

      socket.on('data', (chunk) => {
        // Handle Flash Security Policy Request (<policy-file-request/>)
        if (chunk.toString('utf8').includes('<policy-file-request/>')) {
          console.log('[Policy] Servicing Flash crossdomain policy request');
          const policyResponse = '<?xml version="1.0"?>\n' +
            '<!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd">\n' +
            '<cross-domain-policy>\n' +
            '  <allow-access-from domain="*" to-ports="*" />\n' +
            '</cross-domain-policy>\0';
          socket.write(policyResponse);
          return;
        }

        currentBuffer = Buffer.concat([currentBuffer, chunk]);

        // Strip leading null bytes (0x00) sent by PlayerIO Flash SDK on connect
        while (currentBuffer.length > 0 && currentBuffer[0] === 0x00) {
          currentBuffer = currentBuffer.slice(1);
        }

        const { messages, remainingBuffer } = PlayerIOProtocol.decodeStream(currentBuffer);
        currentBuffer = remainingBuffer;

        for (const msg of messages) {
          try {
            this.handleMessage(socket, msg, player, room, (newPlayer, newRoom) => {
              player = newPlayer;
              room = newRoom;
            });
          } catch (err) {
            console.error('[Message Error]', err);
          }
        }
      });

      socket.on('close', () => {
        if (player && room) {
          console.log(`[Disconnect] Player ${player.username} (ID: ${player.id}) left room ${room.id}`);
          room.players.delete(player.id);

          // Broadcast 'left' message
          const leftMsg = new PlayerIOMessage('left', [player.id]);
          this.broadcastToRoom(room, leftMsg);
        }
      });

      socket.on('error', (err) => {
        console.error(`[Socket Error] ${err.message}`);
      });
    });

    this.tcpServer.listen(this.port, this.host, () => {
      console.log(`====================================================`);
      console.log(` Everybody Edits Private Server running on ${this.host}:${this.port}`);
      console.log(` Flash crossdomain policy server active on port ${this.port}`);
      console.log(`====================================================`);
    });
  }

  handleMessage(socket, msg, player, room, setPlayerRoom) {
    console.log(`[Packet Recv] ${msg.type} from ${player ? player.username : 'unauth'}:`, msg.values);

    switch (msg.type) {
      case 'join': {
        const roomId = msg.getString(0) || 'PW_default';
        let editKey = '';
        let connectUserId = '';

        for (let i = 1; i < msg.values.length - 1; i += 2) {
          const k = String(msg.getString(i) || '');
          const v = String(msg.getString(i + 1) || '');
          if (k === 'editkey') {
            editKey = v;
          } else if (k === 'connectUserId') {
            connectUserId = v;
          }
        }

        room = this.getOrCreateRoom(roomId);
        const playerId = room.nextPlayerId++;

        let username = 'Guest' + playerId;
        if (connectUserId && connectUserId.startsWith('simple') && connectUserId !== 'simpleguest') {
          username = connectUserId.substring(6);
        } else if (connectUserId && connectUserId !== 'simpleguest') {
          username = connectUserId;
        }

        let userData = this.userManager.getUser(username);
        if (!userData) {
          userData = this.userManager.register(username, 'user123');
        }

        player = new Player(playerId, socket, userData.username);
        player.face = userData.face !== undefined ? userData.face : 0;
        player.aura = userData.aura !== undefined ? userData.aura : 0;
        player.auraColor = userData.auraColor !== undefined ? userData.auraColor : 0;
        player.badge = userData.badge || '';
        player.smileyGoldBorder = userData.smileyGoldBorder !== undefined ? userData.smileyGoldBorder : true;
        player.joinTimestamp = Date.now();

        const isAdmin = Boolean(userData && (userData.isAdmin || userData.role === 'admin'));
        player.isAdmin = isAdmin;
        player.isMod = isAdmin || Boolean(userData.isMod);
        player.canEdit = true;
        player.isOwner = true;
        player.isGod = true;
        player.canToggleGodMode = true;
        room.players.set(player.id, player);
        setPlayerRoom(player, room);

        console.log(`[Join] Player ${player.username} (ID: ${player.id}) joined room ${room.id} with editKey='${editKey}'`);

        // Send 'playerio.joinresult' to tell the client join was successful
        const joinResultMsg = new PlayerIOMessage('playerio.joinresult');
        joinResultMsg.add(true);
        player.send(joinResultMsg);
        break;
      }

      case 'init': {
        if (!player || !room) return;
        console.log(`[Init] Client requested init for player ${player.username} (ID: ${player.id}) in room ${room.id}`);

        // Construct & Send 'init' message matching EverybodyEdits.as & PlayState.as expectations
        const initMsg = new PlayerIOMessage('init');
        initMsg.add(room.world.owner);           // param2: Owner Username
        initMsg.add(room.world.title);           // param3: Level Name
        initMsg.add(0);                          // param4: Plays/Views
        initMsg.add(0);                          // param5: Favorites
        initMsg.add(0);                          // param6: Likes
        initMsg.add(player.id);                  // param7: My Player ID
        initMsg.add(player.face);                // param8: Spawn Face/Smiley
        initMsg.add(player.aura);                // param9: Spawn Aura
        initMsg.add(player.auraColor);           // param10: Spawn Aura Color
        initMsg.add(player.smileyGoldBorder);    // param11: Gold Border
        initMsg.add(player.x);                   // param12: Spawn X
        initMsg.add(player.y);                   // param13: Spawn Y
        initMsg.add(player.chatColor);           // param14: Chat Color
        initMsg.add(player.username);            // param15: My Name
        initMsg.add(player.canEdit);             // param16: Can Edit
        initMsg.add(player.isOwner);             // param17: Is Owner
        initMsg.add(false);                      // param18: Is In Favorites
        initMsg.add(false);                      // param19: Is Liked
        initMsg.add(room.world.width);           // param20: Room Width
        initMsg.add(room.world.height);          // param21: Room Height
        initMsg.add(1.0);                        // param22: Gravity Multiplier
        initMsg.add(room.world.backgroundColor); // param23: Background Color
        initMsg.add(true);                       // param24: Visible
        initMsg.add(false);                      // param25: Hide Lobby
        initMsg.add(false);                      // param26: Allow Spectating
        initMsg.add('');                         // param27: Room Description
        initMsg.add(0);                          // param28: Effect Limit 1
        initMsg.add(0);                          // param29: Effect Limit 2
        initMsg.add(false);                      // param30: Is Campaign Room
        initMsg.add('');                         // param31: Crew ID
        initMsg.add('');                         // param32: Crew Name
        initMsg.add(true);                       // param33: Can Change World Options
        initMsg.add(0);                          // param34: Status
        initMsg.add(player.badge);               // param35: Badge
        initMsg.add(false);                      // param36: Crew Member
        initMsg.add(false);                      // param37: Minimap Enabled
        initMsg.add(false);                      // param38: Lobby Preview
        initMsg.add(Buffer.alloc(0));            // param39: Active Orange Switches (empty ByteArray)
        initMsg.add(false);                      // param40: Crew Visible
        initMsg.add(room.world.ownerId);         // param41: Owner ID
        initMsg.add(true);                       // param42: Can Toggle God Mode

        // Add serialized world blocks ("ws" ... "we")
        room.world.serializeToInitMessage(initMsg);

        player.send(initMsg);

        // Send 'add' message for all existing players to the new player
        for (const [otherId, otherPlayer] of room.players) {
          if (otherId !== player.id) {
            const addMsg = new PlayerIOMessage('add', otherPlayer.getAddMessageData());
            player.send(addMsg);
          }
        }

        // Broadcast 'add' message of new player to all existing players
        const newAddMsg = new PlayerIOMessage('add', player.getAddMessageData());
        this.broadcastToRoom(room, newAddMsg, player.id);
        break;
      }

      case 'm': {
        if (!player || !room) return;
        // Packet: m, x, y, speedX, speedY, modifierX, modifierY, horizontal, vertical, spacedown, spacejustdown
        player.x = msg.getFloat(0);
        player.y = msg.getFloat(1);
        player.speedX = msg.getFloat(2);
        player.speedY = msg.getFloat(3);
        player.modifierX = msg.getFloat(4);
        player.modifierY = msg.getFloat(5);
        player.horizontal = msg.getFloat(6);
        player.vertical = msg.getFloat(7);
        player.spacedown = msg.getBoolean(8);
        player.spacejustdown = msg.getBoolean(9);

        // Broadcast 'm' to all other players in room
        const broadcastM = new PlayerIOMessage('m', [
          player.id,
          player.x, player.y,
          player.speedX, player.speedY,
          player.modifierX, player.modifierY,
          player.horizontal, player.vertical,
          player.spacedown, player.spacejustdown
        ]);
        this.broadcastToRoom(room, broadcastM, player.id);
        break;
      }

      case 'b': {
        if (!player || !room) return;
        // Packet: b, layer, x, y, blockId, [extra args]
        const layer = msg.getInt(0);
        const x = msg.getInt(1);
        const y = msg.getInt(2);
        const blockId = msg.getInt(3);

        const extraArgs = msg.values.slice(4);
        room.world.setBlock(layer, x, y, blockId, extraArgs.length > 0 ? extraArgs : null);

        console.log(`[Block Place] Player ${player.username} placed blockId=${blockId} at (${x},${y}) layer=${layer} extraArgs=[${extraArgs}]`);

        // --- Determine correct response message type based on block type ---

        // Label block: 'lb' x, y, blockId, text, hex, wrapLength, playerId
        if (blockId === 1000) {
          const text = String(extraArgs[0] || ":)");
          const hex = String(extraArgs[1] || "#FFFFFF");
          const wrapLength = Number(extraArgs[2] || 0);
          const lbMsg = new PlayerIOMessage('lb', [x, y, blockId, text, hex, wrapLength, player.id]);
          this.broadcastToRoom(room, lbMsg);
        }
        // Text Sign: 'ts' x, y, blockId, text, signtype, playerId
        else if (blockId === 385) {
          const text = String(extraArgs[0] !== undefined ? extraArgs[0] : "");
          const signType = extraArgs[1] !== undefined ? Number(extraArgs[1]) : 0;
          const tsMsg = new PlayerIOMessage('ts', [x, y, blockId, text, signType, player.id]);
          this.broadcastToRoom(room, tsMsg);
        }
        // Portal: 'pt' x, y, blockId, rotation, id, target, playerId
        else if (blockId === 242 || blockId === 381) {
          const rotation = Number(extraArgs[0] || 0);
          const portalId = Number(extraArgs[1] || 0);
          const portalTarget = Number(extraArgs[2] || 0);
          const ptMsg = new PlayerIOMessage('pt', [x, y, blockId, rotation, portalId, portalTarget, player.id]);
          this.broadcastToRoom(room, ptMsg);
        }
        // World Portal: 'wp' x, y, blockId, target, spawnid, playerId
        else if (blockId === 374) {
          const wpTarget = String(extraArgs[0] || "");
          const wpSpawnId = Number(extraArgs[1] || 0);
          const wpMsg = new PlayerIOMessage('wp', [x, y, blockId, wpTarget, wpSpawnId, player.id]);
          this.broadcastToRoom(room, wpMsg);
        }
        // Sound blocks (piano=77, drums=83, guitar=1520): 'bs' x, y, blockId, sound, playerId
        else if (blockId === 77 || blockId === 83 || blockId === 1520) {
          const sound = Number(extraArgs[0] || 0);
          const bsMsg = new PlayerIOMessage('bs', [x, y, blockId, sound, player.id]);
          this.broadcastToRoom(room, bsMsg);
        }
        // NPC blocks: 'bn' x, y, blockId, name, msg1, msg2, msg3, playerId
        else if (this.isNPC(blockId)) {
          const npcName = String(extraArgs[0] || "");
          const npcMsg1 = String(extraArgs[1] || "");
          const npcMsg2 = String(extraArgs[2] || "");
          const npcMsg3 = String(extraArgs[3] || "");
          const bnMsg = new PlayerIOMessage('bn', [x, y, blockId, npcName, npcMsg1, npcMsg2, npcMsg3, player.id]);
          this.broadcastToRoom(room, bnMsg);
        }
        // Rotatable and Morphable blocks (spikes, half blocks, one-ways, pipes, etc.): 'br' x, y, blockId, rotation, layer, playerId
        else if (extraArgs.length === 1) {
          const rotation = Number(extraArgs[0] || 0);
          const brMsg = new PlayerIOMessage('br', [x, y, blockId, rotation, layer, player.id]);
          this.broadcastToRoom(room, brMsg);
        }
        // Normal blocks: 'b' layer, x, y, blockId, playerId
        else {
          const bMsg = new PlayerIOMessage('b', [layer, x, y, blockId, player.id]);
          this.broadcastToRoom(room, bMsg);
        }
        break;
      }

      case 'bc': {
        if (!player || !room) return;
        // Packet: bc, x1, y1, x2, y2, blockId
        const x1 = msg.getInt(0);
        const y1 = msg.getInt(1);
        const x2 = msg.getInt(2);
        const y2 = msg.getInt(3);
        const blockId = msg.getInt(4);

        room.world.clearArea(0, x1, y1, x2, y2, blockId);

        const bcMsg = new PlayerIOMessage('bc', [x1, y1, x2, y2, blockId, player.id]);
        this.broadcastToRoom(room, bcMsg);
        break;
      }

      case 'say': {
        if (!player || !room) return;
        if (player.username.toLowerCase().startsWith('guest')) {
          console.log(`[Chat Blocked] Guest ${player.username} attempted to chat.`);
          return;
        }
        const text = msg.getString(0);
        console.log(`[Chat] ${player.username}: ${text}`);

        // Broadcast 'say': playerId, text
        const sayMsg = new PlayerIOMessage('say', [player.id, text]);
        this.broadcastToRoom(room, sayMsg);
        break;
      }

      case 'god': {
        if (!player || !room) return;
        player.isGod = msg.getBoolean(0);

        const godMsg = new PlayerIOMessage('god', [player.id, player.isGod]);
        this.broadcastToRoom(room, godMsg);
        break;
      }

      case 'save': {
        if (!player || !room) return;
        room.world.saveToFile(this.worldsDir);

        const savedMsg = new PlayerIOMessage('saved');
        player.send(savedMsg);
        break;
      }

      case 'smiley': {
        if (!player || !room) return;
        const newFace = msg.getInt(0);
        
        // If client sends 0 immediately after room join but user has a saved non-zero face, ignore 0
        if (newFace === 0 && player.face > 0 && player.joinTimestamp && (Date.now() - player.joinTimestamp < 4000)) {
          console.log(`[Smiley] Retaining saved face ${player.face} for ${player.username} (ignored initial 0)`);
          const smileyMsg = new PlayerIOMessage('smiley', [player.id, player.face]);
          this.broadcastToRoom(room, smileyMsg);
          const faceMsg = new PlayerIOMessage('face', [player.id, player.face]);
          this.broadcastToRoom(room, faceMsg);
          break;
        }

        player.face = newFace;
        if (!player.username.toLowerCase().startsWith('guest')) {
          this.userManager.updateUser(player.username, { face: player.face });
        }
        const smileyMsg = new PlayerIOMessage('smiley', [player.id, player.face]);
        this.broadcastToRoom(room, smileyMsg);
        const faceMsg = new PlayerIOMessage('face', [player.id, player.face]);
        this.broadcastToRoom(room, faceMsg);
        break;
      }

      case 'aura': {
        if (!player || !room) return;
        player.aura = msg.getInt(0);
        player.auraColor = msg.getInt(1);
        this.userManager.updateUser(player.username, { aura: player.aura, auraColor: player.auraColor });
        const auraMsg = new PlayerIOMessage('aura', [player.id, player.aura, player.auraColor]);
        this.broadcastToRoom(room, auraMsg);
        break;
      }

      case 'smileyGoldBorder': {
        if (!player || !room) return;
        player.smileyGoldBorder = msg.getBoolean(0);
        this.userManager.updateUser(player.username, { smileyGoldBorder: player.smileyGoldBorder });
        const goldBorderMsg = new PlayerIOMessage('smileyGoldBorder', [player.id, player.smileyGoldBorder]);
        this.broadcastToRoom(room, goldBorderMsg);
        break;
      }

      case 'badge': {
        if (!player || !room) return;
        player.badge = msg.getString(0);
        this.userManager.updateUser(player.username, { badge: player.badge });
        const badgeMsg = new PlayerIOMessage('badge', [player.id, player.badge]);
        this.broadcastToRoom(room, badgeMsg);
        break;
      }

      case 'clear': {
        if (!player || !room) return;
        room.world.clearWorld();
        const clearMsg = new PlayerIOMessage('clear');
        this.broadcastToRoom(room, clearMsg);
        break;
      }

      case 'mod': {
        if (!player || !room) return;
        player.isInModMode = !player.isInModMode;
        console.log(`[Mod Mode] Player ${player.username} (ID: ${player.id}) modMode=${player.isInModMode}`);
        const modMsg = new PlayerIOMessage('mod', [player.id, player.isInModMode]);
        this.broadcastToRoom(room, modMsg);
        break;
      }

      default:
        // Echo / generic broadcast for unhandled gameplay messages
        break;
    }
  }

  broadcastToRoom(room, msg, excludePlayerId = null) {
    for (const [id, player] of room.players) {
      if (excludePlayerId !== null && id === excludePlayerId) continue;
      player.send(msg);
    }
  }
}

module.exports = Server;
