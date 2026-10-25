#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
ID=org.edgecase.nevermore
SCHEME=Nevermore
ICONS=NevermoreIcons
DECOR=NevermoreAurorae05
WALL="$DATA/wallpapers/NevermoreGothicLibrary/contents/images/3840x2160.png"
WINE=$'\033[38;5;167m'; GOLD=$'\033[38;5;180m'; GREEN=$'\033[38;5;114m'; RESET=$'\033[0m'
if [[ ! -t 1 || -n "${NO_COLOR:-}" ]]; then WINE=''; GOLD=''; GREEN=''; RESET=''; fi
rule(){ printf '%b────────────────────────────────────────────────────────────────%b\n' "$WINE" "$RESET"; }
head(){ printf '\n%b%s%b\n' "$GOLD" "$1" "$RESET"; }
ok(){ printf '  %b✓%b %s\n' "$GREEN" "$RESET" "$1"; }
warn(){ printf '  ! %s\n' "$1"; }
note(){ printf '  • %s\n' "$1"; }
needs=("share/color-schemes/Nevermore.colors" "share/plasma/look-and-feel/$ID/metadata.json" "share/plasma/desktoptheme/Nevermore/metadata.json" "share/icons/$ICONS/index.theme" "share/aurorae/themes/$DECOR/metadata.desktop" "share/aurorae/themes/$DECOR/decoration.svg" "share/wallpapers/NevermoreGothicLibrary/contents/images/3840x2160.png" "extras/konsole/Nevermore.profile" "share/wallpapers/NevermoreAtticStudy/contents/images/3840x2160.png" "share/wallpapers/NevermoreHauntedChamber/contents/images/3840x2160.png")
for f in "${needs[@]}"; do [[ -f "$ROOT/$f" ]] || { printf 'ERROR: Missing %s\n' "$f" >&2; exit 1; }; done
command -v python3 >/dev/null || { echo 'ERROR: python3 required for safe wallpaper URL creation'; exit 1; }
UPGRADING=0
[[ -d "$DATA/icons/$ICONS" ]] && UPGRADING=1
folders=("plasma/look-and-feel/$ID" "plasma/desktoptheme/Nevermore" "icons/$ICONS" "wallpapers/NevermoreGothicLibrary" "wallpapers/NevermoreAtticStudy" "wallpapers/NevermoreHauntedChamber" "aurorae/themes/$DECOR")
for item in "${folders[@]}"; do
 path="$DATA/$item"
 [[ ! -L "$path" ]] || { echo "ERROR: Refusing symlink: $path" >&2; exit 1; }
 [[ ! -e "$path" || -d "$path" ]] || { echo "ERROR: Destination not a directory: $path" >&2; exit 1; }
done
rule
printf '%b  NEVERMORE%b  |  v1.0  |  KDE Plasma 6\n' "$GOLD" "$RESET"
printf '  Poe meets modern Linux. The library is open after midnight.\n'
rule
head '01  INSTALLING THE THEME'
mkdir -p "$DATA/color-schemes" "$DATA/konsole"
for item in "${folders[@]}"; do
 mkdir -p "$(dirname "$DATA/$item")"
 rm -rf -- "$DATA/$item"
 cp -a "$ROOT/share/$item" "$DATA/$item"
done
cp "$ROOT/share/color-schemes/Nevermore.colors" "$DATA/color-schemes/"
cp "$ROOT/extras/konsole/Nevermore.profile" "$ROOT/extras/konsole/Nevermore.colorscheme" "$DATA/konsole/"
ok 'Global Theme and startup splash installed'
for legacy in NevermoreAurorae NevermoreAurorae03 NevermoreAurorae04; do
  legacy_path="$DATA/aurorae/themes/$legacy"
  if [[ -L "$legacy_path" ]]; then
    warn "Legacy decoration is a symlink; leaving it alone: $legacy_path"
  elif [[ -d "$legacy_path" ]]; then
    rm -rf -- "$legacy_path"
  fi
