# Everybody Edits Private Server & Offline Flash Client

Ez a dokumentáció tartalmazza az **Everybody Edits Private Server** fejlesztési, buildelési, konfigurációs és futtatási útmutatóját, valamint az összes rendszer részletes leírását.

---

## 📐 Projekt Szerkezet (Directory Structure)

```
c:/Games/EE/
├── README.md                      # Ez a dokumentáció
├── build.ps1                      # PowerShell build script (AS3 → SWF)
├── game.swf                       # Eredeti referencia SWF fájl
├── game_local.swf                 # Fordított, egyedi Flash kliens SWF
├── index.html                     # Flash Player HTML wrapper
├── package.json                   # Node.js projekt konfiguráció
├── ffdec/                         # JPEXS Free Flash Decompiler
│   └── ffdec.jar                  # Fordító JAR (AS3 → SWF kompilálás)
├── server/                        # Node.js backend szerver
│   ├── index.js                   # Szerver belépési pont
│   ├── config.json                # Szerver beállítások (portok, host)
│   ├── src/                       # Szerver modulok
│   │   ├── Server.js              # Fő szerver logika (HTTP API + TCP szerver)
│   │   ├── Player.js              # Játékos objektum szerver oldalon
│   │   ├── World.js               # Világ/pálya kezelés és mentés
│   │   ├── UserManager.js         # Felhasználók betöltése, mentése, regisztrálása
│   │   └── PlayerIOProtocol.js    # PlayerIO TCP protokoll implementáció
│   ├── users/                     # Felhasználók JSON adatai
│   │   ├── kertar.json            # Admin felhasználó
│   │   └── player.json            # Teszt felhasználó
│   ├── shop/                      # Bolt adatok
│   │   ├── generate_items.js      # Katalógus generáló script
│   │   └── items.json             # Generált bolti tárgyak katalógusa
│   ├── crews/                     # Crew adatok JSON fájlokban
│   └── worlds/                    # Mentett világok JSON fájljai
└── src_decompiled/                # Dekompilált ActionScript 3 (AS3) forráskód
    └── scripts/
        ├── EverybodyEdits.as      # Fő kliens vezérlő & hálózati kommunikáció
        ├── Global.as              # Globális állapotok, logolás, stage referencia
        ├── Shop.as                # Bolt vásárlási logika (useEnergy, useGems, refresh)
        ├── ShopEvent.as           # Bolt eseménykezelés (UPDATE, ITEM_AQUIRED)
        ├── Player.as              # Játékos mozgás és renderelés
        ├── World.as               # Világ renderelő és blokk kezelő
        ├── Config.as              # Kliens konfiguráció
        ├── data/
        │   ├── SimplePlayerObject.as  # Játékos adatmodell (gems, energy, face, stb.)
        │   ├── ShopItemData.as        # Bolt tárgy adatmodell
        │   └── SimpleProfileObject.as # Profil adatmodell
        ├── items/
        │   ├── ItemManager.as         # Blokk csomagok nyilvántartása
        │   └── ItemManager_aurasGalaxyBM.as # Aura és Galaxy tárgyak
        ├── playerio/
        │   └── PayVault.as            # Fizetési rendszer (refresh, has, items)
        ├── states/
        │   ├── LobbyState.as          # Főmenü állapot (shopbar, lapok)
        │   └── PlayState.as           # Játék állapot (pályán belül)
        └── ui/
            └── shop/
                ├── BaseShop.as        # Bolt alap UI (energia/gem gombok kezelése)
                ├── MainShop.as        # Fő bolt felület
                ├── ShopBar.as         # Felső sáv (gemek, energia, felhasználónév)
                ├── ShopGrid.as        # Bolt rács (tárgyak elrendezése)
                ├── ShopItem.as        # Egyedi bolt tárgy kártya
                ├── EnergyBar.as       # Energia csík UI komponens
                └── ButtonEnergy.as    # +10 / +All gomb
```

---

## 🛠️ Előfeltételek (Prerequisites)

| Szoftver | Verzió | Cél |
|----------|--------|-----|
| **Node.js** | v16+ LTS | Szerver futtatás |
| **Java JRE/JDK** | Java 8+ | `ffdec.jar` Flash fordító |
| **Flash Player Standalone** | `flashplayer_32_sa.exe` | `game_local.swf` futtatás |

