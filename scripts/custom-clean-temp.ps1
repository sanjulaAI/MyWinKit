# Clean temp folders
$paths = @("$env:TEMP\*", "C:\Windows\Temp\*", "C:\Windows\Prefetch\*")
$freed = 0
foreach ($p in $paths) {
    try {
        $size = (Get-ChildItem $p -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue
        $freed += $size
    } catch {}
}
$mb = [math]::Round($freed / 1MB, 2)
Write-Host "Cleaned. Approximate space reclaimed: $mb MB"
[System.Windows.MessageBox]::Show("Temp files cleaned.`nApprox $mb MB freed.", "Cleanup", "OK", "Information")