done
ok 'Nevermore colors, panel style and Aurorae window decorations installed'
ok 'Nevermore folder and application icons installed, including Music and Dolphin'
ok 'Three KDE wallpapers installed: Gothic Library, Attic Study, Haunted Chamber (1080p and 4K)'
head '02  CLEANING UP OLD NEVERMORE ASSETS'
OLD_EXTRAS="$DATA/nevermore-extras/wallpapers"
if [[ -d "$OLD_EXTRAS" && ! -L "$OLD_EXTRAS" ]]; then
  for f in \
    Gothic-Library-1920x1080.png Gothic-Library-3840x2160.png Gothic-Library-original.jpeg \
    Attic-Study-1920x1080.png Attic-Study-3840x2160.png Attic-Study-original.jpeg \
    Haunted-Chamber-1920x1080.png Haunted-Chamber-3840x2160.png Haunted-Chamber-original.jpeg; do
    if [[ -f "$OLD_EXTRAS/$f" && ! -L "$OLD_EXTRAS/$f" ]]; then rm -- "$OLD_EXTRAS/$f"; fi
  done
  rmdir "$OLD_EXTRAS" 2>/dev/null || note 'Other files remain in legacy extras; preserved them.'
  rmdir "$DATA/nevermore-extras" 2>/dev/null || true
  ok 'Removed duplicated v0.7 alternate wallpaper copies (left any unrelated files)'
elif [[ -L "$OLD_EXTRAS" ]]; then
  warn 'Legacy wallpaper extras is a symlink; left untouched for safety'
fi
ok 'Konsole palette and profile installed'
head '03  SAVING YOUR CURRENT SETTINGS'
BACKUP="$CONFIG/nevermore-backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"
for cfg in kdeglobals plasmarc kwinrc ksplashrc kscreenlockerrc konsolerc; do
 [[ ! -f "$CONFIG/$cfg" ]] || cp -p "$CONFIG/$cfg" "$BACKUP/$cfg"
done
ok "Existing KDE configuration backups: $BACKUP"
head '04  APPLYING APPEARANCE'
if command -v plasma-apply-colorscheme >/dev/null && plasma-apply-colorscheme "$SCHEME" >/dev/null 2>&1; then ok 'Nevermore color scheme activated'; else warn 'Choose Nevermore under Settings → Colors & Themes → Colors'; fi
if command -v plasma-apply-desktoptheme >/dev/null && plasma-apply-desktoptheme Nevermore >/dev/null 2>&1; then ok 'Nevermore Plasma style activated'; else warn 'Choose Nevermore under Plasma Style'; fi
if command -v kwriteconfig6 >/dev/null; then
 kwriteconfig6 --file kdeglobals --group Icons --key Theme "$ICONS"
 ok 'Nevermore icon theme selected; close and reopen Dolphin to refresh cached icons'
 note 'If icons are unchanged, select Nevermore in System Settings → Colors & Themes → Icons'
 kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library org.kde.kwin.aurorae
 kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme "__aurorae__svg__$DECOR"
 ok 'Aurorae window decoration preference written'
 RELOAD=0
 for dbus in qdbus6 qdbus-qt6 qdbus; do
   if command -v "$dbus" >/dev/null 2>&1 && "$dbus" org.kde.KWin /KWin reconfigure >/dev/null 2>&1; then
     RELOAD=1
     break
   fi
 done
 if [[ "$RELOAD" == 1 ]]; then
   ok 'KWin decoration reconfiguration requested (verify visually)'
 else
   warn 'KWin decoration could not be reloaded automatically; reselect Nevermore under Window Decorations'
 fi
 kwriteconfig6 --file ksplashrc --group KSplash --key Theme "$ID"
 kwriteconfig6 --file ksplashrc --group KSplash --key Engine KSplashQML
 ok 'Nevermore startup splash selected (next login)'
 kwriteconfig6 --file konsolerc --group 'Desktop Entry' --key DefaultProfile Nevermore.profile
 ok 'Nevermore Konsole profile selected (new windows)'
 URL="$(python3 - "$WALL" <<'PY'
from pathlib import Path
import sys
print(Path(sys.argv[1]).resolve().as_uri())
PY
)"
 OLD_LOCK=""
 if command -v kreadconfig6 >/dev/null 2>&1; then
   OLD_LOCK="$(kreadconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image 2>/dev/null || true)"
 fi
 if [[ "$UPGRADING" == 0 || "$OLD_LOCK" == *NevermoreMidnight* ]]; then
   kwriteconfig6 --file kscreenlockerrc --group Greeter --key WallpaperPlugin org.kde.image
   kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "$URL"
   ok 'KDE lock-screen wallpaper set to Gothic Library (authentication unchanged)'
 else
   ok 'Existing lock-screen wallpaper preserved'
 fi
