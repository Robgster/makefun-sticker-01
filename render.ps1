# Renders sticker.svg to sticker.png (1024x1024, transparent outside the die-cut) with headless Edge.
# Run from the repository root: powershell -File render.ps1
$root = $PSScriptRoot
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$svg  = Get-Content -Raw (Join-Path $root "sticker.svg")
$tmp  = Join-Path $env:TEMP "makefun-sticker-render"
New-Item -ItemType Directory -Force $tmp | Out-Null
$html = "<!doctype html><html><head><meta charset='utf-8'><style>html,body{margin:0;padding:0;background:transparent;overflow:hidden}svg{display:block}</style></head><body>$svg</body></html>"
[IO.File]::WriteAllText((Join-Path $tmp "sticker.html"), $html, [Text.UTF8Encoding]::new($false))
$out = Join-Path $root "sticker.png"
& $edge --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 --default-background-color=00000000 `
  --window-size=1024,1024 "--user-data-dir=$tmp\profile" "--screenshot=$out" "file:///$($tmp -replace '\\','/')/sticker.html" 2>$null | Out-Null
Start-Sleep -Milliseconds 500
Get-Item $out | Select-Object Name, Length
