# ============================================================
#  MyWinKit - All-in-One Windows Toolkit
#  Launch: irm https://raw.githubusercontent.com/YOUR_USERNAME/MyWinKit/main/launcher.ps1 | iex
# ============================================================

# ---- Config: where the rest of the files live on GitHub ----
$global:RepoBase = "https://raw.githubusercontent.com/sanjulaAI/MyWinKit/main"

# ---- Auto-elevate to Admin ----
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Re-launching as Administrator..." -ForegroundColor Yellow
    $cmd = "irm $global:RepoBase/launcher.ps1 | iex"
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$cmd`""
    exit
}

# ---- Load required assemblies for WPF GUI ----
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# ---- Helper: download and run a remote script in memory ----
function Invoke-RemoteScript {
    param([string]$Path)
    try {
        $code = Invoke-RestMethod -Uri "$global:RepoBase/$Path" -UseBasicParsing
        Invoke-Expression $code
    } catch {
        [System.Windows.MessageBox]::Show("Failed to load: $Path`n$($_.Exception.Message)", "Error", "OK", "Error")
    }
}

# ---- Helper: fetch JSON config (app list, tweak list) ----
function Get-RemoteJson {
    param([string]$Path)
    try {
        return Invoke-RestMethod -Uri "$global:RepoBase/$Path" -UseBasicParsing
    } catch {
        return $null
    }
}

# ---- Load the XAML GUI definition ----
$xamlText = Invoke-RestMethod -Uri "$global:RepoBase/gui.xaml" -UseBasicParsing
$xaml = [xml]$xamlText
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# ---- Wire up named controls ----
$xaml.SelectNodes("//*[@Name]") | ForEach-Object {
    Set-Variable -Name $_.Name -Value $window.FindName($_.Name) -Scope Script
}

# ============================================================
#  TAB 1: INSTALL APPS  (winget)
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
#  TAB 2: TWEAKS & DEBLOAT
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
#  TAB 3: CUSTOM SCRIPTS  (your own stuff)
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
        })
        $CustomPanel.Children.Add($btn) | Out-Null
    }
}

# ============================================================
#  Show the window
# ============================================================
$window.ShowDialog() | Out-Null
