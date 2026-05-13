# MyWinKit v6.1 - Silver Surfer Theme

$global:RepoBase = "https://raw.githubusercontent.com/sanjulaAI/MyWinKit/main"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Re-launching as Administrator..." -ForegroundColor Yellow
    $cmd = "irm $global:RepoBase/launcher.ps1 | iex"
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$cmd`""
    exit
}

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

function Invoke-RemoteScript {
    param([string]$Path)
    try {
        $code = Invoke-RestMethod -Uri "$global:RepoBase/$Path" -UseBasicParsing
        Invoke-Expression $code
    } catch {
        [System.Windows.MessageBox]::Show("Failed to load: $Path`n$($_.Exception.Message)", "Error", "OK", "Error")
    }
}

function Get-RemoteJson {
    param([string]$Path)
    try {
        return Invoke-RestMethod -Uri "$global:RepoBase/$Path" -UseBasicParsing
    } catch {
        return $null
    }
}

$xamlString = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="MyWinKit" Height="720" Width="1100"
        WindowStartupLocation="CenterScreen"
        Background="Black">
    <Window.Resources>
        <LinearGradientBrush x:Key="ChromeBrush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#E8E8E8" Offset="0"/>
            <GradientStop Color="#A8A8A8" Offset="0.5"/>
            <GradientStop Color="#FFFFFF" Offset="1"/>
        </LinearGradientBrush>
        <LinearGradientBrush x:Key="ChromeButton" StartPoint="0,0" EndPoint="0,1">
            <GradientStop Color="#3A3A3A" Offset="0"/>
            <GradientStop Color="#1A1A1A" Offset="1"/>
        </LinearGradientBrush>
        <LinearGradientBrush x:Key="ChromeButtonHover" StartPoint="0,0" EndPoint="0,1">
            <GradientStop Color="#5A5A5A" Offset="0"/>
            <GradientStop Color="#2A2A2A" Offset="1"/>
        </LinearGradientBrush>

        <Style x:Key="ChromeBtn" TargetType="Button">
            <Setter Property="Background" Value="{StaticResource ChromeButton}"/>
            <Setter Property="Foreground" Value="#E8E8E8"/>
            <Setter Property="BorderBrush" Value="#888888"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="14,8"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="{StaticResource ChromeButtonHover}"/>
                                <Setter Property="BorderBrush" Value="#CCCCCC"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid>
        <Grid.Background>
            <ImageBrush ImageSource="https://raw.githubusercontent.com/sanjulaAI/MyWinKit/main/SILVER_SURFER.png"
                        Stretch="UniformToFill"/>
        </Grid.Background>

        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="150"/>
        </Grid.RowDefinitions>

        <Grid Grid.Row="0" Margin="20,15,20,5">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <StackPanel Grid.Column="0" Orientation="Vertical">
                <TextBlock Text="MYWINKIT" FontSize="28" FontWeight="Light" Foreground="{StaticResource ChromeBrush}" Margin="0,0,0,-4">
                    <TextBlock.Effect>
                        <DropShadowEffect Color="White" BlurRadius="15" ShadowDepth="0" Opacity="0.4"/>
                    </TextBlock.Effect>
                </TextBlock>
                <TextBlock Text="All-in-One Windows Toolkit" FontSize="11" Foreground="#888888" Margin="2,0,0,0" FontStyle="Italic"/>
            </StackPanel>
            <StackPanel Grid.Column="1" Orientation="Vertical" HorizontalAlignment="Right">
                <TextBlock Name="ClockText" FontSize="26" FontWeight="Light" Foreground="{StaticResource ChromeBrush}" TextAlignment="Right" FontFamily="Segoe UI Light">
                    <TextBlock.Effect>
                        <DropShadowEffect Color="White" BlurRadius="20" ShadowDepth="0" Opacity="0.5"/>
                    </TextBlock.Effect>
                </TextBlock>
                <TextBlock Name="DateText" FontSize="11" Foreground="#999999" TextAlignment="Right" Margin="0,2,2,0"/>
            </StackPanel>
        </Grid>

        <Border Grid.Row="1" Margin="15,5,15,5" CornerRadius="8" HorizontalAlignment="Left" Width="540">
            <Border.Background>
                <SolidColorBrush Color="#000000" Opacity="0.55"/>
            </Border.Background>
            <Border.BorderBrush>
                <SolidColorBrush Color="#444444" Opacity="0.6"/>
            </Border.BorderBrush>
            <Border.BorderThickness>1</Border.BorderThickness>

            <TabControl Background="Transparent" BorderThickness="0" Padding="0" Margin="5">
                <TabControl.Resources>
                    <Style TargetType="TabItem">
                        <Setter Property="Background" Value="Transparent"/>
                        <Setter Property="Foreground" Value="#AAAAAA"/>
                        <Setter Property="Padding" Value="12,8"/>
                        <Setter Property="FontSize" Value="11"/>
                        <Setter Property="FontWeight" Value="SemiBold"/>
                        <Setter Property="Template">
                            <Setter.Value>
                                <ControlTemplate TargetType="TabItem">
                                    <Border Name="Border" Background="{TemplateBinding Background}" Padding="{TemplateBinding Padding}" CornerRadius="4,4,0,0" Margin="2,0">
                                        <ContentPresenter ContentSource="Header" HorizontalAlignment="Center" VerticalAlignment="Center" TextBlock.Foreground="{TemplateBinding Foreground}"/>
                                    </Border>
                                    <ControlTemplate.Triggers>
                                        <Trigger Property="IsSelected" Value="True">
                                            <Setter TargetName="Border" Property="Background" Value="#1A1A1A"/>
                                            <Setter Property="Foreground" Value="#FFFFFF"/>
                                        </Trigger>
                                        <Trigger Property="IsMouseOver" Value="True">
                                            <Setter Property="Foreground" Value="#FFFFFF"/>
                                        </Trigger>
                                    </ControlTemplate.Triggers>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                    </Style>
                </TabControl.Resources>

                <TabItem Header="INSTALL APPS">
                    <Grid Margin="0,5,0,0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>
                        <ScrollViewer Grid.Row="0" VerticalScrollBarVisibility="Auto">
                            <StackPanel Name="AppsPanel" Margin="15"/>
                        </ScrollViewer>
                        <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="15,10">
                            <Button Name="InstallBtn" Content="INSTALL" Style="{StaticResource ChromeBtn}" Margin="0,0,8,0"/>
                            <Button Name="UninstallBtn" Content="UNINSTALL" Style="{StaticResource ChromeBtn}" Margin="0,0,8,0"/>
                            <Button Name="FixWingetBtn" Content="FIX WINGET" Style="{StaticResource ChromeBtn}"/>
                        </StackPanel>
                    </Grid>
                </TabItem>

                <TabItem Header="TWEAKS">
                    <Grid Margin="0,5,0,0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>
                        <ScrollViewer Grid.Row="0" VerticalScrollBarVisibility="Auto">
                            <StackPanel Name="TweaksPanel" Margin="15"/>
                        </ScrollViewer>
                        <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="15,10">
                            <Button Name="ApplyTweaksBtn" Content="APPLY SELECTED" Style="{StaticResource ChromeBtn}"/>
                        </StackPanel>
                    </Grid>
                </TabItem>

                <TabItem Header="MONITOR">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel Margin="20">
                            <TextBlock Text="LIVE SYSTEM STATS" Foreground="{StaticResource ChromeBrush}" FontSize="14" FontWeight="Bold" Margin="0,0,0,15"/>

                            <TextBlock Name="CpuLabel" Foreground="#E8E8E8" FontSize="13" Margin="0,5,0,3"/>
                            <ProgressBar Name="CpuBar" Height="14" Maximum="100" Foreground="#E8E8E8" Background="#22FFFFFF" BorderThickness="0"/>

                            <TextBlock Name="RamLabel" Foreground="#E8E8E8" FontSize="13" Margin="0,12,0,3"/>
                            <ProgressBar Name="RamBar" Height="14" Maximum="100" Foreground="#C0C0C0" Background="#22FFFFFF" BorderThickness="0"/>

                            <TextBlock Name="DiskLabel" Foreground="#E8E8E8" FontSize="13" Margin="0,12,0,3"/>
                            <ProgressBar Name="DiskBar" Height="14" Maximum="100" Foreground="#A0A0A0" Background="#22FFFFFF" BorderThickness="0"/>

                            <TextBlock Text="NETWORK INFORMATION" Foreground="{StaticResource ChromeBrush}" FontSize="14" FontWeight="Bold" Margin="0,20,0,8"/>
                            <Border Background="#33000000" CornerRadius="4" Padding="2">
                                <TextBox Name="NetworkInfo" Background="Transparent" Foreground="#E8E8E8" FontFamily="Consolas" FontSize="12" BorderThickness="0" IsReadOnly="True" Padding="10" TextWrapping="Wrap" Text="Loading..."/>
                            </Border>

                            <StackPanel Orientation="Horizontal" Margin="0,15,0,0">
                                <Button Name="RefreshStatsBtn" Content="REFRESH" Style="{StaticResource ChromeBtn}" Margin="0,0,8,0"/>
                                <Button Name="SpeedTestBtn" Content="PING TEST" Style="{StaticResource ChromeBtn}"/>
                            </StackPanel>
                        </StackPanel>
                    </ScrollViewer>
                </TabItem>

                <TabItem Header="DRIVERS">
                    <Grid Margin="0,5,0,0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>
                        <TextBlock Grid.Row="0" Text="Scan and update drivers via Windows Update" Foreground="#AAAAAA" Margin="20,15,20,10" FontStyle="Italic"/>
                        <Border Grid.Row="1" Background="#33000000" CornerRadius="4" Margin="20,0">
                            <ScrollViewer>
                                <TextBox Name="DriverOutput" Background="Transparent" Foreground="#E8E8E8" FontFamily="Consolas" FontSize="12" BorderThickness="0" IsReadOnly="True" Padding="10" TextWrapping="Wrap" Text="Click SCAN to check for driver updates."/>
                            </ScrollViewer>
                        </Border>
                        <StackPanel Grid.Row="2" Orientation="Horizontal" Margin="20,10,20,15">
                            <Button Name="ScanDriversBtn" Content="SCAN" Style="{StaticResource ChromeBtn}" Margin="0,0,8,0"/>
                            <Button Name="InstallDriversBtn" Content="INSTALL ALL" Style="{StaticResource ChromeBtn}"/>
                        </StackPanel>
                    </Grid>
                </TabItem>

                <TabItem Header="SCRIPTS">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <WrapPanel Name="CustomPanel" Margin="15"/>
                    </ScrollViewer>
                </TabItem>
            </TabControl>
        </Border>

        <Border Grid.Row="2" Margin="15,5,15,15" CornerRadius="8" HorizontalAlignment="Left" Width="540">
            <Border.Background>
                <SolidColorBrush Color="#000000" Opacity="0.7"/>
            </Border.Background>
            <Border.BorderBrush>
                <SolidColorBrush Color="#444444" Opacity="0.6"/>
            </Border.BorderBrush>
            <Border.BorderThickness>1</Border.BorderThickness>
            <ScrollViewer VerticalScrollBarVisibility="Auto">
                <TextBox Name="LogBox" Background="Transparent" Foreground="#C0C0C0"
                         FontFamily="Consolas" FontSize="11" BorderThickness="0"
                         IsReadOnly="True" TextWrapping="Wrap" Padding="12"
                         Text="// SYSTEM READY"/>
            </ScrollViewer>
        </Border>
    </Grid>
