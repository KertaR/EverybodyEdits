# Creates Desktop Shortcut for Everybody Edits
$WshShell = New-Object -ComObject WScript.Shell
$DesktopPath = [System.Environment]::GetFolderPath('Desktop')
$ShortcutPath = Join-Path $DesktopPath "Everybody Edits.lnk"

$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "c:\Games\EE\Launch-Game.bat"
$Shortcut.WorkingDirectory = "c:\Games\EE"
$Shortcut.Description = "Play Everybody Edits Private Server"

if (Test-Path "c:\Games\EE\flashplayer_32_sa.exe") {
    $Shortcut.IconLocation = "c:\Games\EE\flashplayer_32_sa.exe, 0"
}

$Shortcut.Save()
Write-Host "[Success] Created Desktop Shortcut: $ShortcutPath"
