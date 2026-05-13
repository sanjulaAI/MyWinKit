# ============================================================
#  MyWinKit - All-in-One Windows Toolkit
# ============================================================

$global:RepoBase = "https://raw.githubusercontent.com/sanjulaAI/MyWinKit/main"

# ---- Auto-elevate ----
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Re-launching as Administrator..." -ForegroundColor Yellow
    $cmd = "irm $global:RepoBase/launcher.ps1 | iex"
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$cmd`""
    exit
}

# ---- Load WPF assemblies ----
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms

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

# ---- XAML is embedded directly (no external file = no parsing issues) ----
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="MyWinKit" Height="650" Width="900"
        Background="#1E1E1E" WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <Style TargetType="TabItem">
            <Setter Property="Background" Value="#2D2D30"/>
            <Setter Property="Foreground" Value="Black"/>
            <Setter Property="Padding" Value="12,6"/>
            <Setter Property="FontSize" Value="13"/>
        </Style>
        <Style TargetType="Button">
            <Setter Property="Background" Value="#0E639C"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="12,6"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Cursor" Value="Hand"/>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="150"/>
        </Grid.RowDefinitions>
        <Border Grid.Row="0" Background="#252526" Padding="15,10">
            <TextBlock Text="MyWinKit  -  All-in-One Windows Toolkit"
                       Foreground="#4FC3F7" FontSize="18" FontWeight="Bold"/>
        </Border>
        <TabControl Grid.Row="1" Background="#1E1E1E" BorderThickness="0">
            <TabItem Header="Install Apps">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    <ScrollViewer Grid.Row="0" VerticalScrollBarVisibility="Auto">
                        <StackPanel Name="AppsPanel" Margin="15"/>
                    </ScrollViewer>
                    <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="15,10">
                        <Button Name="InstallBtn" Content="Install Selected" Margin="0,0,10,0"/>
                        <Button Name="UninstallBtn" Content="Uninstall Selected" Background="#C42B1C"/>
                    </StackPanel>
                </Grid>
            </TabItem>
            <TabItem Header="Tweaks and Debloat">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    <ScrollViewer Grid.Row="0" VerticalScrollBarVisibility="Auto">
                        <StackPanel Name="TweaksPanel" Margin="15"/>
                    </ScrollViewer>
                    <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="15,10">
                        <Button Name="ApplyTweaksBtn" Content="Apply Selected Tweaks"/>
                    </StackPanel>
                </Grid>
            </TabItem>
            <TabItem Header="My Scripts">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <WrapPanel Name="CustomPanel" Margin="15"/>
                </ScrollViewer>
            </TabItem>
        </TabControl>
        <Border Grid.Row="2" Background="#0C0C0C" Margin="10,5,10,10">
            <ScrollViewer VerticalScrollBarVisibility="Auto">
                <TextBox Name="LogBox" Background="Transparent" Foreground="#7FFF7F"
                         FontFamily="Consolas" FontSize="12" BorderThickness="0"
                         IsReadOnly="True" TextWrapping="Wrap" Padding="10"
                         Text="Ready. Select options and click an action button.&#10;"/>
            </ScrollViewer>
        </Border>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# ---- Find controls ----
$AppsPanel       = $window.FindName("AppsPanel")
$TweaksPanel     = $window.FindName("TweaksPanel")
$CustomPanel     = $window.FindName("CustomPanel")
$LogBox          = $window.FindName("LogBox")
$InstallBtn      = $window.FindName("InstallBtn")
$UninstallBtn    = $window.FindName("UninstallBtn")
$ApplyTweaksBtn  = $window.FindName("ApplyTweaksBtn")

# Diagnostic check
$missing = @()
if (-not $AppsPanel)      { $missing += "AppsPanel" }
if (-not $TweaksPanel)    { $missing += "TweaksPanel" }
if (-not $CustomPanel)    { $missing += "CustomPanel" }
if (-not $LogBox)         { $missing += "LogBox" }
if (-not $InstallBtn)     { $missing += "InstallBtn" }
if (-not $UninstallBtn)   { $missing += "UninstallBtn" }
if (-not $ApplyTweaksBtn) { $missing += "ApplyTweaksBtn" }

if ($missing.Count -gt 0) {
    [System.Windows.MessageBox]::Show("Missing controls: $($missing -join ', ')", "Error", "OK", "Error")
    return
}

# ============================================================
#  TAB 1: INSTALL APPS
# ============================================================
$apps = Get-RemoteJson "config/apps.json"
if ($apps) {
    foreach ($category in $apps.PSObject.Properties) {
        $header = New-Object System.Windows.Controls.TextBlock
        $header.Text = $category.Name
        $header.FontWeight = "Bold"
        $header.FontSize = 14
        $header.Margin = "0,10,0,5"
        $header.Foreground = "#4FC3F7"
        $AppsPanel.Children.Add($header) | Out-Null

        foreach ($app in $category.Value) {
            $cb = New-Object System.Windows.Controls.CheckBox
            $cb.Content = $app.name
            $cb.Tag = $app.id
            $cb.Margin = "10,2,0,2"
            $cb.Foreground = "White"
            $AppsPanel.Children.Add($cb) | Out-Null
        }
    }
} else {
    $LogBox.AppendText("WARNING: Could not load apps.json from GitHub.`n")
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
    $LogBox.AppendText("`n>> Installing $($selected.Count) app(s)...`n")
    foreach ($id in $selected) {
        $LogBox.AppendText("Installing $id ...`n")
        Start-Process winget -ArgumentList "install --id $id --silent --accept-source-agreements --accept-package-agreements" -Wait -NoNewWindow
    }
    $LogBox.AppendText(">> Done.`n")
})

