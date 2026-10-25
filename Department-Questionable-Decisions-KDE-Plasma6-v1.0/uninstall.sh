#!/usr/bin/env bash
set -euo pipefail
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
GOLD='\033[38;5;180m'; TEAL='\033[38;5;73m'; RESET='\033[0m'
if [[ ! -t 1 || -n "${NO_COLOR:-}" ]]; then GOLD=''; TEAL=''; RESET=''; fi
heading(){ printf '\n%b%s%b\n' "$GOLD" "$1" "$RESET"; }
ok(){ printf '  %b✓%b %s\n' "$TEAL" "$RESET" "$1"; }
warn(){ printf '  ! %s\n' "$1"; }
is_ours(){ [[ "$1" == DepartmentQuestionableDecisions || "$1" == org.edgecase.questionabledecisions || "$1" == __aurorae__svg__DepartmentQuestionableDecisions ]]; }
read_kde(){
  if command -v kreadconfig6 >/dev/null 2>&1; then kreadconfig6 --file "$1" --group "$2" --key "$3" 2>/dev/null || true; fi
}
remove_owned(){
  local path="$1"
  if [[ -L "$path" ]]; then warn "Skipping symlink: $path"; return; fi
  if [[ -d "$path" ]]; then rm -rf -- "$path"; ok "Removed ${path#"$DATA"/}";
  elif [[ -f "$path" ]]; then rm -f -- "$path"; ok "Removed ${path#"$DATA"/}"; fi
}
heading 'THE DEPARTMENT OF QUESTIONABLE DECISIONS | UNINSTALL v1.0'
printf '  This will remove only Department-owned theme files.\n'
printf '  Your desktop wallpaper, panels, pinned apps, and backups will be preserved.\n'
if [[ -t 0 && "${1:-}" != '--yes' ]]; then
  read -r -p '  Proceed? [y/N] ' answer
  [[ "$answer" =~ ^[Yy]([Ee][Ss])?$ ]] || { echo '  Cancelled.'; exit 0; }
elif [[ ! -t 0 && "${1:-}" != '--yes' ]]; then
  echo 'Run with --yes for non-interactive uninstall.' >&2; exit 2
fi
heading 'RESETTING ACTIVE APPEARANCE'
if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
  if [[ "$(read_kde kdeglobals General ColorScheme)" == DepartmentQuestionableDecisions ]]; then
    plasma-apply-colorscheme BreezeDark >/dev/null 2>&1 && ok 'Colors switched to Breeze Dark' || warn 'Choose Breeze Dark manually in System Settings'
  fi
fi
if command -v plasma-apply-desktoptheme >/dev/null 2>&1; then
  current="$(read_kde plasmarc Theme name)"
  if [[ "$current" == DepartmentQuestionableDecisions ]]; then
    plasma-apply-desktoptheme default >/dev/null 2>&1 && ok 'Plasma style switched to Breeze' || warn 'Choose Breeze manually in System Settings'
  fi
fi
if command -v kwriteconfig6 >/dev/null 2>&1; then
  if [[ "$(read_kde kdeglobals Icons Theme)" == DepartmentQuestionableDecisions ]]; then
    kwriteconfig6 --file kdeglobals --group Icons --key Theme breeze-dark; ok 'Icons reset to Breeze Dark'
  fi
  if [[ "$(read_kde kwinrc org.kde.kdecoration2 theme)" == __aurorae__svg__DepartmentQuestionableDecisions ]]; then
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library org.kde.breeze
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme Breeze; ok 'Window decoration reset to Breeze'
  fi
  if [[ "$(read_kde ksplashrc KSplash Theme)" == org.edgecase.questionabledecisions ]]; then
    kwriteconfig6 --file ksplashrc --group KSplash --key Theme org.kde.breeze.desktop; ok 'Splash reset to Breeze'
  fi
  if [[ "$(read_kde konsolerc 'Desktop Entry' DefaultProfile)" == DepartmentQuestionableDecisions.profile ]]; then
    kwriteconfig6 --file konsolerc --group 'Desktop Entry' --key DefaultProfile --delete; ok 'Konsole default preference reset'
  fi
fi
heading 'REMOVING DEPARTMENT COMPONENTS'
remove_owned "$DATA/plasma/look-and-feel/org.edgecase.questionabledecisions"
remove_owned "$DATA/plasma/desktoptheme/DepartmentQuestionableDecisions"
remove_owned "$DATA/color-schemes/DepartmentQuestionableDecisions.colors"
remove_owned "$DATA/icons/DepartmentQuestionableDecisions"
remove_owned "$DATA/aurorae/themes/DepartmentQuestionableDecisions"
remove_owned "$DATA/konsole/DepartmentQuestionableDecisions.profile"
remove_owned "$DATA/konsole/DepartmentQuestionableDecisions.colorscheme"
warn 'Department wallpapers are kept to avoid broken desktop/lock-screen backgrounds.'
warn "Optional artwork can be deleted later: $DATA/wallpapers/DepartmentQuestionableDecisions"
warn "Optional extras can be deleted later: $DATA/department-questionable-decisions-extras"
warn "Your timestamped backups in $CONFIG are preserved."
if command -v kbuildsycoca6 >/dev/null 2>&1; then kbuildsycoca6 >/dev/null 2>&1 || true; fi
heading 'COMPLETE'
printf '  Log out and back in if icons or decorations remain cached.\n'
printf '  Your lock-screen wallpaper was not changed or removed.\n'