</Window>
'@

$stringReader = New-Object System.IO.StringReader $xamlString
$xmlReader = [System.Xml.XmlReader]::Create($stringReader)
$window = [Windows.Markup.XamlReader]::Load($xmlReader)

$AppsPanel        = $window.FindName("AppsPanel")
$TweaksPanel      = $window.FindName("TweaksPanel")
$CustomPanel      = $window.FindName("CustomPanel")
$LogBox           = $window.FindName("LogBox")
$InstallBtn       = $window.FindName("InstallBtn")
$UninstallBtn     = $window.FindName("UninstallBtn")
$FixWingetBtn     = $window.FindName("FixWingetBtn")
$ApplyTweaksBtn   = $window.FindName("ApplyTweaksBtn")
$ClockText        = $window.FindName("ClockText")
$DateText         = $window.FindName("DateText")
$CpuBar           = $window.FindName("CpuBar")
$RamBar           = $window.FindName("RamBar")
$DiskBar          = $window.FindName("DiskBar")
$CpuLabel         = $window.FindName("CpuLabel")
$RamLabel         = $window.FindName("RamLabel")
$DiskLabel        = $window.FindName("DiskLabel")
$NetworkInfo      = $window.FindName("NetworkInfo")
$RefreshStatsBtn  = $window.FindName("RefreshStatsBtn")
$SpeedTestBtn     = $window.FindName("SpeedTestBtn")
$ScanDriversBtn   = $window.FindName("ScanDriversBtn")
$InstallDriversBtn = $window.FindName("InstallDriversBtn")
$DriverOutput     = $window.FindName("DriverOutput")

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(1)
$timer.Add_Tick({
    $ClockText.Text = Get-Date -Format "HH:mm:ss"
    $DateText.Text  = (Get-Date -Format "dddd, MMM dd yyyy").ToUpper()
})
$timer.Start()
$ClockText.Text = Get-Date -Format "HH:mm:ss"
$DateText.Text  = (Get-Date -Format "dddd, MMM dd yyyy").ToUpper()

