Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Force
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Write-Host "File extensions are now visible."
