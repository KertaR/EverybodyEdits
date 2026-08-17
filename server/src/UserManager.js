const fs = require('fs');
const path = require('path');

class UserManager {
  constructor(dataDir) {
    this.usersDir = path.join(dataDir, 'users');
    if (!fs.existsSync(this.usersDir)) {
      fs.mkdirSync(this.usersDir, { recursive: true });
    }
    this.users = new Map();
    this.loadAll();
  }

  loadAll() {
    try {
      const files = fs.readdirSync(this.usersDir);
      for (const file of files) {
        if (file.endsWith('.json')) {
          if (file.toLowerCase().startsWith('guest')) {
            try {
              fs.unlinkSync(path.join(this.usersDir, file));
              console.log(`[UserManager] Removed guest file: ${file}`);
            } catch (e) {}
            continue;
          }
          const filePath = path.join(this.usersDir, file);
          const data = fs.readFileSync(filePath, 'utf8');
          const user = JSON.parse(data);
          if (user && user.username) {
            let modified = false;
            if (user.gems === undefined) { user.gems = 500; modified = true; }
            if (user.energy === undefined) { user.energy = 100; modified = true; }
            if (user.maxEnergy === undefined) { user.maxEnergy = 200; modified = true; }
            if (!user.itemEnergyProgress) { user.itemEnergyProgress = {}; modified = true; }
            if (!Array.isArray(user.friends)) { user.friends = []; modified = true; }
            if (!Array.isArray(user.favorites)) { user.favorites = []; modified = true; }
            if (!Array.isArray(user.likedWorlds)) { user.likedWorlds = []; modified = true; }
            if (user.crew === undefined) { user.crew = ''; modified = true; }
            this.users.set(user.username.toLowerCase(), user);
            if (modified) {
              fs.writeFileSync(filePath, JSON.stringify(user, null, 2), 'utf8');
            }
          }
        }
      }
      console.log(`[UserManager] Loaded ${this.users.size} user file(s) from ${this.usersDir}`);
    } catch (err) {
      console.error(`[UserManager Error] Failed to load users: ${err.message}`);
    }
  }

  saveUser(username, immediate = false) {
    try {
      const user = this.getUser(username);
      if (!user) return false;
      const key = username.trim().toLowerCase();
      if (key.startsWith('guest') || key.includes('-')) return false;

      if (!this.saveTimers) this.saveTimers = new Map();

      const doWrite = () => {
        const filePath = path.join(this.usersDir, `${key}.json`);
        fs.writeFile(filePath, JSON.stringify(user, null, 2), 'utf8', (err) => {
          if (err) console.error(`[UserManager Error] Failed to save user ${username}: ${err.message}`);
        });
      };

      if (immediate) {
        if (this.saveTimers.has(key)) {
          clearTimeout(this.saveTimers.get(key));
          this.saveTimers.delete(key);
        }
        const filePath = path.join(this.usersDir, `${key}.json`);
        fs.writeFileSync(filePath, JSON.stringify(user, null, 2), 'utf8');
        return true;
      }

      if (this.saveTimers.has(key)) {
        clearTimeout(this.saveTimers.get(key));
      }

      this.saveTimers.set(key, setTimeout(() => {
        this.saveTimers.delete(key);
        doWrite();
      }, 500));

      return true;
    } catch (err) {
      console.error(`[UserManager Error] Failed to save user ${username}: ${err.message}`);
      return false;
    }
  }

  getUser(username) {
    if (!username) return null;
    let clean = String(username).trim().toLowerCase();
    if (clean.startsWith('simple') && clean !== 'simpleguest') {
      clean = clean.substring(6);
    }
    return this.users.get(clean) || null;
  }

  register(username, password = 'user123', email = '') {
    if (!username) return null;
    const key = username.trim().toLowerCase();
    let user = this.users.get(key);
    const isGuest = key.startsWith('guest') || key.includes('-');
    if (!user) {
      user = {
        username: username.trim(),
        password: password || 'user123',
        email: email || '',
        role: 'user',
        isAdmin: false,
        isStaff: false,
        isMod: false,
        goldmember: false,
        haveSmileyPackage: false,
        player_is_beta_member: false,
        face: 0,
        aura: 0,
        auraColor: 0,
        badge: '',
        gems: 500,
        energy: 100,
        maxEnergy: 200,
        payVault: [],
        smileyGoldBorder: false,
        friends: [],
        favorites: [],
        likedWorlds: [],
        crew: '',
        registeredAt: new Date().toISOString(),
        lastLogin: new Date().toISOString()
      };
      if (!isGuest) {
        this.users.set(key, user);
        this.saveUser(user.username);
        console.log(`[UserManager] Registered and saved user file: users/${key}.json`);
      } else {
        console.log(`[UserManager] Temporary guest session created for ${user.username} (not saved to disk)`);
      }
    } else if (!isGuest) {
      user.lastLogin = new Date().toISOString();
      if (password) user.password = password;
      if (email) user.email = email;
      this.saveUser(user.username);
    }
    return user;
  }

  updateUser(username, updateData) {
    const user = this.getUser(username);
    if (user) {
      Object.assign(user, updateData);
      this.saveUser(user.username);
    }
    return user;
  }

  deleteUser(username) {
    if (!username) return false;
    const key = username.trim().toLowerCase();
    this.users.delete(key);
    const filePath = path.join(this.usersDir, `${key}.json`);
    if (fs.existsSync(filePath)) {
      try {
        fs.unlinkSync(filePath);
        return true;
      } catch (e) {}
    }
    return true;
  }
}

module.exports = UserManager;
