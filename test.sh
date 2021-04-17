#!/bin/bash
set -ueo pipefail
#set -x

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$REPO_DIR/src"

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/themes"
else
  DEST_DIR="$HOME/.themes"
fi

THEME_NAME=Orchis
COLOR_VARIANTS=('' '-light' '-dark')

SASSC_OPT=('-M' '-t' 'expanded')

if [[ "$(command -v gnome-shell)" ]]; then
  SHELL_VERSION="$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f -2)"
  if [[ "${SHELL_VERSION:-}" == '40.0' ]]; then
    GS_VERSION="new"
  else
    GS_VERSION="old"
  fi
  else
    echo "'gnome-shell' not found, using styles for last gnome-shell version available."
    GS_VERSION="new"
fi

usage() {
  cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
  -n, --name NAME         Specify theme name (Default: $THEME_NAME)
  -c, --color VARIANT...  Specify color variant(s) [standard|light|dark] (Default: All variants)s)
  -h, --help              Show help

INSTALLATION EXAMPLES:
Install all theme variants into ~/.themes
  $0 --dest ~/.themes
Install standard theme variant only
  $0 --color standard
Install specific theme variants with different name into ~/.themes
  $0 --dest ~/.themes --name MyTheme --color dark
EOF
}

install() {
  local dest="$1"
  local name="$2"
  local color="$3"

  [[ "$color" == '-dark' ]] && local ELSE_DARK="$color"
  [[ "$color" == '-light' ]] && local ELSE_LIGHT="$color"

  local THEME_DIR="$dest/$name$color"

  [[ -d "$THEME_DIR" ]] && rm -rf "${THEME_DIR:?}"

  echo "Installing '${THEME_DIR}'..."

  mkdir -p                                                                      "$THEME_DIR"
  cp -r "$REPO_DIR/COPYING"                                                     "$THEME_DIR"

  echo "[Desktop Entry]" >>                                                     "${THEME_DIR}/index.theme"
  echo "Type=X-GNOME-Metatheme" >>                                              "${THEME_DIR}/index.theme"
  echo "Name=$name$color" >>                                                    "${THEME_DIR}/index.theme"
  echo "Comment=An Materia Gtk+ theme based on Elegant Design" >>               "${THEME_DIR}/index.theme"
  echo "Encoding=UTF-8" >>                                                      "${THEME_DIR}/index.theme"
  echo "" >>                                                                    "${THEME_DIR}/index.theme"
  echo "[X-GNOME-Metatheme]" >>                                                 "${THEME_DIR}/index.theme"
  echo "GtkTheme=$name$color" >>                                                "${THEME_DIR}/index.theme"
  echo "MetacityTheme=$name$color" >>                                           "${THEME_DIR}/index.theme"
  echo "IconTheme=Tela-circle${ELSE_DARK:-}" >>                                 "${THEME_DIR}/index.theme"
  echo "CursorTheme=Vimix${ELSE_DARK:-}" >>                                     "${THEME_DIR}/index.theme"
  echo "ButtonLayout=close,minimize,maximize:menu" >>                           "${THEME_DIR}/index.theme"

  mkdir -p                                                                                "${THEME_DIR}/gnome-shell"
  cp -r "${SRC_DIR}/gnome-shell/"{extensions,message-indicator-symbolic.svg,pad-osd.css}  "${THEME_DIR}/gnome-shell"

  if [[ "${GS_VERSION:-}" == 'new' ]]; then
    cp -r "${SRC_DIR}/gnome-shell/shell-40-0/gnome-shell${ELSE_DARK:-}.css"     "${THEME_DIR}/gnome-shell/gnome-shell.css"
  else
    cp -r "${SRC_DIR}/gnome-shell/shell-3-28/gnome-shell${ELSE_DARK:-}.css"     "${THEME_DIR}/gnome-shell/gnome-shell.css"
  fi

  cp -r "${SRC_DIR}/gnome-shell/common-assets"                                   "${THEME_DIR}/gnome-shell/assets"
  cp -r "${SRC_DIR}/gnome-shell/assets${ELSE_DARK:-}/"*.svg                      "${THEME_DIR}/gnome-shell/assets"
  cp -r "${SRC_DIR}/gnome-shell/theme/checkbox${ELSE_DARK:-}.svg"                "${THEME_DIR}/gnome-shell/assets/checkbox.svg"
  cp -r "${SRC_DIR}/gnome-shell/theme/more-results${ELSE_DARK:-}.svg"            "${THEME_DIR}/gnome-shell/assets/more-results.svg"
  cp -r "${SRC_DIR}/gnome-shell/theme/toggle-on${ELSE_DARK:-}.svg"               "${THEME_DIR}/gnome-shell/assets/toggle-on.svg"

  cd "${THEME_DIR}/gnome-shell"
  ln -s assets/no-events.svg no-events.svg
  ln -s assets/process-working.svg process-working.svg
  ln -s assets/no-notifications.svg no-notifications.svg

  mkdir -p                                                                       "$THEME_DIR/gtk-2.0"
  cp -r "$SRC_DIR/gtk-2.0/common/"{apps.rc,hacks.rc,main.rc}                     "$THEME_DIR/gtk-2.0"
  cp -r "$SRC_DIR/gtk-2.0/assets-folder/assets${ELSE_DARK:-}"                    "$THEME_DIR/gtk-2.0/assets"
  cp -r "$SRC_DIR/gtk-2.0/gtkrc${ELSE_DARK:-}"                                   "$THEME_DIR/gtk-2.0/gtkrc"

  mkdir -p                                                                       "$THEME_DIR/gtk-3.0"
  cp -r "$SRC_DIR/gtk/assets"                                                    "$THEME_DIR/gtk-3.0/assets"
  cp -r "$SRC_DIR/gtk/scalable"                                                  "$THEME_DIR/gtk-3.0/assets"
  cp -r "$SRC_DIR/gtk/3.0/gtk$color.css"                                         "$THEME_DIR/gtk-3.0/gtk.css"
  [[ "$color" != '-dark' ]] && \
  cp -r "$SRC_DIR/gtk/3.0/gtk-dark.css"                                          "$THEME_DIR/gtk-3.0/gtk-dark.css"

  mkdir -p                                                                       "$THEME_DIR/gtk-4.0"
  cp -r "$SRC_DIR/gtk/assets"                                                    "$THEME_DIR/gtk-4.0/assets"
  cp -r "$SRC_DIR/gtk/scalable"                                                  "$THEME_DIR/gtk-4.0/assets"
  cp -r "$SRC_DIR/gtk/4.0/gtk$color.css"                                         "$THEME_DIR/gtk-4.0/gtk.css"
  [[ "$color" != '-dark' ]] && \
  cp -r "$SRC_DIR/gtk/4.0/gtk-dark.css"                                          "$THEME_DIR/gtk-4.0/gtk-dark.css"

#  mkdir -p                                                                       "${THEME_DIR}/xfwm4"
#  cp -r "${SRC_DIR}/xfwm4/assets${ELSE_LIGHT:-}/"*.png                           "${THEME_DIR}/xfwm4"
#  cp -r "${SRC_DIR}/xfwm4/themerc${ELSE_LIGHT:-}"                                "${THEME_DIR}/xfwm4/themerc"

#  mkdir -p                                                                       "$THEME_DIR/plank"
#  cp -r "$SRC_DIR/plank/dock.theme"                                              "$THEME_DIR/plank"
}

