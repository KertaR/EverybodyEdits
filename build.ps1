# ======================================================
# Everybody Edits SWF Builder Script (Full Auto-Sync)
# Usage: .\build.ps1 or npm run build
# ======================================================

Write-Host "[Build] Stopping active Flash Player instances..." -ForegroundColor Yellow
Stop-Process -Name "flashplayer_32_sa" -Force -ErrorAction SilentlyContinue

Write-Host "[Build] Preparing temporary source directory..." -ForegroundColor Yellow
if (Test-Path "temp_src") { Remove-Item -Recurse -Force "temp_src" }

New-Item -ItemType Directory -Force "temp_src" | Out-Null
New-Item -ItemType Directory -Force "temp_src/playerio" | Out-Null
New-Item -ItemType Directory -Force "temp_src/data" | Out-Null
New-Item -ItemType Directory -Force "temp_src/states" | Out-Null
New-Item -ItemType Directory -Force "temp_src/ui" | Out-Null
New-Item -ItemType Directory -Force "temp_src/ui/login" | Out-Null
New-Item -ItemType Directory -Force "temp_src/ui/shop" | Out-Null
New-Item -ItemType Directory -Force "temp_src/ui/roomlist" | Out-Null
New-Item -ItemType Directory -Force "temp_src/ui/chat" | Out-Null
New-Item -ItemType Directory -Force "temp_src/items" | Out-Null

Copy-Item "src_decompiled/scripts/EverybodyEdits.as" "temp_src/"
Copy-Item "src_decompiled/scripts/Global.as" "temp_src/"
Copy-Item "src_decompiled/scripts/Badges.as" "temp_src/"
Copy-Item "src_decompiled/scripts/Shop.as" "temp_src/"
Copy-Item "src_decompiled/scripts/Config.as" "temp_src/"
Copy-Item "src_decompiled/scripts/Player.as" "temp_src/"
Copy-Item "src_decompiled/scripts/UI2.as" "temp_src/"
Copy-Item "src_decompiled/scripts/ImageUtils.as" "temp_src/"
Copy-Item "src_decompiled/scripts/items/ItemManager.as" "temp_src/items/"
Copy-Item "src_decompiled/scripts/ui/PlayerWorlds.as" "temp_src/ui/"
Copy-Item "src_decompiled/scripts/ui/RegisterWindow.as" "temp_src/ui/"
Copy-Item "src_decompiled/scripts/ui/roomlist/RoomList.as" "temp_src/ui/roomlist/"
Copy-Item "src_decompiled/scripts/ui/login/MainLogin.as" "temp_src/ui/login/"
Copy-Item "src_decompiled/scripts/ui/shop/ShopBar.as" "temp_src/ui/shop/"
Copy-Item "src_decompiled/scripts/ui/shop/MainShop.as" "temp_src/ui/shop/"
Copy-Item "src_decompiled/scripts/ui/shop/BaseShop.as" "temp_src/ui/shop/"
Copy-Item "src_decompiled/scripts/ui/shop/ShopGrid.as" "temp_src/ui/shop/"
Copy-Item "src_decompiled/scripts/ui/shop/ShopItem.as" "temp_src/ui/shop/"
Copy-Item "src_decompiled/scripts/ui/chat/UserlistItem.as" "temp_src/ui/chat/"
Copy-Item "src_decompiled/scripts/states/PlayState.as" "temp_src/states/"
Copy-Item "src_decompiled/scripts/states/LobbyState.as" "temp_src/states/"
Copy-Item "src_decompiled/scripts/states/LoadState.as" "temp_src/states/"
Copy-Item "src_decompiled/scripts/states/JoinState.as" "temp_src/states/"
Copy-Item "src_decompiled/scripts/playerio/Connection.as" "temp_src/playerio/"
Copy-Item "src_decompiled/scripts/playerio/Multiplayer.as" "temp_src/playerio/"
Copy-Item "src_decompiled/scripts/playerio/QuickConnect.as" "temp_src/playerio/"
Copy-Item "src_decompiled/scripts/playerio/BigDB.as" "temp_src/playerio/"
Copy-Item "src_decompiled/scripts/playerio/PayVault.as" "temp_src/playerio/"
Copy-Item "src_decompiled/scripts/playerio/PlayerIO.as" "temp_src/playerio/"
Copy-Item "src_decompiled/scripts/playerio/VaultItem.as" "temp_src/playerio/"
Copy-Item "src_decompiled/scripts/data/SimplePlayerObject.as" "temp_src/data/"

Write-Host "[Build] Compiling game_local.swf with FFDec..." -ForegroundColor Cyan
java -jar ffdec/ffdec.jar -importScript game.swf game_local.swf temp_src

Remove-Item -Recurse -Force "temp_src"

Write-Host "[Build] SUCCESS! Entire codebase compiled cleanly into game_local.swf!" -ForegroundColor Green
