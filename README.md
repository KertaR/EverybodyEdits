# Everybody Edits v264 — Private Server & Offline Flash Client

This repository contains a full private server and offline Flash client for **Everybody Edits v264**.

---

## 🚀 What's New in v264

### 1. 🔄 Official v264 Protocol & Client Sync
- Protocol and room types updated to `Everybodyedits264`, `Beta264`, `Lobby264`, `CrewLobby264`.
- Updated `Config.as` and `EverybodyEdits.as` for seamless v264 communication.

### 2. 💬 Enhanced Social & Messaging
- **Private Messaging**: `/pm <user> <message>` or `/whisper` / `/tell`
- **Quick Reply**: `/r <message>` (reply to last sender)
- **World Warping**: `/warp <worldId>` or `/goto <worldId>`

### 3. 🛡️ World Protection & Moderation Suite
- **Locking & Access**: `/lock`, `/unlock`, `/allowguests <on|off>`
- **Player Controls**: `/freeze <user>`, `/unfreeze <user>`, `/kick`, `/ban`, `/mute`, `/giveedit`, `/givegod`, `/tp`, `/tphere`
- **Economy Granting**: `/givegems <user> <amt>`, `/giveenergy <user> <amt>`, `/givexp <user> <amt>`, `/giveitem <user> <itemId>`

### 4. 💾 World Backups & Instant Snapshots
- `/backup [label]` — saves instant rollback snapshot to `server/worlds/backups/`.
- `/restore <filename>` — restores world state and live-synchronizes active players.

### 5. 🎁 Daily Rewards, Quests & Leveling
- **Daily Login Streak**: `/daily` (claim progressive gem, energy, and XP rewards each day).
- **Daily Missions**: `/quests` (active rotating objectives with gem & XP payouts).
- **Achievements & Stats**: `/stats [user]`, `/level [user]`, `/achievements`.

### 6. 🎨 Pro Admin Dashboard (v264)
- Accessible at `http://localhost:8080/admin.html`.
- **Live World Map & Painter**: Real-time canvas rendering with click-to-draw block painter.
- **Crews & Guilds Manager**: GUI to create, edit, customize colors, and assign crew ranks.
- **Backup & Restore Manager**: One-click world snapshot creation and restoration.
- **Economy & Inventory Editor**: Visual PayVault catalog with filter chips.

---

## 📁 Directory Structure
- `build.ps1` — PowerShell build script (AS3 → SWF with FFDec)
- `game.swf` — Original reference SWF
- `game_local.swf` — Rebuilt v264 client SWF
- `flashplayer_32_sa.exe` — Standalone Flash Player projector
- `admin.html` — v264 Pro Admin Suite
- `server/`
  - `index.js` — Server entry point (starts TCP 8184 + HTTP 8080 + Policy 843)
  - `src/`
    - `Server.js` — Core game room & packet handler
    - `World.js` — World state, serializing, block storage & backups
    - `Player.js` — Player session model
    - `UserManager.js` — User authentication and storage
    - `CrewManager.js` — Crew and clan management
    - `AchievementManager.js` — Badges, XP leveling & stats
    - `QuestManager.js` — Daily streak & quests system
  - `worlds/` — Saved world JSON files and `backups/`
  - `crews/` — Crew JSON data
  - `users/` — Persistent user profiles

---

## 🛠️ Getting Started

### Prerequisites
- Node.js v16+ (LTS)
- Java 8+ JRE/JDK (for FFDec SWF compiler)
- Flash Player standalone (provided in root: `flashplayer_32_sa.exe`)

### 1. Run the Server
```powershell
node server/index.js
```

### 2. Launch the Game
Double-click `Launch-Game.bat` or run:
```powershell
.\flashplayer_32_sa.exe game_local.swf
```

### 3. Open Admin Control Panel
Open your browser and navigate to:
```
http://localhost:8080/admin.html
```

---

## ⌨️ In-Game Chat Commands

| Command | Description |
|---|---|
| `/pm <user> <msg>` | Send private message to player |
| `/r <msg>` | Quick reply to last private message |
| `/warp <worldId>` | Warp to specified world |
| `/backup [name]` | Create snapshot backup of the current world |
| `/restore <file>` | Restore world from a snapshot file |
| `/daily` | Claim daily login streak bonus |
| `/quests` | View daily active missions and rewards |
| `/fill <x1> <y1> <x2> <y2> <id>` | Fill rectangular area with block |
| `/bgfill <x1> <y1> <x2> <y2> <id>` | Fill rectangular area with background |
| `/replace <fromId> <toId>` | Replace blocks across the world |
| `/undo` | Undo the last WorldEdit / build action |
| `/clear` | Clear all blocks in world (revertible with /undo) |
| `/setspawn [x] [y]` | Set world spawn point |
| `/worldtitle <title>` | Change world title |
| `/worlddesc <desc>` | Change world description |
| `/lock` / `/unlock` | Lock or unlock building permissions in room |
| `/allowguests <on\|off>` | Toggle guest building permissions |
| `/freeze <user>` / `/unfreeze` | Freeze or unfreeze a player's movement |
| `/kick <user> [reason]` | Kick player from room |
| `/ban <user> [reason]` | Ban player account |
| `/mute <user>` / `/unmute` | Mute or unmute player from chat |
| `/givegems <user> <amt>` | Grant gems to player |
| `/giveenergy <user> <amt>` | Grant energy to player |
| `/givexp <user> <amt>` | Grant XP to player |
| `/giveitem <user> <item>` | Grant shop / PayVault item to player |
| `/giveedit <user>` / `/removeedit` | Grant or revoke room edit rights |
| `/god` | Toggle God Mode |
| `/tp <user>` / `/tphere <user>` | Teleport to or summon player |
| `/stats [user]` | Display level, XP, gems, and stats |
| `/achievements` | Display list of unlocked achievements |
| `/help` | Display list of all available commands |
