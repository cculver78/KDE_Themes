#!/usr/bin/env bash
set -euo pipefail
DEST="$HOME/.local/share"
read -r -p 'Remove Nevermore assets and return selected colors/style/icons to Breeze? [y/N] ' answer
[[ "$answer" =~ ^[Yy]$ ]] || exit 0
if command -v kreadconfig6 >/dev/null; then
  check="$(kreadconfig6 --file kdeglobals --group General --key ColorScheme 2>/dev/null || true)"
  [[ "$check" != Nevermore ]] || { command -v plasma-apply-colorscheme >/dev/null && plasma-apply-colorscheme BreezeDark || true; }
  check="$(kreadconfig6 --file plasmarc --group Theme --key name 2>/dev/null || true)"
  [[ "$check" != Nevermore ]] || { command -v plasma-apply-desktoptheme >/dev/null && plasma-apply-desktoptheme default || true; }
  if command -v kwriteconfig6 >/dev/null; then
    check="$(kreadconfig6 --file kdeglobals --group Icons --key Theme 2>/dev/null || true)"
    [[ "$check" != NevermoreIcons ]] || kwriteconfig6 --file kdeglobals --group Icons --key Theme breeze-dark
    check="$(kreadconfig6 --file ksplashrc --group KSplash --key Theme 2>/dev/null || true)"
    [[ "$check" != org.edgecase.nevermore ]] || kwriteconfig6 --file ksplashrc --group KSplash --key Theme org.kde.breeze.desktop
    check="$(kreadconfig6 --file konsolerc --group 'Desktop Entry' --key DefaultProfile 2>/dev/null || true)"
    [[ "$check" != Nevermore.profile ]] || kwriteconfig6 --file konsolerc --group 'Desktop Entry' --key DefaultProfile builtin.profile
  fi
fi
for path in "$DEST/plasma/look-and-feel/org.edgecase.nevermore" "$DEST/plasma/desktoptheme/Nevermore" "$DEST/icons/NevermoreIcons" "$DEST/aurorae/themes/NevermoreAurorae05"; do
  [[ ! -L "$path" ]] && rm -rf "$path" || echo "Skipping symlink: $path"
done
if command -v kreadconfig6 >/dev/null && command -v kwriteconfig6 >/dev/null; then
  d="$(kreadconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme 2>/dev/null || true)"
  if [[ "$d" == '__aurorae__svg__NevermoreAurorae05' ]]; then
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library org.kde.kwin.breeze
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme Breeze
  fi
fi
rm -f "$DEST/color-schemes/Nevermore.colors" "$DEST/konsole/Nevermore.colorscheme" "$DEST/konsole/Nevermore.profile"
echo 'Nevermore removed. Wallpapers retained to protect configured lock-screen background. Manual restoration of prior preferences may be needed.'
