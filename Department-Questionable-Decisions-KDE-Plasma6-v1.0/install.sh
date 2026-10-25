#!/usr/bin/env bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
EXTRA="$DATA/department-questionable-decisions-extras"
WALL_DIR="$DATA/wallpapers/DepartmentQuestionableDecisions/contents/images"
WALL="$WALL_DIR/main-office-3840x2160.png"
GOLD='\033[38;5;180m'; TEAL='\033[38;5;73m'; DIM='\033[2m'; RESET='\033[0m'
if [[ ! -t 1 || -n "${NO_COLOR:-}" ]]; then GOLD=''; TEAL=''; DIM=''; RESET=''; fi
line() { printf '%b\n' "${GOLD}────────────────────────────────────────────────────────────${RESET}"; }
ok() { printf '  %b✓%b  %s\n' "$TEAL" "$RESET" "$1"; }
note() { printf '  •  %s\n' "$1"; }
heading() { printf '\n%b%s%b\n' "$GOLD" "$1" "$RESET"; }
fail() { printf '  !  %s\n' "$1"; }
copy_dir() { mkdir -p "$(dirname "$2")"; cp -a "$1" "$2"; }
apply_wallpaper() {
  local qdbus='' candidate url script
  for candidate in qdbus6 qdbus-qt6 qdbus; do
    if command -v "$candidate" >/dev/null 2>&1; then qdbus="$candidate"; break; fi
  done
  [[ -n "$qdbus" ]] || return 1
  url="$(python3 - "$WALL" <<'PYURL'
from pathlib import Path
import sys
print(Path(sys.argv[1]).resolve().as_uri())
PYURL
)"
  script="var all=desktops(); for (var i=0;i<all.length;i++){var d=all[i];d.wallpaperPlugin='org.kde.image';d.currentConfigGroup=['Wallpaper','org.kde.image','General'];d.writeConfig('Image',$(printf '%s' "$url" | python3 -c 'import json,sys;print(json.dumps(sys.stdin.read()))'));d.writeConfig('FillMode',2);}"
  "$qdbus" org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$script" >/dev/null 2>&1
}
line
printf '%b  THE DEPARTMENT OF QUESTIONABLE DECISIONS%b\n' "$GOLD" "$RESET"
printf '  Internal Atmosphere Update  |  v1.0  |  Plasma 6\n'
printf '  Your questionable decision has been approved.\n'
line
heading 'INSTALLING THE DEPARTMENT'
for required in \
  'share/plasma/look-and-feel/org.edgecase.questionabledecisions' \
  'share/plasma/desktoptheme/DepartmentQuestionableDecisions' \
  'share/icons/DepartmentQuestionableDecisions' \
  'share/wallpapers/DepartmentQuestionableDecisions/contents/images/main-office-3840x2160.png' \
  'share/wallpapers/DepartmentQuestionableDecisions/contents/images/main-office-1920x1080.png'; do
  [[ -e "$BASE/$required" ]] || { fail "Missing package file: $required"; exit 1; }
done
for scene in main-office archives-room street-view; do
  for resolution in 1920x1080 3840x2160; do
    required="$BASE/share/wallpapers/DepartmentQuestionableDecisions/contents/images/${scene}-${resolution}.png"
    [[ -f "$required" ]] || { fail "Missing wallpaper: $required"; exit 1; }
  done
done
mkdir -p "$DATA/plasma/look-and-feel" "$DATA/plasma/desktoptheme" "$DATA/color-schemes" "$DATA/wallpapers" "$DATA/konsole" "$DATA/icons" "$DATA/aurorae/themes" "$EXTRA"
copy_dir "$BASE/share/plasma/look-and-feel/org.edgecase.questionabledecisions" "$DATA/plasma/look-and-feel/"
copy_dir "$BASE/share/plasma/desktoptheme/DepartmentQuestionableDecisions" "$DATA/plasma/desktoptheme/"
cp "$BASE/share/color-schemes/DepartmentQuestionableDecisions.colors" "$DATA/color-schemes/"
copy_dir "$BASE/share/wallpapers/DepartmentQuestionableDecisions" "$DATA/wallpapers/"
copy_dir "$BASE/share/aurorae/themes/DepartmentQuestionableDecisions" "$DATA/aurorae/themes/"
ok 'Plasma colors, panels and window decorations installed'
ICON_DEST="$DATA/icons/DepartmentQuestionableDecisions"
if [[ -L "$ICON_DEST" ]]; then fail "Refusing to replace symlink $ICON_DEST"; exit 1; fi
[[ ! -d "$ICON_DEST" ]] || rm -rf -- "$ICON_DEST"
copy_dir "$BASE/share/icons/DepartmentQuestionableDecisions" "$DATA/icons/"
ok 'Department seal and icon theme installed'
cp "$BASE/extras/konsole/DepartmentQuestionableDecisions.colorscheme" "$DATA/konsole/"
cp "$BASE/extras/konsole/DepartmentQuestionableDecisions.profile" "$DATA/konsole/"
ok 'Konsole color scheme and optional profile installed'
for item in splash lockscreen konsole; do
  if [[ -L "$EXTRA/$item" ]]; then fail "Refusing to replace symlink $EXTRA/$item"; exit 1; fi
  [[ ! -d "$EXTRA/$item" ]] || rm -rf -- "$EXTRA/$item"
  copy_dir "$BASE/extras/$item" "$EXTRA/"
