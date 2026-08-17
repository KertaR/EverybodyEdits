/**
 * Everybody Edits Crew & Clan Management System
 */

const fs = require('fs');
const path = require('path');

class CrewManager {
  constructor(baseDir) {
    this.crewsDir = path.join(baseDir, 'crews');
    if (!fs.existsSync(this.crewsDir)) {
      fs.mkdirSync(this.crewsDir, { recursive: true });
    }
    this.crews = new Map();
    this.initDefaultCrews();
    this.loadAllCrews();
  }

  initDefaultCrews() {
    // 1. Staff Crew
    const staffCrew = {
      id: 'everybodyeditsstaff',
      name: 'Everybody Edits Staff',
      owner: 'Admin',
      subscribers: 1337,
      logoWorldId: 'crewstaff',
      crewTextColor: 0xFFD700,
      crewBackgroundColor: 0x1A2238,
      crewBackground2ndColor: 0x111625,
      faceplate: 'Gold',
      faceplateColor: 0,
      ranks: [
        { id: 0, name: 'Admin' },
        { id: 1, name: 'Moderator' },
        { id: 2, name: 'Staff Member' }
      ],
      rooms: ['crewstaff'],
      members: [
        { username: 'Admin', rank: 0, role: 'Server Owner', face: 0, isOnline: true },
        { username: 'KertaR', rank: 0, role: 'Lead Developer', face: 16, isOnline: true }
      ]
    };

    // 2. Legends Crew
    const legendsCrew = {
      id: 'eelegends',
      name: 'EE Legends',
      owner: 'KertaR',
      subscribers: 420,
      logoWorldId: 'PW_default',
      crewTextColor: 0x00FFCC,
      crewBackgroundColor: 0x0F172A,
      crewBackground2ndColor: 0x080D1A,
      faceplate: 'Electric',
      faceplateColor: 0,
      ranks: [
        { id: 0, name: 'Leader' },
        { id: 1, name: 'Officer' },
        { id: 2, name: 'Member' }
      ],
      rooms: ['PW_default'],
      members: [
        { username: 'KertaR', rank: 0, role: 'Leader', face: 16, isOnline: true },
        { username: 'Player', rank: 2, role: 'Builder', face: 0, isOnline: false }
      ]
    };

    const staffFile = path.join(this.crewsDir, 'everybodyeditsstaff.json');
    if (!fs.existsSync(staffFile)) {
      fs.writeFileSync(staffFile, JSON.stringify(staffCrew, null, 2), 'utf8');
    }

    const legendsFile = path.join(this.crewsDir, 'eelegends.json');
    if (!fs.existsSync(legendsFile)) {
      fs.writeFileSync(legendsFile, JSON.stringify(legendsCrew, null, 2), 'utf8');
    }
  }

  loadAllCrews() {
    this.crews.clear();
    const files = fs.readdirSync(this.crewsDir).filter(f => f.endsWith('.json'));
    for (const file of files) {
      try {
        const filePath = path.join(this.crewsDir, file);
        const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        if (data.id) {
          if (!data.worlds) data.worlds = data.rooms || ['PW_default'];
          if (!data.rooms) data.rooms = data.worlds || ['PW_default'];
          this.crews.set(data.id.toLowerCase(), data);
          if (data.name) {
            this.crews.set(data.name.toLowerCase(), data);
          }
          if (data.id.toLowerCase() === 'everybodyeditsstaff') {
            this.crews.set('staff', data);
          }
        }
      } catch (err) {
        console.error(`[CrewManager] Failed to load crew ${file}:`, err);
      }
    }
    console.log(`[CrewManager] Loaded ${files.length} crew(s) from ${this.crewsDir}`);
  }

  getCrew(nameOrId) {
    if (!nameOrId) return null;
    let clean = String(nameOrId).toLowerCase().trim();
    if (clean.startsWith('crew')) clean = clean.substring(4);
    if (clean === 'staff') clean = 'everybodyeditsstaff';
    return this.crews.get(clean) || this.crews.get(nameOrId.toLowerCase()) || null;
  }

  getAllCrewsList() {
    const list = [];
    const seen = new Set();
    for (const crew of this.crews.values()) {
      if (!seen.has(crew.id)) {
        seen.add(crew.id);
        list.push(crew);
      }
    }
    return list;
  }

  createCrew(id, name, owner) {
    const cleanId = id.toLowerCase().replace(/[^a-z0-9_-]/g, '');
    if (this.crews.has(cleanId) || this.crews.has(name.toLowerCase())) {
      return { success: false, error: 'Crew ID or Name is already taken' };
    }

    const newCrew = {
      id: cleanId,
      name: name,
      owner: owner,
      subscribers: 1,
      logoWorldId: 'PW_default',
      crewTextColor: 0xFFFFFF,
      crewBackgroundColor: 0x1E293B,
      crewBackground2ndColor: 0x0F172A,
      faceplate: 'Castle',
      faceplateColor: 0,
      ranks: [
        { id: 0, name: 'Leader' },
        { id: 1, name: 'Officer' },
        { id: 2, name: 'Member' }
      ],
      rooms: ['PW_default'],
      members: [
        { username: owner, rank: 0, role: 'Founder', face: 0, isOnline: true }
      ]
    };

    this.saveCrew(newCrew);
    this.crews.set(cleanId, newCrew);
    this.crews.set(name.toLowerCase(), newCrew);
    return { success: true, crew: newCrew };
  }

  saveCrew(crew) {
    if (!crew || !crew.id) return;
    const filePath = path.join(this.crewsDir, `${crew.id.toLowerCase()}.json`);
    fs.writeFileSync(filePath, JSON.stringify(crew, null, 2), 'utf8');
  }
}

module.exports = CrewManager;
