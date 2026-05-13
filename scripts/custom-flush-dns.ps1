ipconfig /flushdns | Out-Null
Write-Host "DNS cache flushed."
[System.Windows.MessageBox]::Show("DNS cache flushed successfully.", "Network", "OK", "Information")
