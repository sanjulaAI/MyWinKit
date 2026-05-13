New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Force -ErrorAction SilentlyContinue | Out-Null
Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Type DWord -Value 1 -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
Write-Host "Bing search in Start Menu disabled."
