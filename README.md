# EverybodyEdits — Private Server & Offline Flash Client

This repository contains a private EverybodyEdits server and an offline Flash client. The documentation below explains project structure, prerequisites, build/run instructions, data formats, server API, and important implementation details.

---

## Table of contents
- Project overview
- Directory structure
- Prerequisites
- Running the server
- Build process (AS3 → SWF)
- Data formats
- API endpoints
- Core game flows (energy, gems, shop, payvault, smiley/aura)
- TCP (PlayerIO) protocol overview
- Troubleshooting & common issues
- Edited files summary
- Contributing

---

## Project overview
This project provides:
- A Node.js backend compatible with a PlayerIO-like TCP protocol for EverybodyEdits.
- An ActionScript 3 client (decompiled and modified) producing a local SWF (`game_local.swf`).
- A shop/gem/energy/payvault system and world saving.

Intended use: run locally for development, testing, or private servers.

---

## Directory structure (example)
Root: c:/Games/EE/
- README.md — this file
- build.ps1 — PowerShell build script (AS3 → SWF)
- game.swf — original reference SWF
- game_local.swf — rebuilt/modded client SWF
- index.html — SWF wrapper
- package.json — Node project config
- ffdec/ffdec.jar — JPEXS Free Flash Decompiler tooling
- server/
  - index.js — server entry point
  - config.json — server settings (ports, host)
  - src/
    - Server.js — main server logic (HTTP API + TCP server)
    - Player.js, World.js, UserManager.js, PlayerIOProtocol.js, ...
  - users/ — per-user JSON files
  - shop/ — shop generator and items.json
  - crews/ — crew JSON files
  - worlds/ — saved world JSON files
- src_decompiled/ — decompiled AS3 sources used to rebuild the SWF
  - scripts/EverybodyEdits.as, Global.as, Shop.as, Player.as, World.as, etc.

---

## Prerequisites
- Node.js v16+ (LTS) — run the server
- Java 8+ JRE/JDK — to run ffdec.jar if used for compilation
- Flash Player (standalone) — to run `game_local.swf` locally (e.g., `flashplayer_32_sa.exe`)
- PowerShell (Windows) — optional for the provided build script

---

## Run the server
From repository root:
```powershell
cd c:\Games\EE
node server/index.js