function Update-SystemStats {
    try {
        $cpu = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
        $os  = Get-CimInstance Win32_OperatingSystem
        $totalRam = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
        $freeRam  = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        $usedRam  = $totalRam - $freeRam
        $ramPct   = [math]::Round(($usedRam / $totalRam) * 100, 1)

        $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
        $diskTotal = [math]::Round($disk.Size / 1GB, 1)
        $diskFree  = [math]::Round($disk.FreeSpace / 1GB, 1)
        $diskUsed  = $diskTotal - $diskFree
        $diskPct   = [math]::Round(($diskUsed / $diskTotal) * 100, 1)

        $CpuBar.Value = $cpu
        $RamBar.Value = $ramPct
        $DiskBar.Value = $diskPct
        $CpuLabel.Text = "CPU  ::  $cpu %"
        $RamLabel.Text = "RAM  ::  $usedRam / $totalRam GB  ($ramPct %)"
        $DiskLabel.Text = "DISK ::  $diskUsed / $diskTotal GB  ($diskPct %)"
    } catch {}
}

function Update-NetworkInfo {
    try {
        $adapter = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null } | Select-Object -First 1
        $publicIp = try { (Invoke-RestMethod "https://api.ipify.org?format=json" -TimeoutSec 3).ip } catch { "N/A" }
        $info = "ADAPTER   ::  $($adapter.InterfaceAlias)`n"
        $info += "LOCAL IP  ::  $($adapter.IPv4Address.IPAddress)`n"
        $info += "GATEWAY   ::  $($adapter.IPv4DefaultGateway.NextHop)`n"
        $info += "DNS       ::  $($adapter.DNSServer.ServerAddresses -join ', ')`n"
        $info += "PUBLIC IP ::  $publicIp"
        $NetworkInfo.Text = $info
    } catch {
        $NetworkInfo.Text = "Could not retrieve network info."
    }
}