$UninstallBtn.Add_Click({
    $selected = @()
    foreach ($child in $AppsPanel.Children) {
        if ($child -is [System.Windows.Controls.CheckBox] -and $child.IsChecked) {
            $selected += $child.Tag
        }
    }
    if ($selected.Count -eq 0) { return }
    $LogBox.AppendText("`n>> Uninstalling $($selected.Count) app(s)...`n")
    foreach ($id in $selected) {
        $LogBox.AppendText("Removing $id ...`n")
        Start-Process winget -ArgumentList "uninstall --id $id --silent" -Wait -NoNewWindow
    }
    $LogBox.AppendText(">> Done.`n")
})

# ============================================================
#  TAB 2: TWEAKS
# ============================================================
$tweaks = Get-RemoteJson "config/tweaks.json"
if ($tweaks) {
    foreach ($tweak in $tweaks) {
        $cb = New-Object System.Windows.Controls.CheckBox
        $cb.Content = $tweak.name
        $cb.Tag = $tweak.script
        $cb.ToolTip = $tweak.description
        $cb.Margin = "10,4,0,4"
        $cb.Foreground = "White"
        $TweaksPanel.Children.Add($cb) | Out-Null
    }
} else {
    $LogBox.AppendText("WARNING: Could not load tweaks.json from GitHub.`n")
}

$ApplyTweaksBtn.Add_Click({
    foreach ($child in $TweaksPanel.Children) {
        if ($child -is [System.Windows.Controls.CheckBox] -and $child.IsChecked) {
            $LogBox.AppendText("Applying tweak: $($child.Content)`n")
            Invoke-RemoteScript "scripts/$($child.Tag)"
        }
    }
    $LogBox.AppendText(">> Tweaks applied.`n")
})

# ============================================================
#  TAB 3: CUSTOM SCRIPTS
# ============================================================
$customs = Get-RemoteJson "config/custom.json"
if ($customs) {
    foreach ($item in $customs) {
        $btn = New-Object System.Windows.Controls.Button
        $btn.Content = $item.name
        $btn.Tag = $item.script
        $btn.Margin = "5"
        $btn.Padding = "10,6"
        $btn.HorizontalAlignment = "Left"
        $btn.Add_Click({
            param($sender, $e)
            $LogBox.AppendText("Running: $($sender.Content)`n")
            Invoke-RemoteScript "scripts/$($sender.Tag)"
        }.GetNewClosure())
        $CustomPanel.Children.Add($btn) | Out-Null
    }
} else {
    $LogBox.AppendText("WARNING: Could not load custom.json from GitHub.`n")
}

# ---- Show the window ----
$window.ShowDialog() | Out-Null
