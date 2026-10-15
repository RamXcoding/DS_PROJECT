# Read-only audit. Does not modify, move, or delete anything.
$ErrorActionPreference = "Continue"
$old  = "D:\SIH_2026\QuantumHeart_SIH_FINAL_READY\QuantumHeart"
$new  = "D:\SIH_2026\QuantumHealthSIH"

Write-Host "=== TOOL VERSIONS ===" -ForegroundColor Cyan
foreach ($c in @("python","py","node","npm.cmd","git")) {
    $cmd = Get-Command $c -ErrorAction SilentlyContinue
    if ($cmd) { Write-Host "$c -> $($cmd.Source)"; & $c --version 2>&1 }
    else      { Write-Host "$c -> NOT FOUND" -ForegroundColor Yellow }
}
Write-Host "`nInstalled Python versions (py launcher):"
py -0p 2>&1

Write-Host "`n=== D:\SIH_2026 CONTENTS ===" -ForegroundColor Cyan
Get-ChildItem "D:\SIH_2026" -Force -ErrorAction SilentlyContinue |
    Select-Object Mode, LastWriteTime, Name | Format-Table -AutoSize

Write-Host "=== NEW PROJECT ROOT EXISTS? ===" -ForegroundColor Cyan
Write-Host "$new -> $(Test-Path $new)"

Write-Host "`n=== OLD PROTOTYPE ===" -ForegroundColor Cyan
if (Test-Path $old) {
    Get-ChildItem $old -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch "node_modules|\\\.venv|__pycache__|\\\.git\\" } |
        Select-Object -ExpandProperty FullName
    foreach ($f in @("README.md","requirements.txt","backend\requirements.txt","package.json","frontend\package.json")) {
        $p = Join-Path $old $f
        if (Test-Path $p) { Write-Host "`n--- $f ---" -ForegroundColor Green; Get-Content $p -TotalCount 60 }
    }
    Write-Host "`n--- model / data files ---" -ForegroundColor Green
    Get-ChildItem $old -Recurse -Include *.pkl,*.joblib,*.csv,*.json,*.npy,*.data -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch "node_modules|\\\.venv" } |
        Select-Object FullName, Length
} else {
    Write-Host "Old prototype NOT FOUND at $old" -ForegroundColor Yellow
}

Write-Host "`n=== Other candidate folders / archives ===" -ForegroundColor Cyan
Get-ChildItem "D:\SIH_2026" -Recurse -Depth 2 -Include *.zip,*.7z -ErrorAction SilentlyContinue |
    Select-Object FullName, Length