Update-SystemStats
Update-NetworkInfo

$statsTimer = New-Object System.Windows.Threading.DispatcherTimer
$statsTimer.Interval = [TimeSpan]::FromSeconds(2)
$statsTimer.Add_Tick({ Update-SystemStats })
$statsTimer.Start()

$RefreshStatsBtn.Add_Click({
    Update-SystemStats
    Update-NetworkInfo
    $LogBox.AppendText("`n// Stats refreshed")
})

$SpeedTestBtn.Add_Click({
    $LogBox.AppendText("`n// Pinging 8.8.8.8 ...")
    $result = Test-Connection -ComputerName "8.8.8.8" -Count 4 -ErrorAction SilentlyContinue
    if ($result) {
        $avg = ($result | Measure-Object -Property ResponseTime -Average).Average
        $LogBox.AppendText("`n// Average ping: $([math]::Round($avg,1)) ms")
    } else {
        $LogBox.AppendText("`n// Ping failed")
    }
})

$FixWingetBtn.Add_Click({
    $LogBox.AppendText("`n// Resetting winget sources...")
    try {
        Start-Process winget -ArgumentList "source reset --force" -Wait -NoNewWindow
        Start-Process winget -ArgumentList "source update" -Wait -NoNewWindow
        $LogBox.AppendText("`n// Winget sources fixed.")
    } catch {
        $LogBox.AppendText("`n// Error: $($_.Exception.Message)")
    }
})

