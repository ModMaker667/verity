# p.ps1 - downloads the mp3 to temp and loops it at max volume
$u = 'https://your-host/s.mp3'
$f = Join-Path $env:TEMP 's.mp3'
try {
    Invoke-WebRequest -Uri $u -OutFile $f -UseBasicParsing -TimeoutSec 20
} catch {
    # fallback: loud generated siren if download failed
    while (1) { [console]::beep(1200, 200); [console]::beep(800, 200) }
}
Add-Type -AssemblyName PresentationCore
$p = New-Object System.Windows.Media.MediaPlayer
$p.Open([uri]$f)
$p.Volume = 1
$p.Play()
# keep process alive and re-trigger Play if it ever stops
while (1) { Start-Sleep -Seconds 1 }