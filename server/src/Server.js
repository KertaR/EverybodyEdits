/**
 * Everybody Edits Private Server (TCP Sockets & Policy Server)
 */

const net = require('net');
const path = require('path');
const fs = require('fs');
const http = require('http');
const url = require('url');
const { PlayerIOMessage, PlayerIOProtocol } = require('./PlayerIOProtocol');
const World = require('./World');
const Player = require('./Player');
const UserManager = require('./UserManager');
const CrewManager = require('./CrewManager');
const AchievementManager = require('./AchievementManager');
const QuestManager = require('./QuestManager');

class Server {
  constructor(config = {}) {
    this.port = config.port || 8184;
    this.host = config.host || '0.0.0.0';
    this.worldsDir = path.join(__dirname, '../worlds');
    this.userManager = new UserManager(path.join(__dirname, '../'));
    this.crewManager = new CrewManager(path.join(__dirname, '../'));
    this.achievementManager = new AchievementManager(this.userManager);
    this.questManager = new QuestManager(this.userManager);

    // Rooms map: roomId -> { world: World, players: Map<id, Player>, nextPlayerId: number }
    this.rooms = new Map();
    this.tcpServer = null;
    this.logs = [];
    this.startTime = Date.now();

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

  addLog(type, text) {
    const entry = {
      timestamp: new Date().toLocaleTimeString(),
      type: type || 'info',
      text: String(text)
    };
    this.logs.push(entry);
    if (this.logs.length > 250) this.logs.shift();
  }

  getOrCreateRoom(roomId, creatorUsername = 'Admin') {
    if (!this.rooms.has(roomId)) {
      const world = new World(roomId);
      const worldFile = path.join(this.worldsDir, `${roomId}.json`);
      if (fs.existsSync(worldFile)) {
        world.loadFromFile(worldFile);
      } else {
        if (creatorUsername && !creatorUsername.toLowerCase().startsWith('guest')) {
          world.owner = creatorUsername;
          world.ownerId = creatorUsername;
        }
        world.saveToFile(this.worldsDir);
      }

      this.rooms.set(roomId, {
        id: roomId,
        world,
        players: new Map(),
        nextPlayerId: 1
      });
      console.log(`[Room] Created room: ${roomId}, owner: ${world.owner}`);
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
              const username = (data.username || '').trim();
              const password = (data.password !== undefined) ? String(data.password) : '';
              const email = (data.email || '').trim();

              if (!username) {
                res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Username required' }));
                return;
              }

              let existing = this.userManager.getUser(username);
              if (existing) {
                res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Username is already taken' }));
                return;
              }

              const user = this.userManager.register(username, password || 'user123', email);
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true, user }));
            } catch (e) {
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
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
              const username = (data.username || '').trim();
              const password = (data.password !== undefined) ? String(data.password) : '';

              if (!username) {
                res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Username required' }));
                return;
              }

              let user = this.userManager.getUser(username);
              if (!user) {
                res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Email not registered.' }));
                return;
              }

              if (user.password !== password) {
                res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Password incorrect' }));
                return;
              }

              user.lastLogin = new Date().toISOString();
              this.userManager.saveUser(user.username);

              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true, user }));
            } catch (e) {
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
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

        // API Endpoint: Get User Energy Info
        if (req.method === 'GET' && (reqPath === '/api/energy' || reqPath.startsWith('/api/energy/'))) {
          const parsedUrl = url.parse(req.url, true);
          let username = parsedUrl.query.username || (reqPath.startsWith('/api/energy/') ? decodeURIComponent(reqPath.substring('/api/energy/'.length)) : 'KertaR');
          const user = this.userManager.getUser(username);
          const energyInfo = this.userManager.getEnergyInfo(user);
          res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify({ success: true, username: user ? user.username : username, ...energyInfo }));
          return;
        }

        // API Endpoint: Get User Data by Name
        if (req.method === 'GET' && (reqPath === '/api/user' || reqPath.startsWith('/api/user/'))) {
          const parsedUrl = url.parse(req.url, true);
          let username = parsedUrl.query.username || (reqPath.startsWith('/api/user/') ? decodeURIComponent(reqPath.substring('/api/user/'.length)) : 'KertaR');
          let user = this.userManager.getUser(username);
          if (!user) {
            user = {
              username: username,
              gems: 500,
              energy: 100,
              maxEnergy: 200,
              face: 0,
              isAdmin: false,
              isGold: true,
              payVault: []
            };
          }
          const energyInfo = this.userManager.getEnergyInfo(user);
          res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify({ success: true, user, energyInfo }));
          return;
        }

        // API Endpoint: Get All Crews
        if (req.method === 'GET' && reqPath === '/api/crews') {
          const crews = this.crewManager.getAllCrewsList();
          res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify({ success: true, crews }));
          return;
        }

        // API Endpoint: Get Crew Details
        if (req.method === 'GET' && (reqPath === '/api/crew' || reqPath.startsWith('/api/crew/'))) {
          const parsedUrl = url.parse(req.url, true);
          let crewName = parsedUrl.query.name || parsedUrl.query.id || (reqPath.startsWith('/api/crew/') ? decodeURIComponent(reqPath.substring('/api/crew/'.length)) : '');
          if (crewName.toLowerCase().startsWith('crew')) crewName = crewName.substring(4);
          const crew = this.crewManager.getCrew(crewName);
          if (crew) {
            res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: true, crew }));
          } else {
            res.writeHead(404, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: false, error: 'Crew not found' }));
          }
          return;
        }

        // API Endpoint: Social - Add Friend
        if (req.method === 'POST' && reqPath === '/api/friends/add') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const { username, friendUsername } = data;
              const user = this.userManager.getUser(username);
              const friend = this.userManager.getUser(friendUsername);
              if (!user || !friend) {
                res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'User not found' }));
                return;
              }
              if (!user.friends) user.friends = [];
              if (!user.friends.includes(friend.username)) {
                user.friends.push(friend.username);
                this.userManager.saveUser(user.username);
              }
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true, friends: user.friends }));
            } catch (e) {
              res.writeHead(500, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // API Endpoint: Get Live Map & Players for Admin Panel
        if (req.method === 'GET' && reqPath === '/api/admin/live-map') {
          const parsedUrl = url.parse(req.url, true);
          const roomId = parsedUrl.query.room || 'PW_default';
          const room = this.getOrCreateRoom(roomId);
          
          const playersList = [];
          for (const p of room.players.values()) {
            playersList.push({
              id: p.id,
              username: p.username,
              x: p.x,
              y: p.y,
              face: p.face,
              isGod: Boolean(p.isGod),
              canEdit: Boolean(p.canEdit),
              isOwner: Boolean(p.isOwner),
              isAdmin: Boolean(p.isAdmin),
              isMuted: Boolean(p.isMuted)
            });
          }

          const fgArray = [];
          const bgArray = [];
          for (let y = 0; y < room.world.height; y++) {
            fgArray.push(Array.from(room.world.foreground[y]));
            bgArray.push(Array.from(room.world.background[y]));
          }

          res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify({
            success: true,
            room: {
              id: room.id,
              title: room.world.title,
              width: room.world.width,
              height: room.world.height,
              spawnX: room.world.spawnX,
              spawnY: room.world.spawnY,
              playerCount: room.players.size
            },
            players: playersList,
            foreground: fgArray,
            background: bgArray
          }));
          return;
        }

        // API Endpoint: Execute Admin Action from Web Panel
        if (req.method === 'POST' && reqPath === '/api/admin/action') {
          let body = '';
          req.on('data', chunk => { body += chunk.toString(); });
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const { action, username, roomId, amount, itemId, message, reason } = data;
              let resultMessage = '';

              if (action === 'broadcast') {
                const alertMsg = new PlayerIOMessage('write', ['* GLOBAL ANNOUNCEMENT', String(message || '')]);
                for (const r of this.rooms.values()) {
                  this.broadcastToRoom(r, alertMsg);
                }
                res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: true, message: 'Broadcast sent to all rooms' }));
                return;
              }

              const user = this.userManager.getUser(username);
              if (!user && action !== 'broadcast') {
                res.writeHead(404, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: `User '${username}' not found` }));
                return;
              }

              if (action === 'givegems') {
                const addGems = parseInt(amount) || 100;
                user.gems = (user.gems || 0) + addGems;
                this.userManager.saveUser(user.username);
                resultMessage = `Gave ${addGems} gems to ${user.username} (New total: ${user.gems})`;
              } else if (action === 'giveenergy') {
                const addEnergy = parseInt(amount) || 100;
                user.energy = Math.min(user.maxEnergy || 200, (user.energy || 0) + addEnergy);
                this.userManager.saveUser(user.username);
                resultMessage = `Gave ${addEnergy} energy to ${user.username}`;
              } else if (action === 'giveitem') {
                if (!user.payVault) user.payVault = [];
                if (!user.payVault.includes(itemId)) user.payVault.push(itemId);
                this.userManager.saveUser(user.username);
                resultMessage = `Added item '${itemId}' to ${user.username}'s payVault`;
              } else if (action === 'ban') {
                user.isBanned = true;
                user.banReason = reason || 'Banned by admin';
                this.userManager.saveUser(user.username);
                for (const r of this.rooms.values()) {
                  for (const p of r.players.values()) {
                    if (p.username.toLowerCase() === user.username.toLowerCase()) {
                      p.send(new PlayerIOMessage('write', ['* SYSTEM', `You have been banned: ${user.banReason}`]));
                      try { p.socket.destroy(); } catch (e) {}
                    }
                  }
                }
                resultMessage = `Banned player ${user.username}`;
              } else if (action === 'unban') {
                user.isBanned = false;
                delete user.banReason;
                this.userManager.saveUser(user.username);
                resultMessage = `Unbanned player ${user.username}`;
              } else if (action === 'kick') {
                for (const r of this.rooms.values()) {
                  for (const p of r.players.values()) {
                    if (p.username.toLowerCase() === user.username.toLowerCase()) {
                      p.send(new PlayerIOMessage('write', ['* SYSTEM', `You have been kicked: ${reason || 'Kicked by admin'}`]));
                      try { p.socket.destroy(); } catch (e) {}
                    }
                  }
                }
                resultMessage = `Kicked player ${user.username}`;
              } else if (action === 'mute') {
                for (const r of this.rooms.values()) {
                  for (const p of r.players.values()) {
                    if (p.username.toLowerCase() === user.username.toLowerCase()) {
                      p.isMuted = true;
                      p.send(new PlayerIOMessage('write', ['* SYSTEM', 'You have been muted by an administrator.']));
                    }
                  }
                }
                resultMessage = `Muted player ${user.username}`;
              } else if (action === 'unmute') {
                for (const r of this.rooms.values()) {
                  for (const p of r.players.values()) {
                    if (p.username.toLowerCase() === user.username.toLowerCase()) {
                      p.isMuted = false;
                      p.send(new PlayerIOMessage('write', ['* SYSTEM', 'You have been unmuted.']));
                    }
                  }
                }
                resultMessage = `Unmuted player ${user.username}`;
              } else if (action === 'givexp') {
                const addXP = parseInt(amount) || 100;
                this.achievementManager.addXP(user, addXP, (msg) => {
                  for (const r of this.rooms.values()) {
                    for (const p of r.players.values()) {
                      if (p.username.toLowerCase() === user.username.toLowerCase()) {
                        p.send(new PlayerIOMessage('write', ['* SYSTEM', msg]));
                      }
                    }
                  }
                });
                resultMessage = `Gave ${addXP} XP to ${user.username} (Level: ${user.level}, XP: ${user.xp})`;
              }

              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true, message: resultMessage }));
            } catch (e) {
              res.writeHead(500, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // API Endpoint: Get Achievements and Level Progress for User
        if (req.method === 'GET' && reqPath === '/api/admin/achievements') {
          const parsedUrl = url.parse(req.url, true);
          const username = parsedUrl.query.username || 'Admin';
          const user = this.userManager.getUser(username);
          if (!user) {
            res.writeHead(404, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: false, error: 'User not found' }));
            return;
          }
          const data = this.achievementManager.getUserAchievements(user);
          res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify({ success: true, ...data }));
          return;
        }

        // API Endpoint: Get Profile Data by Username
        if (req.method === 'GET' && (reqPath === '/api/profile' || reqPath.startsWith('/api/profile/'))) {
          const parsedUrl = url.parse(req.url, true);
          let username = parsedUrl.query.username || (reqPath.startsWith('/api/profile/') ? decodeURIComponent(reqPath.substring('/api/profile/'.length)) : '');
          if (!username) username = 'Admin';

          let user = this.userManager.getUser(username);
          if (!user) {
            user = {
              username: username,
              gems: 500,
              energy: 100,
              maxEnergy: 200,
              face: 0,
              isAdmin: false,
              isGold: true,
              payVault: []
            };
          }

          // Find worlds owned by this user
          const roomids = [];
          const roomnames = [];
          const roomplays = [];
          try {
            const files = fs.readdirSync(this.worldsDir).filter(f => f.endsWith('.json'));
            for (const file of files) {
              try {
                const wData = JSON.parse(fs.readFileSync(path.join(this.worldsDir, file), 'utf8'));
                if (wData && wData.owner && wData.owner.toLowerCase() === username.toLowerCase()) {
                  roomids.push(wData.id || file.replace('.json', ''));
                  roomnames.push(wData.title || wData.id);
                  roomplays.push(String(wData.plays || 1));
                }
              } catch (e) {}
            }
          } catch (e) {}

          if (roomids.length === 0) {
            let defaultTitle = 'Home';
            try {
              const defData = JSON.parse(fs.readFileSync(path.join(this.worldsDir, 'PW_default.json'), 'utf8'));
              if (defData && defData.title) defaultTitle = defData.title;
            } catch(e) {}
            roomids.push('PW_default');
            roomnames.push(defaultTitle);
            roomplays.push('1');
          }

          const profileData = {
            status: 'public',
            key: user.username.toLowerCase(),
            name: user.username,
            oldname: '',
            smiley: user.face !== undefined ? user.face : 0,
            maxEnergy: user.maxEnergy || 200,
            isOldBeta: true,
            isAdmin: Boolean(user.isAdmin || user.role === 'admin'),
            isGold: Boolean(user.isGold !== undefined ? user.isGold : true),
            goldremain: 0,
            goldtime: 0,
            room0: roomids[0] || 'PW_default',
            betaonlyroom: '',
            roomids: roomids,
            roomnames: roomnames,
            roomplays: roomplays,
            crews: []
          };

          res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify(profileData));
          return;
        }

        // API Endpoint: Get World Metadata by ID
        if (req.method === 'GET' && (reqPath === '/api/world' || reqPath.startsWith('/api/world/'))) {
          const parsedUrl = url.parse(req.url, true);
          let worldId = parsedUrl.query.id || (reqPath.startsWith('/api/world/') ? decodeURIComponent(reqPath.substring('/api/world/'.length)) : '');
          if (!worldId) worldId = 'PW_default';

          const worldFilePath = path.join(this.worldsDir, `${worldId}.json`);
          let worldData = {
            id: worldId,
            title: worldId,
            owner: 'Admin',
            plays: 1,
            likes: 0,
            favorites: 0,
            worlddata: [0]
          };

          if (fs.existsSync(worldFilePath)) {
            try {
              const data = JSON.parse(fs.readFileSync(worldFilePath, 'utf8'));
              worldData.title = data.title || worldId;
              worldData.owner = data.owner || 'Admin';
              worldData.plays = data.plays || 1;
              worldData.likes = data.likes || 0;
              worldData.favorites = data.favorites || 0;
              worldData.worlddata = [0];
            } catch (e) {}
          }

          res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify(worldData));
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
                  user.lastEnergyUpdate = Date.now();
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
              let needskey = false;
              try {
                const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
                if (data.title) title = data.title;
                if (data.owner) owner = data.owner;
                if (data.width) width = data.width;
                if (data.height) height = data.height;
                if (data.editKey && data.editKey.length > 0) needskey = true;
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
                onlineUsers,
                needskey
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

        // ==========================================
        // ADMIN CONTROL PANEL (ACP) REST API ENDPOINTS
        // ==========================================

        // Admin: Get Server Stats & Metrics
        if (req.method === 'GET' && reqPath === '/api/admin/stats') {
          let totalPlayers = 0;
          for (const r of this.rooms.values()) {
            totalPlayers += r.players.size;
          }
          const mem = process.memoryUsage();
          res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify({
            success: true,
            uptime: Math.floor((Date.now() - this.startTime) / 1000),
            onlinePlayers: totalPlayers,
            activeRooms: this.rooms.size,
            totalUsers: this.userManager.users.size,
            memoryMB: Math.round(mem.heapUsed / 1024 / 1024),
            rssMB: Math.round(mem.rss / 1024 / 1024),
            tcpPort: this.port,
            httpPort: 8080,
            policyPort: 843
          }));
          return;
        }

        // Admin: Get All Users
        if (req.method === 'GET' && reqPath === '/api/admin/users') {
          const usersList = [];
          for (const [key, u] of this.userManager.users) {
            usersList.push({
              username: u.username,
              email: u.email || '',
              role: u.role || (u.isAdmin ? 'admin' : (u.isMod ? 'mod' : 'user')),
              isAdmin: Boolean(u.isAdmin || u.role === 'admin'),
              isMod: Boolean(u.isMod || u.role === 'mod'),
              isBanned: Boolean(u.isBanned),
              gems: u.gems !== undefined ? u.gems : 500,
              energy: u.energy !== undefined ? u.energy : 100,
              maxEnergy: u.maxEnergy !== undefined ? u.maxEnergy : 200,
              face: u.face !== undefined ? u.face : 0,
              aura: u.aura !== undefined ? u.aura : 0,
              auraColor: u.auraColor !== undefined ? u.auraColor : 0,
              badge: u.badge || '',
              goldmember: Boolean(u.goldmember || u.isGold),
              level: u.level || this.achievementManager.calculateLevel(u.xp).level,
              xp: u.xp || 0,
              payVaultCount: Array.isArray(u.payVault) ? u.payVault.length : 0,
              payVault: u.payVault || [],
              registeredAt: u.registeredAt || '',
              lastLogin: u.lastLogin || ''
            });
          }
          res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify({ success: true, users: usersList }));
          return;
        }

        // Admin: Create or Update User
        if (req.method === 'POST' && reqPath === '/api/admin/user/save') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const username = String(data.username || '').trim();
              if (!username) {
                res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Username is required' }));
                return;
              }
              let user = this.userManager.getUser(username);
              if (!user) {
                user = this.userManager.register(username, data.password || 'user123', data.email || '');
              }
              if (data.password) user.password = data.password;
              if (data.email !== undefined) user.email = data.email;
              if (data.role !== undefined) user.role = data.role;
              if (data.isAdmin !== undefined) user.isAdmin = Boolean(data.isAdmin);
              if (data.isMod !== undefined) user.isMod = Boolean(data.isMod);
              if (data.isBanned !== undefined) user.isBanned = Boolean(data.isBanned);
              if (data.goldmember !== undefined) user.goldmember = Boolean(data.goldmember);
              if (data.level !== undefined) user.level = Number(data.level);
              if (data.xp !== undefined) user.xp = Number(data.xp);
              if (data.gems !== undefined) user.gems = Number(data.gems);
              if (data.energy !== undefined) user.energy = Number(data.energy);
              if (data.maxEnergy !== undefined) user.maxEnergy = Number(data.maxEnergy);
              if (data.face !== undefined) user.face = Number(data.face);
              if (data.aura !== undefined) user.aura = Number(data.aura);
              if (data.auraColor !== undefined) user.auraColor = Number(data.auraColor);
              if (data.badge !== undefined) user.badge = String(data.badge);
              if (Array.isArray(data.payVault)) user.payVault = data.payVault;

              this.userManager.saveUser(user.username);
              this.addLog('admin', `Admin updated user: ${user.username}`);
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true, user }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // Admin: Delete User
        if (req.method === 'POST' && reqPath === '/api/admin/user/delete') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const username = String(data.username || '').trim();
              if (!username) {
                res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Username is required' }));
                return;
              }
              this.userManager.deleteUser(username);
              this.addLog('admin', `Admin deleted user: ${username}`);
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // Admin: Get Detailed Worlds List
        if (req.method === 'GET' && reqPath === '/api/admin/worlds') {
          try {
            const files = fs.readdirSync(this.worldsDir).filter(f => f.endsWith('.json'));
            const worlds = files.map(filename => {
              const worldId = filename.replace('.json', '');
              const filePath = path.join(this.worldsDir, filename);
              let title = worldId;
              let owner = 'Admin';
              let editKey = '';
              let width = 200;
              let height = 200;
              let plays = 1;
              let likes = 0;
              let favorites = 0;
              try {
                const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
                if (data.title) title = data.title;
                if (data.owner) owner = data.owner;
                if (data.editKey) editKey = data.editKey;
                if (data.width) width = data.width;
                if (data.height) height = data.height;
                if (data.plays) plays = data.plays;
                if (data.likes) likes = data.likes;
                if (data.favorites) favorites = data.favorites;
              } catch (e) {}

              const room = this.rooms.get(worldId);
              const playersInRoom = [];
              if (room) {
                for (const p of room.players.values()) {
                  playersInRoom.push({
                    id: p.id,
                    username: p.username,
                    canEdit: Boolean(p.canEdit),
                    isGod: Boolean(p.isGod),
                    isOwner: Boolean(p.isOwner)
                  });
                }
              }

              return {
                id: worldId,
                title,
                owner,
                editKey,
                width,
                height,
                plays,
                likes,
                favorites,
                isLoaded: Boolean(room),
                onlineCount: playersInRoom.length,
                players: playersInRoom
              };
            });
            res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: true, worlds }));
          } catch (e) {
            res.writeHead(500, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: false, error: e.message }));
          }
          return;
        }

        // Admin: Save World Metadata / Create World
        if (req.method === 'POST' && reqPath === '/api/admin/world/save') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const worldId = String(data.id || '').trim();
              if (!worldId) {
                res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'World ID is required' }));
                return;
              }
              const room = this.getOrCreateRoom(worldId, data.owner || 'Admin');
              if (data.title !== undefined) room.world.title = data.title;
              if (data.owner !== undefined) room.world.owner = data.owner;
              if (data.editKey !== undefined) room.world.editKey = data.editKey;
              if (data.width !== undefined) room.world.width = Number(data.width);
              if (data.height !== undefined) room.world.height = Number(data.height);
              room.world.saveToFile(this.worldsDir);

              this.addLog('admin', `Admin saved world: ${worldId} (title: ${room.world.title})`);
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true, world: { id: room.world.id, title: room.world.title, owner: room.world.owner, editKey: room.world.editKey } }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // Admin: Delete World
        if (req.method === 'POST' && reqPath === '/api/admin/world/delete') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const worldId = String(data.id || '').trim();
              if (!worldId || worldId === 'PW_default') {
                res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Cannot delete this world' }));
                return;
              }
              if (this.rooms.has(worldId)) {
                const room = this.rooms.get(worldId);
                const kickMsg = new PlayerIOMessage('write', ['* SYSTEM', 'This world has been deleted by an Administrator.']);
                this.broadcastToRoom(room, kickMsg);
                this.rooms.delete(worldId);
              }
              const filePath = path.join(this.worldsDir, `${worldId}.json`);
              if (fs.existsSync(filePath)) {
                fs.unlinkSync(filePath);
              }
              this.addLog('admin', `Admin deleted world: ${worldId}`);
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // Admin: Broadcast System Announcement
        if (req.method === 'POST' && reqPath === '/api/admin/broadcast') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const message = String(data.message || '').trim();
              const roomId = data.roomId;
              if (!message) {
                res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Message is required' }));
                return;
              }
              const sysMsg = new PlayerIOMessage('write', ['* SYSTEM (ADMIN)', message]);
              if (roomId && this.rooms.has(roomId)) {
                this.broadcastToRoom(this.rooms.get(roomId), sysMsg);
                this.addLog('broadcast', `[Room: ${roomId}] ${message}`);
              } else {
                for (const r of this.rooms.values()) {
                  this.broadcastToRoom(r, sysMsg);
                }
                this.addLog('broadcast', `[Global] ${message}`);
              }
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // Admin: Perform Action on Player or Room
        if (req.method === 'POST' && reqPath === '/api/admin/room/action') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const { roomId, action, playerId, username } = data;
              const room = this.rooms.get(roomId);
              if (!room) {
                res.writeHead(404, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Room not currently loaded or active' }));
                return;
              }

              if (action === 'clear') {
                room.world.clear();
                this.broadcastToRoom(room, new PlayerIOMessage('clear'));
                this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', 'World cleared by Administrator.']));
                this.addLog('room', `Cleared world in room ${roomId}`);
                res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: true, message: 'World cleared' }));
                return;
              }

              let targetPlayer = null;
              if (playerId) {
                targetPlayer = room.players.get(Number(playerId));
              } else if (username) {
                const uName = username.toLowerCase();
                for (const p of room.players.values()) {
                  if (p && p.username && p.username.toLowerCase() === uName) {
                    targetPlayer = p;
                    break;
                  }
                }
              }

              if (!targetPlayer) {
                res.writeHead(404, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Player not found in room' }));
                return;
              }

              if (action === 'kick') {
                targetPlayer.send(new PlayerIOMessage('write', ['* SYSTEM', 'You have been kicked by an Administrator.']));
                targetPlayer.socket.destroy();
                this.addLog('action', `Kicked ${targetPlayer.username} from room ${roomId}`);
              } else if (action === 'giveedit') {
                targetPlayer.canEdit = true;
                targetPlayer.send(new PlayerIOMessage('access'));
                this.broadcastToRoom(room, new PlayerIOMessage('editRights', [targetPlayer.id, true]));
                this.addLog('action', `Gave edit to ${targetPlayer.username} in room ${roomId}`);
              } else if (action === 'removeedit') {
                targetPlayer.canEdit = false;
                targetPlayer.isGod = false;
                targetPlayer.send(new PlayerIOMessage('lostaccess'));
                this.broadcastToRoom(room, new PlayerIOMessage('editRights', [targetPlayer.id, false]));
                this.broadcastToRoom(room, new PlayerIOMessage('god', [targetPlayer.id, false]));
                this.addLog('action', `Removed edit from ${targetPlayer.username} in room ${roomId}`);
              } else if (action === 'givegod') {
                targetPlayer.canToggleGodMode = true;
                targetPlayer.isGod = true;
                this.broadcastToRoom(room, new PlayerIOMessage('toggleGod', [targetPlayer.id, true]));
                this.broadcastToRoom(room, new PlayerIOMessage('god', [targetPlayer.id, true]));
                this.addLog('action', `Gave god mode to ${targetPlayer.username} in room ${roomId}`);
              } else if (action === 'removegod') {
                targetPlayer.canToggleGodMode = false;
                targetPlayer.isGod = false;
                this.broadcastToRoom(room, new PlayerIOMessage('god', [targetPlayer.id, false]));
                this.broadcastToRoom(room, new PlayerIOMessage('toggleGod', [targetPlayer.id, false]));
                this.addLog('action', `Removed god mode from ${targetPlayer.username} in room ${roomId}`);
              }

              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // Admin: Get Logs
        if (req.method === 'GET' && reqPath === '/api/admin/logs') {
          res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify({ success: true, logs: this.logs }));
          return;
        }

        // Admin: Get Shop Items
        if (req.method === 'GET' && reqPath === '/api/admin/shop') {
          try {
            const shopFile = path.join(__dirname, '../shop/items.json');
            let items = [];
            if (fs.existsSync(shopFile)) {
              items = JSON.parse(fs.readFileSync(shopFile, 'utf8'));
            }
            res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: true, items }));
          } catch (e) {
            res.writeHead(500, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: false, error: e.message }));
          }
          return;
        }

        // Admin: Save Shop Items
        if (req.method === 'POST' && reqPath === '/api/admin/shop/save') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const shopFile = path.join(__dirname, '../shop/items.json');
              if (Array.isArray(data.items)) {
                fs.writeFileSync(shopFile, JSON.stringify(data.items, null, 2), 'utf8');
                this.addLog('admin', `Admin updated shop items (${data.items.length} items)`);
              }
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // Admin: List World Backups
        if (req.method === 'GET' && reqPath === '/api/admin/backups') {
          try {
            const parsedUrl = url.parse(req.url, true);
            const worldId = parsedUrl.query.worldId || null;
            const backups = World.listBackups(this.worldsDir, worldId);
            res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: true, backups }));
          } catch (e) {
            res.writeHead(500, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: false, error: e.message }));
          }
          return;
        }

        // Admin: Create World Backup
        if (req.method === 'POST' && reqPath === '/api/admin/world/backup') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const worldId = String(data.worldId || 'PW_default').trim();
              const room = this.getOrCreateRoom(worldId);
              const resBackup = room.world.createBackup(this.worldsDir, data.name || '');
              this.addLog('admin', `Created backup for world ${worldId} (${resBackup.filename})`);
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify(resBackup));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // Admin: Restore World Backup
        if (req.method === 'POST' && reqPath === '/api/admin/world/restore') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const worldId = String(data.worldId || 'PW_default').trim();
              const backupFilename = String(data.filename || '').trim();
              if (!backupFilename) {
                res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Backup filename required' }));
                return;
              }
              const room = this.getOrCreateRoom(worldId);
              const resRestore = room.world.restoreFromBackup(this.worldsDir, backupFilename);
              if (resRestore.success) {
                // Broadcast world reset to all players in the room
                const clearMsg = new PlayerIOMessage('clear');
                this.broadcastToRoom(room, clearMsg);
                for (let y = 0; y < room.world.height; y++) {
                  for (let x = 0; x < room.world.width; x++) {
                    const fg = room.world.getBlock(0, x, y);
                    if (fg > 0) {
                      this.broadcastToRoom(room, new PlayerIOMessage('b', [0, x, y, fg, 0]));
                    }
                    const bg = room.world.getBlock(1, x, y);
                    if (bg > 0) {
                      this.broadcastToRoom(room, new PlayerIOMessage('b', [1, x, y, bg, 0]));
                    }
                  }
                }
                this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `World restored from backup: ${backupFilename}`]));
                this.addLog('admin', `Admin restored world ${worldId} from backup ${backupFilename}`);
              }
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify(resRestore));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // Admin: Live World Painter Set Block
        if (req.method === 'POST' && reqPath === '/api/admin/world/setblock') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const worldId = String(data.worldId || 'PW_default').trim();
              const layer = Number(data.layer || 0);
              const x = Number(data.x);
              const y = Number(data.y);
              const blockId = Number(data.blockId || 0);
              const room = this.getOrCreateRoom(worldId);

              room.world.setBlock(layer, x, y, blockId);
              room.world.saveToFile(this.worldsDir);

              const bMsg = new PlayerIOMessage('b', [layer, x, y, blockId, 0]);
              this.broadcastToRoom(room, bMsg);

              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // API Endpoint: Get Daily Quests & Streak for User
        if (req.method === 'GET' && (reqPath === '/api/quests' || reqPath.startsWith('/api/quests/'))) {
          const parsedUrl = url.parse(req.url, true);
          let username = parsedUrl.query.username || (reqPath.startsWith('/api/quests/') ? decodeURIComponent(reqPath.substring('/api/quests/'.length)) : 'Admin');
          const user = this.userManager.getUser(username);
          if (!user) {
            res.writeHead(404, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
            res.end(JSON.stringify({ success: false, error: 'User not found' }));
            return;
          }
          const questsData = this.questManager.getUserQuests(user);
          res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify({ success: true, quests: questsData }));
          return;
        }

        // Admin: Save Crew
        if (req.method === 'POST' && reqPath === '/api/admin/crew/save') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const crewId = String(data.id || '').toLowerCase().trim();
              if (!crewId) {
                res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
                res.end(JSON.stringify({ success: false, error: 'Crew ID required' }));
                return;
              }
              const crewsDir = path.join(__dirname, '../crews');
              if (!fs.existsSync(crewsDir)) fs.mkdirSync(crewsDir, { recursive: true });
              const crewFile = path.join(crewsDir, `${crewId}.json`);
              fs.writeFileSync(crewFile, JSON.stringify(data, null, 2), 'utf8');
              this.addLog('admin', `Admin saved crew: ${data.name || crewId}`);
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        // Admin: Delete Crew
        if (req.method === 'POST' && reqPath === '/api/admin/crew/delete') {
          let body = '';
          req.on('data', chunk => body += chunk.toString());
          req.on('end', () => {
            try {
              const data = JSON.parse(body || '{}');
              const crewId = String(data.id || '').toLowerCase().trim();
              const crewFile = path.join(__dirname, `../crews/${crewId}.json`);
              if (fs.existsSync(crewFile)) {
                fs.unlinkSync(crewFile);
                this.addLog('admin', `Admin deleted crew: ${crewId}`);
              }
              res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: true }));
            } catch (e) {
              res.writeHead(400, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
              res.end(JSON.stringify({ success: false, error: e.message }));
            }
          });
          return;
        }

        if (reqPath === '/' || reqPath === '') reqPath = '/index.html';
        if (reqPath === '/admin' || reqPath === '/admin/') reqPath = '/admin.html';
        const filePath = path.join(__dirname, '../../', reqPath);

        if (fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
          const ext = path.extname(filePath).toLowerCase();
          const mimeTypes = {
            '.html': 'text/html',
            '.swf': 'application/x-shockwave-flash',
            '.js': 'text/javascript',
            '.css': 'text/css',
            '.json': 'application/json',
            '.png': 'image/png',
            '.jpg': 'image/jpeg',
            '.jpeg': 'image/jpeg',
            '.svg': 'image/svg+xml'
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

  getOnlineGuestCount() {
    let count = 0;
    for (const room of this.rooms.values()) {
      for (const p of room.players.values()) {
        if (p && p.username && (p.username.toLowerCase().startsWith('guest') || p.username.includes('-'))) {
          count++;
        }
      }
    }
    return count;
  }

  generateGuestUsername() {
    const onlineGuestCount = this.getOnlineGuestCount();
    let n = onlineGuestCount + 1;
    let candidate = `Guest-${n}`;

    const isUsed = (name) => {
      for (const room of this.rooms.values()) {
        for (const p of room.players.values()) {
          if (p && p.username && p.username.toLowerCase() === name.toLowerCase()) {
            return true;
          }
        }
      }
      return false;
    };

    while (isUsed(candidate)) {
      n++;
      candidate = `Guest-${n}`;
    }
    return candidate;
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

        let username;
        if (connectUserId && connectUserId.startsWith('simple') && connectUserId !== 'simpleguest') {
          username = connectUserId.substring(6);
        } else if (connectUserId && connectUserId !== 'simpleguest') {
          username = connectUserId;
        } else {
          username = this.generateGuestUsername();
        }

        let userData = this.userManager.getUser(username);
        if (!userData) {
          userData = this.userManager.register(username, 'user123');
        }

        room = this.getOrCreateRoom(roomId, username);
        const playerId = room.nextPlayerId++;

        player = new Player(playerId, socket, userData.username);
        player.face = userData.face !== undefined ? userData.face : 0;
        player.aura = userData.aura !== undefined ? userData.aura : 0;
        player.auraColor = userData.auraColor !== undefined ? userData.auraColor : 0;
        player.badge = userData.badge || '';
        player.smileyGoldBorder = userData.smileyGoldBorder !== undefined ? userData.smileyGoldBorder : true;
        player.country = (userData && userData.country) ? userData.country.toUpperCase() : 'HU';
        player.joinTimestamp = Date.now();

        const isWorldOwner = Boolean(room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
        const isAdmin = Boolean(userData && (userData.isAdmin || userData.role === 'admin'));
        player.isAdmin = isAdmin;
        player.isMod = isAdmin || Boolean(userData && userData.isMod);
        player.isOwner = isWorldOwner || isAdmin;

        const hasValidEditKey = Boolean(room.world.editKey && editKey && room.world.editKey === editKey);
        player.canEdit = isWorldOwner || isAdmin || hasValidEditKey;
        player.isGod = player.canEdit;
        player.canToggleGodMode = player.canEdit;
        room.players.set(player.id, player);
        setPlayerRoom(player, room);

        console.log(`[Join] Player ${player.username} (ID: ${player.id}, canEdit: ${player.canEdit}, isOwner: ${player.isOwner}) joined room ${room.id} with editKey='${editKey}'`);

        // Send 'playerio.joinresult' to tell the client join was successful
        const joinResultMsg = new PlayerIOMessage('playerio.joinresult');
        joinResultMsg.add(true);
        player.send(joinResultMsg);
        break;
      }

      case 'init': {
        if (!player || !room) return;
        console.log(`[Init] Client requested init for player ${player.username} (ID: ${player.id}) in room ${room.id}`);

        const spawnPoint = room.world.findSpawnPoint();
        player.x = spawnPoint.x * 16;
        player.y = spawnPoint.y * 16;
        console.log(`[Spawn] Spawning player ${player.username} at (${spawnPoint.x}, ${spawnPoint.y}) -> (${player.x}, ${player.y} px)`);

        // Construct & Send 'init' message matching EverybodyEdits.as & PlayState.as expectations
        const initMsg = new PlayerIOMessage('init');
        initMsg.add(room.world.owner);           // param2: Owner Username
        initMsg.add(room.world.title);           // param3: Level Name
        initMsg.add(room.world.plays || 0);      // param4: Plays/Views
        initMsg.add(room.world.favorites || 0);  // param5: Favorites
        initMsg.add(room.world.likes || 0);      // param6: Likes
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
        initMsg.add(room.world.description || ''); // param27: Room Description
        initMsg.add(0);                          // param28: Effect Limit 1
        initMsg.add(0);                          // param29: Effect Limit 2
        initMsg.add(false);                      // param30: Is Campaign Room
        initMsg.add(String(room.world.crewId || ''));          // param31: Crew ID
        initMsg.add(String(room.world.crewName || ''));        // param32: Crew Name
        initMsg.add(true);                       // param33: Can Change World Options
        initMsg.add(0);                          // param34: Status
        initMsg.add(player.badge);               // param35: Badge
        initMsg.add(Boolean(player.crew && room.world.crewId && player.crew.toLowerCase() === room.world.crewId.toLowerCase())); // param36: Crew Member
        initMsg.add(false);                      // param37: Minimap Enabled
        initMsg.add(false);                      // param38: Lobby Preview
        initMsg.add(Buffer.alloc(0));            // param39: Active Orange Switches (empty ByteArray)
        initMsg.add(false);                      // param40: Crew Visible
        initMsg.add(room.world.ownerId);         // param41: Owner ID
        initMsg.add(true);                       // param42: Can Toggle God Mode

        // Add serialized world blocks ("ws" ... "we")
        room.world.serializeToInitMessage(initMsg);

        player.send(initMsg);

        // Send roomLocked state
        player.send(new PlayerIOMessage('roomLocked', [Boolean(room.world.isLocked)]));

        // Track world visit stat for achievements and process daily login bonus
        const uInit = this.userManager.getUser(player.username);
        if (uInit) {
          this.achievementManager.trackStat(uInit, 'worldsVisited', room.id, (msg) => {
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', msg]));
          });
          const streakData = this.questManager.processDailyLogin(uInit);
          if (streakData && streakData.streakAwarded) {
            const dailyMsg = new PlayerIOMessage('dailyReward');
            dailyMsg.add(streakData.streak);
            dailyMsg.add(streakData.rewardGems);
            dailyMsg.add(streakData.rewardEnergy);
            dailyMsg.add(streakData.rewardXP);
            dailyMsg.add(false);
            player.send(dailyMsg);
          }
        }

        // Send 'add', 'userCountry', and 'freeze' message for all existing players to the new player
        for (const [otherId, otherPlayer] of room.players) {
          if (otherId !== player.id) {
            const addMsg = new PlayerIOMessage('add', otherPlayer.getAddMessageData());
            player.send(addMsg);
            player.send(new PlayerIOMessage('userCountry', [otherId, otherPlayer.country || 'HU']));
            if (otherPlayer.isFrozen) {
              player.send(new PlayerIOMessage('freeze', [otherId, true]));
            }
          }
        }

        player.send(new PlayerIOMessage('userCountry', [player.id, player.country || 'HU']));
        if (player.isFrozen) {
          player.send(new PlayerIOMessage('freeze', [player.id, true]));
        }

        // Broadcast 'add' and 'userCountry' message of new player to all existing players
        const newAddMsg = new PlayerIOMessage('add', player.getAddMessageData());
        this.broadcastToRoom(room, newAddMsg, player.id);
        this.broadcastToRoom(room, new PlayerIOMessage('userCountry', [player.id, player.country || 'HU']), player.id);
        break;
      }

      case 'm': {
        if (!player || !room) return;
        if (player.isFrozen) {
          player.speedX = 0;
          player.speedY = 0;
          player.send(new PlayerIOMessage('tele', [player.id, player.x, player.y]));
          return;
        }
        // Packet from Me.as: m, x (0), y (1), speedX (2), speedY (3), modifierX (4), modifierY (5), horizontal (6), vertical (7), gravityMultiplier (8), spacedown (9), spacejustdown (10), tickID (11)
        player.x = msg.getFloat(0);
        player.y = msg.getFloat(1);
        player.speedX = msg.getFloat(2);
        player.speedY = msg.getFloat(3);
        player.modifierX = msg.getFloat(4);
        player.modifierY = msg.getFloat(5);
        player.horizontal = msg.getFloat(6);
        player.vertical = msg.getFloat(7);
        player.gravityMultiplier = msg.getFloat(8);
        player.spacedown = Boolean(msg.getBoolean(9));
        player.spacejustdown = Boolean(msg.getBoolean(10));

        // Convert unsigned int 4294967295 to signed -1
        if (player.modifierX > 0x7FFFFFFF) player.modifierX = (player.modifierX | 0);
        if (player.modifierY > 0x7FFFFFFF) player.modifierY = (player.modifierY | 0);
        if (player.horizontal > 0x7FFFFFFF) player.horizontal = (player.horizontal | 0);
        if (player.vertical > 0x7FFFFFFF) player.vertical = (player.vertical | 0);

        // Track jump stat
        if (player.spacejustdown) {
          const uJump = this.userManager.getUser(player.username);
          if (uJump) {
            this.achievementManager.trackStat(uJump, 'jumps', 1, (msg) => {
              this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', msg]));
            });
            this.questManager.trackDailyStat(uJump, 'dailyJumps', 1, (msg) => {
              this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', msg]));
            });
          }
        }

        // Broadcast 'm' to all other players in room (matching PlayState.as 'm' handler)
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
        if (room.world.isLocked && !player.isOwner && !player.isAdmin) {
          player.send(new PlayerIOMessage('write', ['* SYSTEM', 'This world is currently locked.']));
          return;
        }
        if (room.world.allowGuests === false && player.username.toLowerCase().startsWith('guest')) {
          player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Guest building is disabled in this room.']));
          return;
        }
        if (!player.canEdit) {
          console.log(`[Block Place Blocked] Player ${player.username} does not have edit rights.`);
          return;
        }
        // Packet: b, layer, x, y, blockId, [extra args]
        const layer = msg.getInt(0);
        const x = msg.getInt(1);
        const y = msg.getInt(2);
        const blockId = msg.getInt(3);

        const extraArgs = msg.values.slice(4);
        room.world.setBlock(layer, x, y, blockId, extraArgs.length > 0 ? extraArgs : null);

        // Update world spawn point if block 255 (Spawn Point) is placed or removed
        if (layer === 0) {
          if (blockId === 255) {
            room.world.spawnX = x;
            room.world.spawnY = y;
            console.log(`[Spawn] World ${room.id} spawn point updated to (${x}, ${y}) by ${player.username}`);
          } else if (room.world.spawnX === x && room.world.spawnY === y && blockId === 0) {
            const sp = room.world.findSpawnPoint();
            room.world.spawnX = sp.x;
            room.world.spawnY = sp.y;
            console.log(`[Spawn] Spawn removed, reset to (${room.world.spawnX}, ${room.world.spawnY})`);
          }
        }

        // Track blocksPlaced stat
        const uBlock = this.userManager.getUser(player.username);
        if (uBlock) {
          this.achievementManager.trackStat(uBlock, 'blocksPlaced', 1, (msg) => {
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', msg]));
          });
          this.questManager.trackDailyStat(uBlock, 'dailyBlocksPlaced', 1, (msg) => {
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', msg]));
          });
        }

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

      case 'name': {
        if (!player || !room) return;
        const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
        if (!isOwnerOrStaff) {
          player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only the world owner or staff can change the world title.']));
          return;
        }
        const newTitle = String(msg.getString(0) || '').trim().substring(0, 50);
        if (!newTitle) {
          player.send(new PlayerIOMessage('write', ['* SYSTEM', 'World title cannot be empty.']));
          return;
        }
        room.world.title = newTitle;
        room.world.saveToFile(this.worldsDir);

        // Broadcast updatemeta to everyone in the room: owner, title, plays, favorites, likes
        const updateMetaMsg = new PlayerIOMessage('updatemeta', [
          room.world.owner || 'Admin',
          room.world.title,
          room.world.plays || 0,
          room.world.favorites || 0,
          room.world.likes || 0
        ]);
        this.broadcastToRoom(room, updateMetaMsg);
        this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `📝 World title changed to: "${newTitle}" by ${player.username}.`]));
        console.log(`[World Name] Room ${room.id} renamed to "${newTitle}" by ${player.username}`);
        break;
      }

      case 'key': {
        if (!player || !room) return;
        if (!player.isOwner && !player.isAdmin) {
          player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to change the room edit key.']));
          return;
        }
        const newKey = msg.getString(0) || '';
        room.world.editKey = newKey;
        room.world.saveToFile(this.worldsDir);
        console.log(`[World Key] Player ${player.username} updated editKey to '${newKey}' for room ${room.id}`);
        player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Room edit key updated and saved.']));
        break;
      }

      case 'access': {
        if (!player || !room) return;
        if (room.world.isLocked && !player.isOwner && !player.isAdmin) {
          player.send(new PlayerIOMessage('write', ['* SYSTEM', 'This world is locked by staff. Access keys cannot be entered.']));
          return;
        }
        const key = msg.getString(0) || '';
        if (room.world.editKey && room.world.editKey !== key) {
          player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Invalid edit key.']));
          return;
        }
        player.canEdit = true;
        player.send(new PlayerIOMessage('access'));
        this.broadcastToRoom(room, new PlayerIOMessage('editRights', [player.id, true]));
        this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} gained edit rights.`]));
        break;
      }

      case 'getQuests': {
        if (!player || !room) return;
        const uQuests = this.userManager.getUser(player.username);
        if (!uQuests) return;
        const qData = this.questManager.getUserQuests(uQuests);
        const resp = new PlayerIOMessage('questsData');
        resp.add(qData.streak);
        resp.add(qData.quests.length);
        for (const q of qData.quests) {
          resp.add(q.title);
          resp.add(q.desc);
          resp.add(q.current);
          resp.add(q.target);
          resp.add(q.completed);
          resp.add(q.rewardGems);
          resp.add(q.rewardXP);
        }
        player.send(resp);
        break;
      }

      case 'say': {
        if (!player || !room) return;
        const text = msg.getString(0) || '';

        // Handle chat commands starting with /
        if (text.startsWith('/')) {
          console.log(`[Command] ${player.username} executed: ${text}`);
          const parts = text.slice(1).trim().split(/\s+/);
          const cmd = parts[0].toLowerCase();
          const args = parts.slice(1);

          if (cmd === 'removeedit' || cmd === 'redit') {
            let targetPlayer = null;
            if (args.length === 0 || args[0].toLowerCase() === player.username.toLowerCase()) {
              targetPlayer = player;
            } else {
              const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
              if (!isOwnerOrStaff) {
                player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to remove edit rights from others.']));
                return;
              }
              const targetName = args[0].toLowerCase();
              for (const p of room.players.values()) {
                if (p && p.username && p.username.toLowerCase() === targetName) {
                  targetPlayer = p;
                  break;
                }
              }
            }

            if (!targetPlayer) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${args[0]}' not found in this room.`]));
              return;
            }

            targetPlayer.canEdit = false;
            targetPlayer.isGod = false;
            targetPlayer.send(new PlayerIOMessage('lostaccess'));
            this.broadcastToRoom(room, new PlayerIOMessage('editRights', [targetPlayer.id, false]));
            this.broadcastToRoom(room, new PlayerIOMessage('god', [targetPlayer.id, false]));

            if (targetPlayer.id === player.id) {
              this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} removed their edit rights.`]));
            } else {
              this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} removed edit rights from ${targetPlayer.username}.`]));
            }
            return;
          }

          if (cmd === 'giveedit' || cmd === 'gedit') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to give edit rights.']));
              return;
            }
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /giveedit <username>']));
              return;
            }
            const targetName = args[0].toLowerCase();
            let targetPlayer = null;
            for (const p of room.players.values()) {
              if (p && p.username && p.username.toLowerCase() === targetName) {
                targetPlayer = p;
                break;
              }
            }
            if (!targetPlayer) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${args[0]}' not found in this room.`]));
              return;
            }

            targetPlayer.canEdit = true;
            targetPlayer.send(new PlayerIOMessage('access'));
            this.broadcastToRoom(room, new PlayerIOMessage('editRights', [targetPlayer.id, true]));
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} gave edit rights to ${targetPlayer.username}.`]));
            return;
          }

          if (cmd === 'givegod') {
            let targetPlayer = null;
            if (args.length === 0 || args[0].toLowerCase() === player.username.toLowerCase()) {
              targetPlayer = player;
              const hasGodPermission = player.isOwner || player.isAdmin || player.isMod || player.canEdit || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
              if (!hasGodPermission) {
                player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to enable god mode.']));
                return;
              }
            } else {
              const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
              if (!isOwnerOrStaff) {
                player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to give god mode to others.']));
                return;
              }
              const targetName = args[0].toLowerCase();
              for (const p of room.players.values()) {
                if (p && p.username && p.username.toLowerCase() === targetName) {
                  targetPlayer = p;
                  break;
                }
              }
            }

            if (!targetPlayer) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${args[0]}' not found in this room.`]));
              return;
            }

            targetPlayer.canToggleGodMode = true;
            targetPlayer.isGod = true;
            this.broadcastToRoom(room, new PlayerIOMessage('toggleGod', [targetPlayer.id, true]));
            this.broadcastToRoom(room, new PlayerIOMessage('god', [targetPlayer.id, true]));

            if (targetPlayer.id === player.id) {
              this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} enabled god mode.`]));
            } else {
              this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} gave god mode to ${targetPlayer.username}.`]));
            }
            return;
          }

          if (cmd === 'removegod') {
            let targetPlayer = null;
            if (args.length === 0 || args[0].toLowerCase() === player.username.toLowerCase()) {
              targetPlayer = player;
            } else {
              const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
              if (!isOwnerOrStaff) {
                player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to remove god mode from others.']));
                return;
              }
              const targetName = args[0].toLowerCase();
              for (const p of room.players.values()) {
                if (p && p.username && p.username.toLowerCase() === targetName) {
                  targetPlayer = p;
                  break;
                }
              }
            }

            if (!targetPlayer) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${args[0]}' not found in this room.`]));
              return;
            }

            targetPlayer.canToggleGodMode = targetPlayer.canEdit;
            targetPlayer.isGod = false;
            this.broadcastToRoom(room, new PlayerIOMessage('god', [targetPlayer.id, false]));
            this.broadcastToRoom(room, new PlayerIOMessage('toggleGod', [targetPlayer.id, targetPlayer.canToggleGodMode]));

            if (targetPlayer.id === player.id) {
              this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} disabled god mode.`]));
            } else {
              this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} removed god mode from ${targetPlayer.username}.`]));
            }
            return;
          }

          if (cmd === 'fill') {
            const hasPermission = player.canEdit || player.isOwner || player.isAdmin || player.isMod;
            if (!hasPermission) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You need edit rights to use /fill.']));
              return;
            }
            if (args.length < 5) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /fill <x1> <y1> <x2> <y2> <blockId>']));
              return;
            }
            const x1 = parseInt(args[0]), y1 = parseInt(args[1]), x2 = parseInt(args[2]), y2 = parseInt(args[3]), blockId = parseInt(args[4]);
            if (isNaN(x1) || isNaN(y1) || isNaN(x2) || isNaN(y2) || isNaN(blockId)) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Coordinates and blockId must be numbers.']));
              return;
            }
            const res = room.world.fillArea(0, x1, y1, x2, y2, blockId);
            const bcMsg = new PlayerIOMessage('bc', [res.minX, res.minY, res.maxX, res.maxY, blockId, player.id]);
            this.broadcastToRoom(room, bcMsg);
            room.world.saveToFile(this.worldsDir);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} filled ${res.count} blocks with ID ${blockId}. (Use /undo to revert)`]));
            return;
          }

          if (cmd === 'bgfill') {
            const hasPermission = player.canEdit || player.isOwner || player.isAdmin || player.isMod;
            if (!hasPermission) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You need edit rights to use /bgfill.']));
              return;
            }
            if (args.length < 5) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /bgfill <x1> <y1> <x2> <y2> <bgBlockId>']));
              return;
            }
            const x1 = parseInt(args[0]), y1 = parseInt(args[1]), x2 = parseInt(args[2]), y2 = parseInt(args[3]), bgId = parseInt(args[4]);
            if (isNaN(x1) || isNaN(y1) || isNaN(x2) || isNaN(y2) || isNaN(bgId)) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Coordinates and bgId must be numbers.']));
              return;
            }
            const res = room.world.fillArea(1, x1, y1, x2, y2, bgId);
            for (const b of res.changedBlocks) {
              this.broadcastToRoom(room, new PlayerIOMessage('b', [1, b.x, b.y, bgId, player.id]));
            }
            room.world.saveToFile(this.worldsDir);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} filled ${res.count} background blocks. (Use /undo to revert)`]));
            return;
          }

          if (cmd === 'replace') {
            const hasPermission = player.canEdit || player.isOwner || player.isAdmin || player.isMod;
            if (!hasPermission) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You need edit rights to use /replace.']));
              return;
            }
            let fromId, toId, rect = null;
            if (args.length === 2) {
              fromId = parseInt(args[0]);
              toId = parseInt(args[1]);
            } else if (args.length === 6) {
              rect = { x1: parseInt(args[0]), y1: parseInt(args[1]), x2: parseInt(args[2]), y2: parseInt(args[3]) };
              fromId = parseInt(args[4]);
              toId = parseInt(args[5]);
            } else {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /replace <fromId> <toId> OR /replace <x1> <y1> <x2> <y2> <fromId> <toId>']));
              return;
            }
            const res = room.world.replaceBlocks(0, fromId, toId, rect);
            for (const b of res.changedBlocks) {
              this.broadcastToRoom(room, new PlayerIOMessage('b', [0, b.x, b.y, toId, player.id]));
            }
            room.world.saveToFile(this.worldsDir);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} replaced ${res.count} blocks (${fromId} -> ${toId}). (Use /undo to revert)`]));
            return;
          }

          if (cmd === 'undo') {
            const hasPermission = player.canEdit || player.isOwner || player.isAdmin || player.isMod;
            if (!hasPermission) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You need edit rights to use /undo.']));
              return;
            }
            const res = room.world.undo();
            if (!res) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Nothing to undo!']));
              return;
            }
            for (const b of res.restored) {
              this.broadcastToRoom(room, new PlayerIOMessage('b', [b.layer, b.x, b.y, b.blockId, player.id]));
            }
            room.world.saveToFile(this.worldsDir);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} undone the last '${res.action}' action (${res.count} blocks restored).`]));
            return;
          }

          if (cmd === 'setspawn') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only room owner or staff can set the spawn location.']));
              return;
            }
            let spawnX = Math.round(player.x / 16) || 16;
            let spawnY = Math.round(player.y / 16) || 16;
            if (args.length >= 2) {
              spawnX = parseInt(args[0]) || spawnX;
              spawnY = parseInt(args[1]) || spawnY;
            }
            room.world.spawnX = spawnX;
            room.world.spawnY = spawnY;
            room.world.saveToFile(this.worldsDir);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `Spawn point set to (${spawnX}, ${spawnY}) by ${player.username}!`]));
            return;
          }

          if (cmd === 'worldtitle' || cmd === 'title') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only room owner or staff can change world title.']));
              return;
            }
            const newTitle = args.join(' ');
            if (!newTitle) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /worldtitle <new title>']));
              return;
            }
            room.world.title = newTitle;
            room.world.saveToFile(this.worldsDir);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `World title changed to '${newTitle}' by ${player.username}.`]));
            return;
          }

          if (cmd === 'worlddesc' || cmd === 'desc') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only room owner or staff can change world description.']));
              return;
            }
            const newDesc = args.join(' ');
            room.world.description = newDesc;
            room.world.saveToFile(this.worldsDir);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `World description updated by ${player.username}.`]));
            return;
          }

          if (cmd === 'export') {
            const exportDir = path.join(this.worldsDir, 'exports');
            if (!fs.existsSync(exportDir)) fs.mkdirSync(exportDir, { recursive: true });
            const cleanName = (args[0] || `${room.id}_export_${Date.now()}`).replace(/[^a-zA-Z0-9_-]/g, '');
            const exportPath = path.join(exportDir, `${cleanName}.json`);
            room.world.saveToFile(exportDir);
            fs.copyFileSync(path.join(this.worldsDir, `${room.id}.json`), exportPath);
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `World exported successfully to: server/worlds/exports/${cleanName}.json`]));
            return;
          }

          if (cmd === 'tp') {
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /tp <username>']));
              return;
            }
            const targetName = args[0].toLowerCase();
            let target = null;
            for (const p of room.players.values()) {
              if (p.username.toLowerCase() === targetName) { target = p; break; }
            }
            if (!target) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${args[0]}' not found.`]));
              return;
            }
            player.x = target.x;
            player.y = target.y;
            this.broadcastToRoom(room, new PlayerIOMessage('tele', [player.id, player.x, player.y]));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `Teleported to ${target.username}.`]));
            return;
          }

          if (cmd === 'clear') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to clear the world.']));
              return;
            }
            const res = room.world.clearWorld();
            const clearMsg = new PlayerIOMessage('clear');
            this.broadcastToRoom(room, clearMsg);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} cleared the world (${res.count} blocks removed). (Use /undo to revert)`]));
            return;
          }

          if (cmd === 'tphere') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to teleport players to you.']));
              return;
            }
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /tphere <username>']));
              return;
            }
            const targetName = args[0].toLowerCase();
            let target = null;
            for (const p of room.players.values()) {
              if (p.username.toLowerCase() === targetName) { target = p; break; }
            }
            if (!target) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${args[0]}' not found.`]));
              return;
            }
            target.x = player.x;
            target.y = player.y;
            this.broadcastToRoom(room, new PlayerIOMessage('tele', [target.id, target.x, target.y]));
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} teleported ${target.username} to their location.`]));
            return;
          }

          if (cmd === 'kick') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to kick players.']));
              return;
            }
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /kick <username> [reason]']));
              return;
            }
            const targetName = args[0].toLowerCase();
            const reason = args.slice(1).join(' ') || 'Kicked by moderator';
            let target = null;
            for (const p of room.players.values()) {
              if (p.username.toLowerCase() === targetName) { target = p; break; }
            }
            if (!target) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${args[0]}' not found.`]));
              return;
            }
            target.send(new PlayerIOMessage('write', ['* SYSTEM', `You were kicked: ${reason}`]));
            try { target.socket.destroy(); } catch (e) {}
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${target.username} was kicked by ${player.username} (${reason}).`]));
            return;
          }

          if (cmd === 'ban') {
            const isStaff = player.isAdmin || player.isMod;
            if (!isStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only server administrators/moderators can ban players.']));
              return;
            }
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /ban <username> [reason]']));
              return;
            }
            const targetName = args[0].toLowerCase();
            const reason = args.slice(1).join(' ') || 'Banned by moderator';
            const user = this.userManager.getUser(targetName);
            if (!user) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `User '${args[0]}' not found in database.`]));
              return;
            }
            user.isBanned = true;
            user.banReason = reason;
            this.userManager.saveUser(user.username);
            for (const r of this.rooms.values()) {
              for (const p of r.players.values()) {
                if (p.username.toLowerCase() === targetName) {
                  p.send(new PlayerIOMessage('write', ['* SYSTEM', `You have been banned: ${reason}`]));
                  try { p.socket.destroy(); } catch (e) {}
                }
              }
            }
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${user.username} was BANNED by ${player.username} (${reason}).`]));
            return;
          }

          if (cmd === 'unban') {
            const isStaff = player.isAdmin || player.isMod;
            if (!isStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only server administrators can unban players.']));
              return;
            }
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /unban <username>']));
              return;
            }
            const user = this.userManager.getUser(args[0]);
            if (!user) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `User '${args[0]}' not found.`]));
              return;
            }
            user.isBanned = false;
            delete user.banReason;
            this.userManager.saveUser(user.username);
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `Unbanned user ${user.username}.`]));
            return;
          }

          if (cmd === 'mute') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to mute players.']));
              return;
            }
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /mute <username>']));
              return;
            }
            const targetName = args[0].toLowerCase();
            let target = null;
            for (const p of room.players.values()) {
              if (p.username.toLowerCase() === targetName) { target = p; break; }
            }
            if (!target) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${args[0]}' not found.`]));
              return;
            }
            target.isMuted = true;
            target.send(new PlayerIOMessage('write', ['* SYSTEM', 'You have been muted by a moderator.']));
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${target.username} was muted by ${player.username}.`]));
            return;
          }

          if (cmd === 'unmute') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to unmute players.']));
              return;
            }
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /unmute <username>']));
              return;
            }
            const targetName = args[0].toLowerCase();
            let target = null;
            for (const p of room.players.values()) {
              if (p.username.toLowerCase() === targetName) { target = p; break; }
            }
            if (target) {
              target.isMuted = false;
              target.send(new PlayerIOMessage('write', ['* SYSTEM', 'You have been unmuted.']));
            }
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `Unmuted player '${args[0]}'.`]));
            return;
          }

          if (cmd === 'givegems') {
            const isStaff = player.isAdmin || player.isMod;
            if (!isStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only server administrators can give gems.']));
              return;
            }
            if (args.length < 2) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /givegems <username> <amount>']));
              return;
            }
            const targetUser = this.userManager.getUser(args[0]);
            const amount = parseInt(args[1]);
            if (!targetUser || isNaN(amount)) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Invalid user or amount.']));
              return;
            }
            targetUser.gems = (targetUser.gems || 0) + amount;
            this.userManager.saveUser(targetUser.username);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} gave ${amount} gems to ${targetUser.username}! (Total: ${targetUser.gems})`]));
            return;
          }

          if (cmd === 'giveenergy') {
            const isStaff = player.isAdmin || player.isMod;
            if (!isStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only server administrators can give energy.']));
              return;
            }
            if (args.length < 2) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /giveenergy <username> <amount>']));
              return;
            }
            const targetUser = this.userManager.getUser(args[0]);
            const amount = parseInt(args[1]);
            if (!targetUser || isNaN(amount)) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Invalid user or amount.']));
              return;
            }
            targetUser.energy = Math.min(targetUser.maxEnergy || 200, (targetUser.energy || 0) + amount);
            this.userManager.saveUser(targetUser.username);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} gave ${amount} energy to ${targetUser.username}!`]));
            return;
          }

          if (cmd === 'giveitem') {
            const isStaff = player.isAdmin || player.isMod;
            if (!isStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only server administrators can give items.']));
              return;
            }
            if (args.length < 2) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /giveitem <username> <itemId>']));
              return;
            }
            const targetUser = this.userManager.getUser(args[0]);
            const itemId = args[1];
            if (!targetUser) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'User not found.']));
              return;
            }
            if (!targetUser.payVault) targetUser.payVault = [];
            if (!targetUser.payVault.includes(itemId)) targetUser.payVault.push(itemId);
            this.userManager.saveUser(targetUser.username);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} granted item '${itemId}' to ${targetUser.username}!`]));
            return;
          }

          if (cmd === 'broadcast' || cmd === 'alert') {
            const isStaff = player.isAdmin || player.isMod;
            if (!isStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only server administrators can broadcast.']));
              return;
            }
            const alertText = args.join(' ');
            if (!alertText) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /broadcast <message>']));
              return;
            }
            const globalMsg = new PlayerIOMessage('write', ['* GLOBAL ANNOUNCEMENT', alertText]);
            for (const r of this.rooms.values()) {
              this.broadcastToRoom(r, globalMsg);
            }
            return;
          }

          if (cmd === 'givexp') {
            const isStaff = player.isAdmin || player.isMod;
            if (!isStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only server administrators can give XP.']));
              return;
            }
            if (args.length < 2) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /givexp <username> <amount>']));
              return;
            }
            const targetUser = this.userManager.getUser(args[0]);
            const amount = parseInt(args[1]);
            if (!targetUser || isNaN(amount)) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Invalid user or amount.']));
              return;
            }
            this.achievementManager.addXP(targetUser, amount, (msg) => {
              this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', msg]));
            });
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `${player.username} gave ${amount} XP to ${targetUser.username}!`]));
            return;
          }

          if (cmd === 'stats' || cmd === 'level' || cmd === 'rank') {
            const targetName = args[0] || player.username;
            const targetUser = this.userManager.getUser(targetName);
            if (!targetUser) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `User '${targetName}' not found.`]));
              return;
            }
            const data = this.achievementManager.getUserAchievements(targetUser);
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `--- STATS: ${targetUser.username} ---`]));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `⭐ Level: ${data.levelInfo.level} | XP: ${data.levelInfo.xp} / ${data.levelInfo.nextLevelXP} (${data.levelInfo.percent}%)`]));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `💎 Gems: ${targetUser.gems || 0} | ⚡ Energy: ${targetUser.energy || 0}/${targetUser.maxEnergy || 200}`]));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `🧱 Blocks Placed: ${data.stats.blocksPlaced || 0} | 🦘 Jumps: ${data.stats.jumps || 0}`]));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `🏆 Achievements Unlocked: ${data.totalUnlocked} / ${data.totalAvailable}`]));
            return;
          }

          if (cmd === 'achievements' || cmd === 'badges') {
            const user = this.userManager.getUser(player.username);
            const data = this.achievementManager.getUserAchievements(user);
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `--- ACHIEVEMENTS (${data.totalUnlocked}/${data.totalAvailable}) ---`]));
            for (const ach of data.achievements) {
              const status = ach.unlocked ? '✅ [UNLOCKED]' : `⏳ [${ach.progress}% - ${ach.current}/${ach.target}]`;
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `${ach.icon} ${ach.title}: ${status} (+${ach.rewardXP} XP, +${ach.rewardGems} 💎)`]));
            }
            return;
          }

          if (cmd === 'pm' || cmd === 'tell' || cmd === 'whisper' || cmd === 'msg') {
            if (args.length < 2) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /pm <username> <message>']));
              return;
            }
            const targetName = args[0].toLowerCase();
            const pmText = args.slice(1).join(' ');
            let targetPlayer = null;

            // Search across all online rooms
            for (const r of this.rooms.values()) {
              for (const p of r.players.values()) {
                if (p.username.toLowerCase() === targetName) {
                  targetPlayer = p;
                  break;
                }
              }
              if (targetPlayer) break;
            }

            if (!targetPlayer) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${args[0]}' is not online.`]));
              return;
            }

            targetPlayer.lastDmFrom = player.username;
            player.lastDmTo = targetPlayer.username;

            targetPlayer.send(new PlayerIOMessage('write', [`💬 [PM from ${player.username}]`, pmText]));
            player.send(new PlayerIOMessage('write', [`💬 [PM to ${targetPlayer.username}]`, pmText]));

            const uSender = this.userManager.getUser(player.username);
            if (uSender) {
              this.achievementManager.trackStat(uSender, 'dmsSent', 1, (msg) => {
                this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', msg]));
              });
            }
            return;
          }

          if (cmd === 'r' || cmd === 'reply') {
            if (!player.lastDmFrom) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Nobody has sent you a PM yet.']));
              return;
            }
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Usage: /r <message> (replies to ${player.lastDmFrom})`]));
              return;
            }
            const pmText = args.join(' ');
            let targetPlayer = null;
            for (const r of this.rooms.values()) {
              for (const p of r.players.values()) {
                if (p.username.toLowerCase() === player.lastDmFrom.toLowerCase()) {
                  targetPlayer = p;
                  break;
                }
              }
              if (targetPlayer) break;
            }

            if (!targetPlayer) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${player.lastDmFrom}' is no longer online.`]));
              return;
            }

            targetPlayer.lastDmFrom = player.username;
            targetPlayer.send(new PlayerIOMessage('write', [`💬 [PM from ${player.username}]`, pmText]));
            player.send(new PlayerIOMessage('write', [`💬 [PM to ${targetPlayer.username}]`, pmText]));
            return;
          }

          if (cmd === 'warp' || cmd === 'goto') {
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /warp <worldId>']));
              return;
            }
            const targetWorldId = args[0];
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `Warping to world '${targetWorldId}'...`]));
            player.send(new PlayerIOMessage('tele', [player.id, 16 * 16, 16 * 16]));
            const uWarp = this.userManager.getUser(player.username);
            if (uWarp) {
              this.achievementManager.trackStat(uWarp, 'portalsUsed', 1, (msg) => {
                this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', msg]));
              });
              this.questManager.trackDailyStat(uWarp, 'dailyPortals', 1, (msg) => {
                this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', msg]));
              });
            }
            return;
          }

          if (cmd === 'freeze') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to freeze players.']));
              return;
            }
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /freeze <username>']));
              return;
            }
            const targetName = args[0].toLowerCase();
            let target = null;
            for (const p of room.players.values()) {
              if (p.username.toLowerCase() === targetName) { target = p; break; }
            }
            if (!target) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${args[0]}' not found.`]));
              return;
            }
            target.isFrozen = true;
            target.speedX = 0;
            target.speedY = 0;
            this.broadcastToRoom(room, new PlayerIOMessage('freeze', [target.id, true]));
            this.broadcastToRoom(room, new PlayerIOMessage('tele', [target.id, target.x, target.y]));
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `❄️ ${target.username} was FROZEN by ${player.username}.`]));
            return;
          }

          if (cmd === 'unfreeze') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You do not have permission to unfreeze players.']));
              return;
            }
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /unfreeze <username>']));
              return;
            }
            const targetName = args[0].toLowerCase();
            let target = null;
            for (const p of room.players.values()) {
              if (p.username.toLowerCase() === targetName) { target = p; break; }
            }
            if (!target) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Player '${args[0]}' not found.`]));
              return;
            }
            target.isFrozen = false;
            this.broadcastToRoom(room, new PlayerIOMessage('freeze', [target.id, false]));
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `🔥 ${target.username} was UNFROZEN by ${player.username}.`]));
            return;
          }

          if (cmd === 'lock') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only the room owner or staff can lock the world.']));
              return;
            }
            room.world.isLocked = true;
            for (const p of room.players.values()) {
              if (!p.isOwner && !p.isAdmin) {
                p.canEdit = false;
                p.isGod = false;
                p.send(new PlayerIOMessage('lostaccess'));
                this.broadcastToRoom(room, new PlayerIOMessage('editRights', [p.id, false]));
                this.broadcastToRoom(room, new PlayerIOMessage('god', [p.id, false]));
              }
            }
            this.broadcastToRoom(room, new PlayerIOMessage('roomLocked', [true]));
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `🔒 World was LOCKED by ${player.username}. Only owners/staff can edit.`]));
            return;
          }

          if (cmd === 'unlock') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only the room owner or staff can unlock the world.']));
              return;
            }
            room.world.isLocked = false;
            this.broadcastToRoom(room, new PlayerIOMessage('roomLocked', [false]));
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `🔓 World was UNLOCKED by ${player.username}.`]));
            return;
          }

          if (cmd === 'country' || cmd === 'flag') {
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Your country is currently set to: ${player.country || 'HU'}. Use /country <HU/US/GB/DE/FR/IT/RO/PL/UA/ES/NL/SE/NO/FI/JP/CA/BR> to change it.`]));
              return;
            }
            const newCountry = args[0].toUpperCase().substring(0, 2);
            player.country = newCountry;
            const u = this.userManager.getUser(player.username);
            if (u) {
              u.country = newCountry;
              this.userManager.saveUser(u.username);
            }
            this.broadcastToRoom(room, new PlayerIOMessage('userCountry', [player.id, newCountry]));
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `🚩 ${player.username} changed their country to ${newCountry}.`]));
            return;
          }

          if (cmd === 'respawn' || cmd === 'spawn' || cmd === 'home' || cmd === 'kill') {
            const sp = room.world.findSpawnPoint();
            player.x = sp.x * 16;
            player.y = sp.y * 16;
            player.speedX = 0;
            player.speedY = 0;
            player.send(new PlayerIOMessage('tele', [player.id, player.x, player.y]));
            return;
          }

          if (cmd === 'name' || cmd === 'title' || cmd === 'rename' || cmd === 'setname') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only the world owner or staff can change the world title.']));
              return;
            }
            if (args.length === 0) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `Current world title: "${room.world.title}". Usage: /title <new title>`]));
              return;
            }
            const newTitle = args.join(' ').trim().substring(0, 50);
            room.world.title = newTitle;
            room.world.saveToFile(this.worldsDir);

            const updateMetaMsg = new PlayerIOMessage('updatemeta', [
              room.world.owner || 'Admin',
              room.world.title,
              room.world.plays || 0,
              room.world.favorites || 0,
              room.world.likes || 0
            ]);
            this.broadcastToRoom(room, updateMetaMsg);
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `📝 World title changed to: "${newTitle}" by ${player.username}.`]));
            console.log(`[World Name] Room ${room.id} renamed to "${newTitle}" by ${player.username}`);
            return;
          }

          if (cmd === 'allowguests') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Permission denied.']));
              return;
            }
            const state = args[0] ? args[0].toLowerCase() === 'on' || args[0].toLowerCase() === 'true' : !room.world.allowGuests;
            room.world.allowGuests = state;
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `Guest building permissions set to: ${state ? 'ENABLED' : 'DISABLED'}`]));
            return;
          }

          if (cmd === 'backup') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only room owner or staff can create world backups.']));
              return;
            }
            const backupName = args.join('_') || 'chat_backup';
            const res = room.world.createBackup(this.worldsDir, backupName);
            if (res.success) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `💾 World backup created: ${res.filename}`]));
            } else {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `❌ Failed to create backup: ${res.error}`]));
            }
            return;
          }

          if (cmd === 'restore') {
            const isOwnerOrStaff = player.isOwner || player.isAdmin || player.isMod || (room.world.owner && room.world.owner.toLowerCase() === player.username.toLowerCase());
            if (!isOwnerOrStaff) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Only room owner or staff can restore backups.']));
              return;
            }
            if (args.length === 0) {
              const backups = World.listBackups(this.worldsDir, room.id);
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `--- AVAILABLE BACKUPS (${backups.length}) ---`]));
              for (const b of backups.slice(0, 5)) {
                player.send(new PlayerIOMessage('write', ['* SYSTEM', `📁 ${b.filename} (${new Date(b.created).toLocaleTimeString()})`]));
              }
              player.send(new PlayerIOMessage('write', ['* SYSTEM', 'Usage: /restore <filename>']));
              return;
            }
            const filename = args[0];
            const res = room.world.restoreFromBackup(this.worldsDir, filename);
            if (res.success) {
              const clearMsg = new PlayerIOMessage('clear');
              this.broadcastToRoom(room, clearMsg);
              for (let y = 0; y < room.world.height; y++) {
                for (let x = 0; x < room.world.width; x++) {
                  const fg = room.world.getBlock(0, x, y);
                  if (fg > 0) this.broadcastToRoom(room, new PlayerIOMessage('b', [0, x, y, fg, 0]));
                  const bg = room.world.getBlock(1, x, y);
                  if (bg > 0) this.broadcastToRoom(room, new PlayerIOMessage('b', [1, x, y, bg, 0]));
                }
              }
              this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', `🔄 World was RESTORED from ${filename} by ${player.username}!`]));
            } else {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `❌ Restore failed: ${res.error}`]));
            }
            return;
          }

          if (cmd === 'daily' || cmd === 'streak') {
            const user = this.userManager.getUser(player.username);
            if (!user) return;
            const streakData = this.questManager.processDailyLogin(user);
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `--- 🎁 DAILY LOGIN BONUS ---`]));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `🔥 Consecutive Days Streak: ${streakData.streak} days`]));
            if (streakData.streakAwarded) {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `🎉 Claimed Today: +${streakData.rewardGems} 💎 Gems, +${streakData.rewardEnergy} ⚡ Energy, +${streakData.rewardXP} ⭐ XP!`]));
            } else {
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `✅ You already claimed your daily bonus for today! Come back tomorrow for Day ${streakData.streak + 1}.`]));
            }
            return;
          }

          if (cmd === 'quests' || cmd === 'missions') {
            const user = this.userManager.getUser(player.username);
            if (!user) return;
            const qData = this.questManager.getUserQuests(user);
            player.send(new PlayerIOMessage('write', ['* SYSTEM', `--- 📜 DAILY QUESTS (Streak: ${qData.streak} 🔥) ---`]));
            for (const q of qData.quests) {
              const status = q.completed ? '✅ [TELJESÍTVE]' : `⏳ [${q.progress}%] (${q.current}/${q.target})`;
              player.send(new PlayerIOMessage('write', ['* SYSTEM', `${q.icon} ${q.title}: ${q.desc} -> ${status} (+${q.rewardGems} 💎, +${q.rewardXP} XP)`]));
            }
            return;
          }

          if (cmd === 'help') {
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '=== EVERYBODY EDITS v264 COMMANDS ===']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '--- 🧱 WORLDEDIT & BUILDER ---']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '/fill, /bgfill, /replace, /undo, /clear, /setspawn, /worldtitle, /worlddesc, /export']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '--- 💾 BACKUP & SNAPSHOTS ---']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '/backup [name], /restore [filename]']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '--- 💬 MESSAGING & SOCIAL ---']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '/pm <user> <msg>, /r <msg>, /warp <worldId>']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '--- ⭐ STATS, QUESTS & REWARDS ---']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '/daily, /quests, /stats [user], /level [user], /achievements']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '--- 🛡️ MODERATION & SECURITY ---']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '/freeze <user>, /unfreeze <user>, /lock, /unlock, /allowguests <on|off>']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '/kick <user>, /ban <user>, /unban <user>, /mute <user>, /unmute <user>']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '/givegems <user> <amt>, /giveenergy <user> <amt>, /givexp <user> <amt>, /giveitem <user> <item>']));
            player.send(new PlayerIOMessage('write', ['* SYSTEM', '/tp <player>, /tphere <player>, /broadcast <msg>, /god, /giveedit <user>']));
            return;
          }
        }

        if (player.isMuted) {
          player.send(new PlayerIOMessage('write', ['* SYSTEM', 'You are currently muted and cannot send chat messages.']));
          return;
        }

        if (player.username.toLowerCase().startsWith('guest')) {
          console.log(`[Chat Blocked] Guest ${player.username} attempted to chat.`);
          return;
        }
        console.log(`[Chat] ${player.username}: ${text}`);

        // Track chat stat
        const uChat = this.userManager.getUser(player.username);
        if (uChat) {
          this.achievementManager.trackStat(uChat, 'chatMessages', 1, (msg) => {
            this.broadcastToRoom(room, new PlayerIOMessage('write', ['* SYSTEM', msg]));
          });
        }

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

      case 'getCrew': {
        if (!player) return;
        const crewNameOrId = msg.getString(0);
        const crew = this.crewManager.getCrew(crewNameOrId);
        const resp = new PlayerIOMessage('getCrew');
        if (!crew) {
          resp.add(true); // isError = true
          player.send(resp);
          break;
        }

        resp.add(false); // isError = false
        resp.add(crew.id);
        resp.add(crew.name);
        resp.add(crew.subscribers || 0);
        resp.add(crew.logoWorldId || 'PW_default');

        const member = crew.members ? crew.members.find(m => m.username.toLowerCase() === player.username.toLowerCase()) : null;
        const memberRankId = member ? (member.rank !== undefined ? member.rank : 2) : -1;
        resp.add(memberRankId);

        if (memberRankId >= 0) {
          resp.add(memberRankId === 0); // canChangeColors
          resp.add(memberRankId === 0); // canEditRanks
        }

        resp.add(crew.crewTextColor || 0xFFFFFF);
        resp.add(crew.crewBackgroundColor || 0x1E293B);
        resp.add(crew.crewBackground2ndColor || 0x0F172A);
        resp.add(crew.faceplate || 'Castle');
        resp.add(crew.faceplateColor || 0);

        // Faceplates list (0 extra)
        resp.add(0);

        // Ranks
        const ranks = crew.ranks || [{ id: 0, name: 'Leader' }, { id: 1, name: 'Officer' }, { id: 2, name: 'Member' }];
        resp.add(ranks.length);
        for (const r of ranks) {
          resp.add(r.id);
          resp.add(r.name);
        }

        // Rooms
        const rooms = crew.rooms || ['PW_default'];
        resp.add(rooms.length);
        for (const rm of rooms) {
          resp.add(rm);
        }

        // Members
        for (const m of (crew.members || [])) {
          resp.add(m.username);
          resp.add(m.role || 'Member');
          resp.add(m.rank !== undefined ? m.rank : 2);
          resp.add(m.face !== undefined ? m.face : 0);
          resp.add(Boolean(m.isOnline));
        }

        player.send(resp);
        break;
      }

      case 'isSubscribedToCrew': {
        if (!player) return;
        const resp = new PlayerIOMessage('isSubscribedToCrew');
        resp.add(false);
        player.send(resp);
        break;
      }

      case 'l': {
        if (!player || !room) return;
        // Like world packet
        room.world.likes = (room.world.likes || 0) + 1;
        room.world.saveToFile(this.worldsDir);
        const userData = this.userManager.getUser(player.username);
        if (userData && !userData.likedWorlds.includes(room.id)) {
          userData.likedWorlds.push(room.id);
          this.userManager.saveUser(player.username);
        }
        player.send(new PlayerIOMessage('write', ['* SYSTEM', `You liked ${room.world.title}!`]));
        break;
      }

      case 'f': {
        if (!player || !room) return;
        // Favorite world packet
        room.world.favorites = (room.world.favorites || 0) + 1;
        room.world.saveToFile(this.worldsDir);
        const userData = this.userManager.getUser(player.username);
        if (userData && !userData.favorites.includes(room.id)) {
          userData.favorites.push(room.id);
          this.userManager.saveUser(player.username);
        }
        player.send(new PlayerIOMessage('write', ['* SYSTEM', `Added ${room.world.title} to your favorites!`]));
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