$ScanDriversBtn.Add_Click({
    $DriverOutput.Text = "// Scanning... (30-60 seconds)"
    $LogBox.AppendText("`n// Scanning drivers via Windows Update...")
    try {
        $session = New-Object -ComObject Microsoft.Update.Session
        $searcher = $session.CreateUpdateSearcher()
        $searcher.ServiceID = "7971f918-a847-4430-9279-4a52d1efe18d"
        $searcher.SearchScope = 1
        $searcher.ServerSelection = 3
        $result = $searcher.Search("IsInstalled=0 and Type='Driver'")

        if ($result.Updates.Count -eq 0) {
            $DriverOutput.Text = "// All drivers up to date."
        } else {
            $list = "// Found $($result.Updates.Count) driver update(s):`n`n"
            foreach ($u in $result.Updates) { $list += "  - $($u.Title)`n" }
            $DriverOutput.Text = $list
            $global:PendingDrivers = $result.Updates
        }
        $LogBox.AppendText("`n// Driver scan complete.")
    } catch {
        $DriverOutput.Text = "// Scan failed: $($_.Exception.Message)"
    }
})

$InstallDriversBtn.Add_Click({
    if (-not $global:PendingDrivers -or $global:PendingDrivers.Count -eq 0) {
        $DriverOutput.Text += "`n`n// No pending drivers. Run SCAN first."
        return
    }
    $LogBox.AppendText("`n// Installing $($global:PendingDrivers.Count) driver(s)...")
    try {
        $session = New-Object -ComObject Microsoft.Update.Session
        $coll = New-Object -ComObject Microsoft.Update.UpdateColl
        foreach ($u in $global:PendingDrivers) { $coll.Add($u) | Out-Null }
        $downloader = $session.CreateUpdateDownloader()
        $downloader.Updates = $coll
        $downloader.Download() | Out-Null
        $installer = $session.CreateUpdateInstaller()
        $installer.Updates = $coll
        $installResult = $installer.Install()
        $DriverOutput.Text += "`n`n// Install complete. Result: $($installResult.ResultCode)"
        $LogBox.AppendText("`n// Driver install complete.")
    } catch {
        $LogBox.AppendText("`n// Driver install failed: $($_.Exception.Message)")
    }
})

