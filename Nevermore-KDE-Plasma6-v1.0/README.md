# Nevermore

### Poe meets modern Linux.

**Nevermore** is a Gothic-inspired global theme for **KDE Plasma 6**. It combines raven-black and ink-gray surfaces, aged-parchment icons, restrained wine-red accents, and moody Victorian scenery—a desktop that feels like a library after midnight without sacrificing everyday usability.

> *Quoth the desktop: Nevermore.*

## Screenshots

_None yet, check back_

## Features

- **Plasma 6 global theme** with coordinated dark colors and panel styling.
- **Aurorae window decorations** with charcoal titlebars and a fine wine-red accent on active windows.
- **Custom folder icons**, including dedicated symbols for common folders, plus a Victorian filing-cabinet icon for Dolphin.
- **Breeze icon inheritance** for applications and settings without Nevermore-specific icons.
- **Three included wallpapers:** Gothic Library, Attic Study, and Haunted Chamber, each supplied at 1920 × 1080 and 3840 × 2160.
- **Konsole color scheme and profile**, Plasma splash assets, and a wallpaper-backed KDE lock screen.
- **User-level install and uninstall scripts**; no `sudo` required.

## Requirements

- KDE **Plasma 6** on Linux (developed and tested through iterations on **CachyOS / Arch Linux**).
- A running Plasma desktop session to apply the wallpaper automatically.
- Standard KDE utilities used by the installer, including `kwriteconfig6`; wallpaper application uses a Qt D-Bus utility when available.

Other distributions may work but have not been comprehensively tested.

## Installation

1. Download the latest release ZIP from the repository's **Releases** page.
2. Extract it.
3. Open a terminal inside the extracted `Nevermore-1.0` directory and run:

```bash
chmod +x install.sh uninstall.sh
./install.sh
```

**Do not run the installer with `sudo`.** It installs theme files in your user account under `~/.local/share/` and adjusts your KDE user preferences.

The installer attempts to select the theme components and apply **Gothic Library** as the desktop wallpaper. If any component does not refresh immediately, select it manually in **System Settings → Colors & Themes**. You may need to reselect the Nevermore window decoration or log out and back in for KWin to reflect an update.

The installer does **not** replace your desktop layout, widgets, pinned applications, SDDM login screen, or authentication system.

## Wallpapers

Installed wallpaper packages are kept in one location:

```text
~/.local/share/wallpapers/
├── NevermoreGothicLibrary/
├── NevermoreAtticStudy/
└── NevermoreHauntedChamber/
```

Each wallpaper package contains 1080p and 4K images. **Gothic Library** is the installer-selected default; the other scenes can be chosen in **Right-click desktop → Configure Desktop and Wallpaper**.

## Konsole, splash screen, and lock screen

- **Konsole:** Open a **new** Konsole window to see the selected profile; already-open tabs may retain their previous colors.
- **Splash:** Check **System Settings → Colors & Themes → Splash Screen** or sign out and back in.
- **Lock screen:** Press **Meta+L**. Nevermore only changes the background; KDE's existing secure authentication remains in charge.

## Uninstall

From the extracted release folder:

```bash
./uninstall.sh
```

The uninstaller is intended to remove Nevermore-owned theme components and return applicable styling to Breeze. **It is not a complete restoration of every preference you had before installation.** Keep any configuration backups created by the installer until you are satisfied with the result. Wallpaper files may be retained to avoid breaking a background currently selected by KDE.

## Notes

- Nevermore is a **Plasma 6 theme**, not a complete Qt/GTK application-style replacement. Applications may retain their own internal styling.
- A theme can install correctly yet require manual re-selection because of KDE/KWin caching.
- If a dock or taskbar retains an old Dolphin icon, try reopening Dolphin or unpinning and repinning it.

## License

Nevermore is licensed under [GPL-3.0-or-later](../LICENSE).

## Version

**1.0** — Initial completed release.

---

*Nevermore: a little darkness, a little parchment, and one very persistent raven.*