done
ok 'Four wallpaper scenes installed in the KDE wallpaper package'
ok 'Splash/lock concept graphics installed'
heading 'APPLYING APPEARANCE'
if command -v plasma-apply-colorscheme >/dev/null 2>&1 && plasma-apply-colorscheme DepartmentQuestionableDecisions >/dev/null 2>&1; then
  ok 'Color scheme selected'
else fail 'Color scheme not activated automatically; select it in System Settings'; fi
if command -v plasma-apply-desktoptheme >/dev/null 2>&1 && plasma-apply-desktoptheme DepartmentQuestionableDecisions >/dev/null 2>&1; then
  ok 'Plasma style selected'
else fail 'Plasma style not activated automatically; select it in System Settings'; fi
if command -v kwriteconfig6 >/dev/null 2>&1; then
  kwriteconfig6 --file kdeglobals --group Icons --key Theme DepartmentQuestionableDecisions
  kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library org.kde.kwin.aurorae
  kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme __aurorae__svg__DepartmentQuestionableDecisions
  ok 'Icons and Aurorae decoration preferences written'
else fail 'kwriteconfig6 unavailable; select Icons and Window Decorations manually'; fi
if command -v kbuildsycoca6 >/dev/null 2>&1; then kbuildsycoca6 >/dev/null 2>&1 || true; fi
if apply_wallpaper || { command -v plasma-apply-wallpaperimage >/dev/null 2>&1 && plasma-apply-wallpaperimage "$WALL" >/dev/null 2>&1; }; then
  ok 'Main Office wallpaper applied to active desktops (4K image)'
else fail "Wallpaper could not be applied automatically; select $WALL manually in Desktop Wallpaper settings"; fi
heading 'AVAILABLE WALLPAPERS  •  MANUAL SELECTION'
note 'Main Office, Archives Room, Contingencies Lab, After Hours (new noir revision)' 
note 'Right-click desktop → Configure Desktop and Wallpaper → Add Image'
note 'All four scenes are installed; Main Office is selected automatically.'
note 'Browse to:'
printf '     %s\n' "$WALL_DIR/"
note 'Choose a *-3840x2160.png image for a 4K display.'
heading 'SPLASH & LOCK SCREEN  •  ASSETS INCLUDED'
note 'Splash is a selectable Plasma QML theme. The lock screen uses a departmental wallpaper with KDE authentication.'
note 'Splash artwork:  '"$EXTRA/splash/"
note 'Lock mockup:      '"$EXTRA/lockscreen/"
note 'Startup splash is selected automatically; lock uses the wallpaper behind KDE login.'
heading 'KONSOLE  •  PROFILE INSTALLED'
note 'A Department profile will be selected as the default for new windows.'
note 'Default profile: Department of Questionable Decisions (new windows only)'
note 'Optional profile: '"$DATA/konsole/DepartmentQuestionableDecisions.profile"
line
printf '%b  COMPLETE%b  Desktop layout, panels and pinned apps were preserved.\n' "$TEAL" "$RESET"
printf '  No sudo needed. No Plasma or KWin restart performed.\n'
line

heading 'ACTIVATING DEPARTMENT COMPONENTS'
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP="$CONFIG_DIR/department-questionable-decisions-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"
for config in ksplashrc kscreenlockerrc konsolerc; do
  [[ ! -f "$CONFIG_DIR/$config" ]] || cp -p "$CONFIG_DIR/$config" "$BACKUP/$config"
done
ok "Previous splash, lock, and Konsole preferences backed up: $BACKUP"
if command -v kwriteconfig6 >/dev/null 2>&1; then
  kwriteconfig6 --file ksplashrc --group KSplash --key Theme org.edgecase.questionabledecisions
  kwriteconfig6 --file ksplashrc --group KSplash --key Engine KSplashQML
  ok 'Plasma startup splash selected (visible next login)'
  LOCK="$WALL_DIR/main-office-3840x2160.png"
  LOCK_URL="$(python3 - "$LOCK" <<'PYLOCK'
from pathlib import Path
import sys
print(Path(sys.argv[1]).resolve().as_uri())
PYLOCK
)"
  kwriteconfig6 --file kscreenlockerrc --group Greeter --key WallpaperPlugin org.kde.image
  kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "$LOCK_URL"
  ok 'Lock-screen wallpaper configured (KDE authentication unchanged)'
  kwriteconfig6 --file konsolerc --group 'Desktop Entry' --key DefaultProfile DepartmentQuestionableDecisions.profile
  ok 'Department Konsole profile set as default for new windows'
else
  fail 'kwriteconfig6 not found; select splash, lock wallpaper, and Konsole profile manually'
fi
heading 'TEST THE NEW COMPONENTS'
note 'Splash: System Settings → Colors & Themes → Splash Screen → The Department of Questionable Decisions'
note 'Splash preview installed: contents/previews/splash.png (v1.0 artwork)'
note 'Use Preview/Test, if offered, or log out and back in to see the actual splash.'
note 'Lock: Press Meta+L; unlock normally with your existing KDE password screen.'
note 'Konsole: Open a NEW Konsole window; current tabs retain their old profile.'
note 'Rollback preferences: backup saved at:'
printf '    %s\n' "$BACKUP"
note 'Nothing changed SDDM, user passwords, panels, or widgets.'
heading 'UNINSTALL / ROLLBACK'
note 'To remove the theme later, run ./uninstall.sh from this extracted folder.'
note 'Uninstall switches to Breeze, removes Department packages, and keeps your wallpapers, layout, and backups.'
line