$apps = Get-RemoteJson "config/apps.json"
if ($apps) {
    foreach ($category in $apps.PSObject.Properties) {
        $header = New-Object System.Windows.Controls.TextBlock
        $header.Text = $category.Name.ToUpper()
        $header.FontWeight = "Bold"
        $header.FontSize = 12
        $header.Margin = "0,12,0,6"
        $header.Foreground = "#E8E8E8"
        $AppsPanel.Children.Add($header) | Out-Null

        foreach ($app in $category.Value) {
            $cb = New-Object System.Windows.Controls.CheckBox
            $cb.Content = $app.name
            $cb.Tag = $app.id
            $cb.Margin = "10,2,0,2"
            $cb.Foreground = "#CCCCCC"
            $AppsPanel.Children.Add($cb) | Out-Null
        }
    }
}

$InstallBtn.Add_Click({
    $selected = @()
    foreach ($child in $AppsPanel.Children) {
        if ($child -is [System.Windows.Controls.CheckBox] -and $child.IsChecked) {
            $selected += $child.Tag
        }
    }
    if ($selected.Count -eq 0) {
        [System.Windows.MessageBox]::Show("No apps selected.", "MyWinKit", "OK", "Information")
        return
    }
    $LogBox.AppendText("`n// Installing $($selected.Count) app(s)...")
    foreach ($id in $selected) {
        $LogBox.AppendText("`n//   > $id")
        Start-Process winget -ArgumentList "install --id $id --silent --accept-source-agreements --accept-package-agreements" -Wait -NoNewWindow
    }
    $LogBox.AppendText("`n// Done.")
})

$UninstallBtn.Add_Click({
    $selected = @()
    foreach ($child in $AppsPanel.Children) {
        if ($child -is [System.Windows.Controls.CheckBox] -and $child.IsChecked) {
            $selected += $child.Tag
        }
    }
    if ($selected.Count -eq 0) { return }
    $LogBox.AppendText("`n// Uninstalling $($selected.Count) app(s)...")
    foreach ($id in $selected) {
        $LogBox.AppendText("`n//   > removing $id")
        Start-Process winget -ArgumentList "uninstall --id $id --silent" -Wait -NoNewWindow
    }
    $LogBox.AppendText("`n// Done.")
})

$tweaks = Get-RemoteJson "config/tweaks.json"
if ($tweaks) {
    foreach ($tweak in $tweaks) {
        $cb = New-Object System.Windows.Controls.CheckBox
        $cb.Content = $tweak.name
        $cb.Tag = $tweak.script
        $cb.ToolTip = $tweak.description
        $cb.Margin = "10,4,0,4"
        $cb.Foreground = "#CCCCCC"
        $TweaksPanel.Children.Add($cb) | Out-Null
    }
}

$ApplyTweaksBtn.Add_Click({
    foreach ($child in $TweaksPanel.Children) {
        if ($child -is [System.Windows.Controls.CheckBox] -and $child.IsChecked) {
            $LogBox.AppendText("`n// Applying: $($child.Content)")
            Invoke-RemoteScript "scripts/$($child.Tag)"
        }
    }
    $LogBox.AppendText("`n// Tweaks applied.")
})

$customs = Get-RemoteJson "config/custom.json"
if ($customs) {
    foreach ($item in $customs) {
        $btn = New-Object System.Windows.Controls.Button
        $btn.Content = $item.name.ToUpper()
        $btn.Tag = $item.script
        $btn.Margin = "5"
        $btn.Padding = "14,8"
        $btn.Style = $window.FindResource("ChromeBtn")
        $btn.HorizontalAlignment = "Left"
        $btn.Add_Click({
            param($sender, $e)
            $LogBox.AppendText("`n// Running: $($sender.Content)")
            Invoke-RemoteScript "scripts/$($sender.Tag)"
        }.GetNewClosure())
        $CustomPanel.Children.Add($btn) | Out-Null
    }
}

$window.Add_Closed({
    $timer.Stop()
    $statsTimer.Stop()
})

$window.ShowDialog() | Out-Null