else
 warn 'kwriteconfig6 not available; choose icons, decoration, splash and profile manually'
fi
if command -v kbuildsycoca6 >/dev/null; then kbuildsycoca6 >/dev/null 2>&1 || true; fi
head '05  WALLPAPER'
note 'Applying Gothic Library to all active KDE Plasma desktops.'
URL="$(python3 - "$WALL" <<'PYURL'
from pathlib import Path
import sys
print(Path(sys.argv[1]).resolve().as_uri())
PYURL
)"
SCRIPT="$(python3 - "$URL" <<'PYSCRIPT'
import json,sys
u=json.dumps(sys.argv[1]); print("var ds=desktops();for(var i=0;i<ds.length;i++){var d=ds[i];d.wallpaperPlugin='org.kde.image';d.currentConfigGroup=['Wallpaper','org.kde.image','General'];d.writeConfig('Image',"+u+");d.writeConfig('FillMode',2);}")
PYSCRIPT
)"
APPLIED=0
for cmd in qdbus6 qdbus-qt6 qdbus; do
  if command -v "$cmd" >/dev/null 2>&1; then
    if "$cmd" org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$SCRIPT" >/dev/null 2>&1; then
      APPLIED=1
      break
    fi
  fi
done
if [[ "$APPLIED" == 0 ]] && command -v plasma-apply-wallpaperimage >/dev/null 2>&1; then
  if plasma-apply-wallpaperimage "$WALL" >/dev/null 2>&1; then APPLIED=1; fi
fi
if [[ "$APPLIED" == 1 ]]; then
  ok 'Gothic Library wallpaper applied to the active Plasma session'
else
  warn 'Could not set wallpaper in the active Plasma session (is Plasma running?)'
  note "Manually select Gothic Library from: $WALL"
fi
LEGACY_DEFAULT="$DATA/wallpapers/NevermoreMidnight"
if [[ -d "$LEGACY_DEFAULT" && ! -L "$LEGACY_DEFAULT" ]]; then
  if grep -l -F 'NevermoreMidnight' "$CONFIG/kscreenlockerrc" "$CONFIG/plasma-org.kde.plasma.desktop-appletsrc" 2>/dev/null | grep -q .; then
    warn 'Legacy NevermoreMidnight wallpaper still referenced; preserving it for safety'
  else
    rm -rf -- "$LEGACY_DEFAULT"
    ok 'Removed obsolete NevermoreMidnight wallpaper package'
  fi
fi
head '06  TEST THE VISIBLE COMPONENTS'
note 'Colors & Themes → Window Decorations → Nevermore (select manually if unchanged)'
note 'Colors & Themes → Icons → Nevermore (reopen Dolphin if folders remain blue)'
note 'Colors & Themes → Plasma Style → Nevermore'
note 'Colors & Themes → Splash Screen → Nevermore (test on next login)'
note 'Meta+L checks your real KDE lock screen; unlock normally'
note 'Open a NEW Konsole window to see the selected palette'
note 'Gothic Library is selected during every installation (including upgrades).'
note 'All wallpaper files are stored in KDE wallpaper packages under:'
printf '      %s\n' "$DATA/wallpapers/"
note 'Right-click desktop → Configure Desktop and Wallpaper; choose an installed Nevermore scene or use Add Image if it is not listed.'
note 'KDE wallpaper packages: NevermoreGothicLibrary, NevermoreAtticStudy, NevermoreHauntedChamber'
note 'Default installed wallpaper files: '
printf '      %s\n' "$DATA/wallpapers/NevermoreGothicLibrary/contents/images/"
head '07  INSTALLATION NOTES'
note "Config backup: $BACKUP"
note 'Your panels, widgets, pinned apps, passwords and SDDM were untouched.'
note 'If Aurorae appears stale/transparent, reselect Nevermore in Window Decorations and apply; relog if necessary.'
note 'Uninstall with ./uninstall.sh. Wallpapers and backups stay for lock-screen safety.'
rule
printf '%b  COMPLETE%b  |  Quoth the desktop: Nevermore.\n' "$GREEN" "$RESET"
rule