---

## 🚀 Szerver Indítása

```powershell
cd c:\Games\EE
node server/index.js
```

### Szolgáltatások:
| Szolgáltatás | Port | Leírás |
|---|---|---|
| HTTP Web Szerver | `8080` | API végpontok + SWF kiszolgálás |
| Flash Policy Szerver | `843` | Flash crossdomain policy |
| Multiplayer TCP Szerver | `8184` | PlayerIO TCP kommunikáció |

---

## 🔨 Build Folyamat (AS3 → SWF)

```powershell
cd c:\Games\EE
powershell -ExecutionPolicy Bypass -File build.ps1
```

### Mi történik:
1. Leállítja a futó Flash Player példányokat
2. Másolja a `src_decompiled/scripts/` tartalmát egy ideiglenes mappába (`temp_src/`)
3. Meghívja az `ffdec.jar` -t a `game.swf` referencia SWF-en, beinjektálva az AS3 forrást
4. Kimenet: `game_local.swf`

> ⚠️ Build után **mindig indítsd újra a szervert** (`node server/index.js`), hogy az új SWF-et szolgálja ki!

---

## 🗄️ Adatszerkezetek

### 1. Felhasználó (`server/users/<username>.json`)

```json
{
  "username": "Player",
  "password": "user123",
  "email": "player@local.com",
  "role": "user",
  "isAdmin": false,
  "isStaff": false,
  "isMod": false,
  "goldmember": false,
  "haveSmileyPackage": false,
  "player_is_beta_member": false,
  "face": 95,
  "aura": 0,
  "auraColor": 0,
  "badge": "",
  "gems": 480,
  "energy": 160,
  "maxEnergy": 200,
  "payVault": ["smileyscarecrow", "smileykungfumaster"],
  "smileyGoldBorder": false,
  "registeredAt": "2026-08-05T18:53:00.000Z",
  "lastLogin": "2026-08-05T18:53:00.000Z",
  "itemEnergyProgress": {
    "smileycow": 120,
    "smileygraduate": 20
  }
}
```

| Mező | Típus | Leírás |
|------|-------|--------|
| `face` | `int` | Aktuális smiley ID (mentődik szerveren) |
| `energy` | `int` | Aktuális energia (0–maxEnergy) |
| `maxEnergy` | `int` | Maximális energia kapacitás |
| `gems` | `int` | Drágakő egyenleg |
| `payVault` | `string[]` | Megvásárolt tárgyak ID-listája |
| `itemEnergyProgress` | `Object` | Tárgy→felhalmozott energia mapping (részleges vásárlás) |
| `role` | `string` | Felhasználói rang: `"user"`, `"admin"`, `"mod"` |

### 2. Crew (`server/crews/<crew_id>.json`)

```json
{
  "id": "staff",
  "name": "Staff Team",
  "description": "Official EE Staff Crew",
  "subscribers": 1,
  "ranks": [
    { "name": "Staff Owner", "perms": "111111" },
    { "name": "Staff Member", "perms": "000000" }
  ],
  "members": [
    { "username": "KertaR", "smiley": "smileysuper", "rank": 0 }
  ]
}
```

### 3. Bolt Tárgy (`server/shop/items.json`)

```json
{
  "id": "smileycow",
  "payvaultid": "smileycow",
  "type": "smiley",
  "name": "Cow Smiley",
  "description": "Mooing bovine face",
  "priceEnergy": 500,
  "priceEnergyClick": 10,
  "priceGems": 10,
  "bitmapsheet_id": "smilies",
  "offset": 46,
  "isFeatured": false,
  "reusable": false
}
```

---

## 🌐 API Végpontok

### `GET /api/user/:username`
Felhasználó adatok lekérése.

**Válasz:** `{ success: true, user: { ... } }`

**Használat:** PayVault refresh, profil betöltés, bejelentkezés.

---

### `POST /api/buy`
Tárgy vásárlása energiával vagy gemekkel.

**Request Body:**
```json
{
  "username": "Player",
  "itemId": "smileycow",
  "costGems": 0,
  "isEnergy": true,
  "useAll": false
}
```

**Válasz:**
```json
{
  "success": true,
  "unlocked": false,
  "energyUsed": 130,
  "energySpent": 10,
  "user": { /* frissített felhasználó adatok */ }
}
```

