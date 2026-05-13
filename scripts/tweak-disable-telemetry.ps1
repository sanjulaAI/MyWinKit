# Disable Windows Telemetry
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
Get-Service DiagTrack -ErrorAction SilentlyContinue | Stop-Service -Force -ErrorAction SilentlyContinue
Get-Service DiagTrack -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue
Write-Host "Telemetry disabled."
