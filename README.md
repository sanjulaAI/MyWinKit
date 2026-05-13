# MyWinKit

A WinUtil-style all-in-one Windows toolkit. Run from any PC with one line of PowerShell — no downloads, no installs.

## How to use (after setup)

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/YOUR_USERNAME/MyWinKit/main/launcher.ps1 | iex
```

It auto-elevates to Admin and opens the GUI.

---

## One-Time Setup

### 1. Create the GitHub repo

1. Go to https://github.com/new
2. Name it **MyWinKit** (or whatever — just match it in the launch command)
3. Make it **Public** (required for `raw.githubusercontent.com` to work without a token)
4. Click **Create repository**

### 2. Upload these files

Either drag-and-drop the whole folder structure into GitHub's web uploader, or use git:

```powershell
cd C:\path\to\MyWinKit
git init
git add .
git commit -m "initial"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/MyWinKit.git
git push -u origin main
```

### 3. Edit `launcher.ps1`

Open `launcher.ps1` and change line 7:

```powershell
$global:RepoBase = "https://raw.githubusercontent.com/YOUR_USERNAME/MyWinKit/main"
```

Replace `YOUR_USERNAME` with your actual GitHub username. Commit and push.

### 4. Test it

On any Windows PC, open PowerShell and run the command from the top of this README.

---

## File structure

```
MyWinKit/
├── launcher.ps1              # Main entry point (this is what irm | iex runs)
├── gui.xaml                  # GUI layout
├── config/
│   ├── apps.json             # List of installable apps (winget IDs)
│   ├── tweaks.json           # List of tweaks shown on the Tweaks tab
│   └── custom.json           # List of buttons on the "My Scripts" tab
└── scripts/
    ├── tweak-*.ps1           # Individual tweak scripts
    └── custom-*.ps1          # Your own custom scripts
```

## Adding your own stuff

### Add an app
Edit `config/apps.json`. Find the winget ID with:
```powershell
winget search "app name"
```
Add an entry under the right category.

### Add a tweak
1. Create a new `.ps1` file in `scripts/` (e.g. `tweak-my-thing.ps1`)
2. Add an entry to `config/tweaks.json`:
```json
{ "name": "My Tweak", "description": "What it does", "script": "tweak-my-thing.ps1" }
```

### Add a custom script
1. Drop your `.ps1` file in `scripts/`
2. Add an entry to `config/custom.json`:
```json
{ "name": "Button Label", "script": "your-script.ps1" }
```

Commit + push. Next launch picks it up automatically — no reinstall needed.

---

## Optional: short custom URL

Instead of the long `raw.githubusercontent.com` URL, you can set up a redirect like Chris Titus has (`christitus.com/win`):

- **Free option:** Cloudflare Workers with a redirect script pointing to your raw GitHub URL.
- **Paid option:** Buy a domain ($1–10/yr) and use Cloudflare DNS + Workers.

Once set up, your command becomes something clean like:
```powershell
irm yoursite.com/kit | iex
```

---

## Notes / Troubleshooting

- The repo **must be public**. Private repos need an auth token, which defeats the one-liner.
- If `irm` returns 404, double-check the URL — branch name is `main` (not `master`) on new GitHub repos.
- The launcher auto-elevates to Administrator. If UAC is blocked, the GUI won't open.
- All scripts run **in memory only** — nothing is written to disk except where a script explicitly does so.
- Windows Defender may flag `iex` with remote content. If your environment blocks it, set: `Set-ExecutionPolicy -Scope Process Bypass` before running.
