# Show basic system info in a popup
$info = @"
Computer:  $env:COMPUTERNAME
User:      $env:USERNAME
OS:        $((Get-CimInstance Win32_OperatingSystem).Caption)
Build:     $((Get-CimInstance Win32_OperatingSystem).BuildNumber)
CPU:       $((Get-CimInstance Win32_Processor).Name)
RAM:       $([math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)) GB
"@
[System.Windows.MessageBox]::Show($info, "System Info", "OK", "Information")