**Logika:**
1. Ha `isEnergy == true`:
   - Levon `min(user.energy, clickEnergy, neededEnergy)` energiát
   - Növeli `itemEnergyProgress[itemId]` értéket
   - Ha `progress >= priceEnergy` → `unlocked = true`, tárgy hozzáadva a `payVault`-hoz
2. Ha `isEnergy == false` (gem vásárlás):
   - Levon `costGems` drágakövet
   - `unlocked = true`, tárgy azonnal a `payVault`-ba kerül

---

### `POST /api/user/update`
Felhasználó adatok módosítása (admin eszköz).

**Request Body:**
```json
{
  "username": "Player",
  "gems": 1000,
  "energy": 200
}
```

---

### `GET /api/shop`
Teljes bolt katalógus lekérése (`server/shop/items.json`).

---

### `GET /api/crews`
Összes crew adatainak lekérése (`server/crews/*.json`).

---

## ⚡ Energia Vásárlás Rendszer

### Láncolat (+10 kattintás):

```
┌───────────────────────────────────────────────────────────────────────┐
│  Kliens (ActionScript 3)                                             │
│                                                                       │
│  1. ShopItem: [+10 gomb] kattintás                                   │
│     ↓                                                                 │
│  2. BaseShop.handleUseEnergy()                                       │
│     → Shop.useEnergy(itemId, false, ...)                             │
│     ↓                                                                 │
│  3. EverybodyEdits.requestRemoteMethod("useEnergy", callback, itemId)│
│     → HTTP POST /api/buy { isEnergy:true, useAll:false }             │
│     ↓                                                                 │
│  4. Szerver válasz feldolgozás (EverybodyEdits.as #789-794):         │
│     • Global.playerObject.gems = res.user.gems                       │
│     • Global.playerObject.energy = res.user.energy                   │
│     • Global.playerObject.itemEnergyProgress = res.user.iEP          │
│     ↓                                                                 │
│  5. Shop.spendEnergy callback:                                       │
│     HA unlocked (progress >= cost):                                   │
│       → payVault.refresh() → Shop.refresh() → ShopEvent.ITEM_AQUIRED│
│     HA NEM unlocked:                                                  │
│       → dataidhash[target].energyUsed = progress (helyi frissítés)   │
│       → _energy = Global.playerObject.energy                         │
│       → dispatch ShopEvent.UPDATE (azonnali UI frissítés)            │
│     ↓                                                                 │
│  6. BaseShop.handleShopUpdate → refreshGridItems() → refreshTopBar() │
│     → Energia csík + felső sáv frissül                               │
└───────────────────────────────────────────────────────────────────────┘
```

### Fontos döntések:
- **Nincs HTTP roundtrip +10 kattintásnál** (nem-unlocked eset): A `/api/buy` válasz már tartalmazza a friss adatokat. A `ShopItemData.energyUsed` közvetlenül frissül a `dataidhash`-ből, és `ShopEvent.UPDATE` dispatch-elődik. Ez teszi **azonnali**vá a UI frissítést.
- **PayVault.refresh() nem hívódik** a buy handlerben: Korábban versenyhelyzetet okozott (felülírta a friss energiát egy késleltetett HTTP válaszból).

---

## 🎭 Smiley (Face) Rendszer

### Mentés:
- A játékos `face` értéke a `server/users/<username>.json`-ban tárolódik
- Smiley váltáskor a kliens `smiley` csomagot küld → szerver elmenti: `user.face = smileyId`

### Szoba csatlakozás:
- `PlayState.as` a szoba inicializálásakor beállítja: `Global.playerObject.smiley = face`
- A szerver figyelmen kívül hagyja a `smiley: 0` csomagokat a csatlakozás után 4 másodpercig (hogy ne írja felül a mentett face-t a kezdeti nullás alapértékkel)