colors=()

while [[ "$#" -gt 0 ]]; do
  case "${1:-}" in
    -d|--dest)
      dest="$2"
      mkdir -p "$dest"
      shift 2
      ;;
    -n|--name)
      _name="$2"
      shift 2
      ;;
    -c|--color)
      shift
      for variant in "$@"; do
        case "$variant" in
          standard)
            colors+=("${COLOR_VARIANTS[0]}")
            shift
            ;;
          light)
            colors+=("${COLOR_VARIANTS[1]}")
            shift
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[2]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized color variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '${1:-}'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${#colors[@]}" -eq 0 ]] ; then
  colors=("${COLOR_VARIANTS[@]}")
fi

echo
echo "== Generating the CSS..."
echo
for color in "${colors[@]}"; do
  sassc "${SASSC_OPT[@]}" "src/gtk/3.0/gtk$color."{scss,css}
  sassc "${SASSC_OPT[@]}" "src/gtk/4.0/gtk$color."{scss,css}
done

for color in '' '-dark'; do
  sassc "${SASSC_OPT[@]}" "src/gnome-shell/shell-3-28/gnome-shell$color."{scss,css}
  sassc "${SASSC_OPT[@]}" "src/gnome-shell/shell-40-0/gnome-shell$color."{scss,css}
done

for color in "${colors[@]}"; do
  install "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$color"
done

echo
echo "Done."