**Releváns fájlok:**
- [PlayState.as](file:///c:/Games/EE/src_decompiled/scripts/states/PlayState.as) — Face betöltés szobába lépéskor
- [Server.js #685-695](file:///c:/Games/EE/server/src/Server.js) — Smiley csomag feldolgozás + 4s grace period

---

## 💎 Gem Vásárlás Rendszer

### Láncolat:
1. `ShopItem` → "10 Gems" gomb → `BaseShop.handleBuyItem()`
2. → `Shop.useGems(itemId, priceGems, ...)` → HTTP POST `/api/buy { isEnergy:false }`
3. Szerver levon gemeket, hozzáadja a tárgyat a `payVault`-hoz
4. Válasz → kliens frissíti `Global.playerObject.gems`
5. `spendGems` callback → `payVault.refresh()` → `Shop.refresh()` → UI frissítés

---

## 🛡️ Dupla Vásárlás Védelem

A szerver a `/api/buy` végpontban ellenőrzi:
```javascript
const isAlreadyOwned = user.payVault.includes(itemId) || user.payVault.includes(actualVaultId);
if (isAlreadyOwned) {
  return { success: true, unlocked: true, error: 'Item already owned' };
}
```

Mindkét ID-t ellenőrzi (`id` és `payvaultid`), mivel egyes tárgyak különböző ID-kel rendelkeznek a boltban és a PayVault-ban.

---

## 🔮 Aura Rendszer

### Staff aura:
- A `role` mező alapján a szerver meghatározza az aura típusát
- Az aura **nem hardkódolt** egy felhasználóra — bármely `isStaff: true` felhasználó megkapja

### Aura típusok:
| Rang | Aura |
|------|------|
| `admin` | Sárgás-pirosas (ID: 1) |
| `mod` | Kékes (ID: 2) |
| `user` | Nincs alapértelmezett |

**Releváns fájlok:**
- [ItemManager_aurasGalaxyBM.as](file:///c:/Games/EE/src_decompiled/scripts/items/ItemManager_aurasGalaxyBM.as) — Aura sprite kezelés
- [Player.as](file:///c:/Games/EE/src_decompiled/scripts/Player.as) — Aura renderelés

---

## 🏪 Bolt Felület (Shop UI)

### Komponens hierarchia:
```
LobbyState
├── ShopBar (felső sáv: gemek, energia, felhasználónév, "Shop" gomb)
└── MainShop extends BaseShop
    ├── TabBar (Smileys, Blocks, Auras, Worlds, NPCs, Services)
    └── ShopGrid
        └── ShopItem[] (egyedi tárgy kártyák)
            ├── EnergyBar (0/500 csík)
            ├── ButtonEnergy (+10 gomb)
            ├── btn_allenergy (+All gomb)
            └── btn_buy (10 Gems gomb)
```

### Adatfolyam:
1. **Betöltés:** `Shop.refresh()` → `EverybodyEdits.requestRemoteMethod("getShop")` → HTTP GET `/api/shop`
2. **Üzenet építés:** `EverybodyEdits.as` az `items.json`-ből és `Global.playerObject`-ből összerak egy `Message`-t:
   - Index 0: `gems`
   - Index 1: `energy` (← `Global.playerObject.energy`)
   - Index 2: `timeToEnergy` (60 sec)
   - Index 3: `maxEnergy` (← `Global.playerObject.maxEnergy`)
   - Index 4: `secondsBetweenEnergy` (150 sec)
   - Index 5+: Tárgyak (25 mezőnként)
3. **Shop.update():** Feldolgozza az üzenetet, frissíti a `dataidhash` és a `_energy` mezőt
4. **dispatch ShopEvent.UPDATE:** Triggereli `BaseShop.handleShopUpdate()` → `refreshGridItems()`
5. **ShopBar.refreshTopBar():** Frissíti a felső sáv energiáját és gemjeit

### Tárgy üzenet indexek (25 mező/tárgy):
| Index | Mező | Példa |
|-------|------|-------|
| 0 | `id` | `"smileycow"` |
| 1 | `type` | `"smiley"` |
| 2 | `priceEnergy` | `500` |
| 3 | `priceEnergyClick` | `10` |
| 4 | `energyUsed` (felhalmozott progress) | `120` |
| 5 | `priceGems` | `10` |
| 6 | `owned_count` (1 ha van) | `0` |
| 7 | `maxPurchases` | `4` |
| 8 | `name` | `"Cow Smiley"` |
| 9 | `description` | `"Mooing bovine face"` |
| 10 | `bitmapsheet_id` | `"smilies"` |
| 11 | `offset` | `46` |
| 12–24 | Flags (isOnSale, isFeatured, stb.) | — |

---

## 📡 TCP Protokoll (PlayerIO)

### Kommunikáció:
- Kliens ↔ Szerver TCP szoketen kommunikál a `PlayerIOProtocol` formátummal
- Üzenetek: `join`, `init`, `init2`, `smiley`, `aura`, `m` (mozgás), `b` (blokk), stb.

### Szoba csatlakozás:
```
Kliens → join ["PW_default", "connectUserId", "simpleplayer"]
Szerver → init [worldData...]
Kliens → init2 []
Kliens → smiley [95]   (mentett face)
Kliens → aura [0, 0]   (mentett aura)
```

### Fontos csomagok:
| Csomag | Irány | Leírás |
|--------|-------|--------|
| `join` | C→S | Szobához csatlakozás |
| `init` | S→C | Világ adatok küldése |
| `smiley` | C→S | Smiley váltás |
| `aura` | C→S | Aura váltás |
| `m` | C↔S | Játékos mozgás |
| `b` | C↔S | Blokk elhelyezés |

---

## 🔧 PayVault (Fizetési Rendszer)

### `PayVault.as` — Kliens oldali PayVault
- **refresh():** HTTP GET `/api/user/<username>` → frissíti `_items[]` és `_coins`
- **has(itemId):** Ellenőrzi, hogy a felhasználó rendelkezik-e a tárggyal
- **coins:** Gem egyenleg (getter)

### Felhasználónév feloldás (refresh sorrendje):
1. `Global.playerObject.name` (ha nem null/guest)
2. `Global.currentUsername` (ha van)
3. `_client.connectUserId` (utolsó fallback)
4. Ha `"simple"` prefixű → levágja (pl. `"simpleplayer"` → `"player"`)

---

## 🎮 Játék Indítása & Tesztelése

1. Győződj meg róla, hogy a szerver fut: `node server/index.js`
2. Nyisd meg a Flash Playert:
   - `game_local.swf` megnyitása `flashplayer_32_sa.exe`-vel
   - VAGY böngészőben: `http://localhost:8080/` (index.html + SWF)
3. Bejelentkezés:
   - Felhasználónév + jelszó a `server/users/<username>.json` alapján
   - Pl.: `Player` / `user123` vagy `KertaR` / `admin`

---

## ⚠️ Gyakori Hibák és Megoldások

| Hiba | Ok | Megoldás |
|------|-----|---------|
| Energia visszaugrik régi értékre | PayVault.refresh() felülírja | Eltávolítva a buy handlerből |
| "You got it!" hamisan jelenik meg | Shop.refresh() aszinkron, stale data | Helyi dataidhash frissítés HTTP helyett |
| Face 0-ra áll szobába lépéskor | Kliens alapértelmezett smiley küldés | 4s grace period a szerveren |
| Bolt nem frissül első megnyitáskor | itemEnergyProgress nem szinkronizálódik | PayVault.refresh() + Shop.reset() hozzáadva |
| Dupla vásárlás lehetséges | Nincs id ellenőrzés | id + payvaultid dupla check a szerveren |
| Energia nem vonódik le | itemEnergyProgress nem mentődik kliens oldalon | Global.playerObject.itemEnergyProgress frissítés a buy handlerben |

---

## 📝 Szerkesztett Fájlok Összefoglaló

### Szerver oldal:
| Fájl | Módosítás |
|------|-----------|
| `server/src/Server.js` | Inkrementális energia vásárlás, dupla vásárlás védelem, face mentés, smiley grace period |
| `server/src/UserManager.js` | `itemEnergyProgress: {}` alapértelmezés hozzáadva |

### Kliens oldal (ActionScript 3):
| Fájl | Módosítás |
|------|-----------|
| `EverybodyEdits.as` | Buy handler: energy/gems/itemEnergyProgress szinkronizálás, createShopMessage dinamikus energia, getShop energyProgress betöltés |
| `Shop.as` | energy getter: Global.playerObject.energy használata, spendEnergy: helyi dataidhash frissítés HTTP refresh helyett |
| `BaseShop.as` | handleShopUpdate: LobbyState.shopbar.refreshTopBar() hívás |
| `ShopBar.as` | refreshTopBar(): energia és gem kijelzés Shop.energy/Shop.gems alapján |
| `PayVault.as` | refresh(): energy + itemEnergyProgress szinkronizálás |
| `SimplePlayerObject.as` | `itemEnergyProgress: Object` mező hozzáadva |
| `PlayState.as` | Face betöltés szobába lépéskor |
