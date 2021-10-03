
REPO_DIR="$(dirname "$(readlink -m "${0}")")"
SRC_DIR="$REPO_DIR/src"

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/themes"
else
  DEST_DIR="$HOME/.themes"
fi

SASSC_OPT="-M -t expanded"

THEME_NAME=Orchis
THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-grey')
THEME_COLORS=('default' 'purple' 'pink' 'red' 'orange' 'yellow' 'green' 'grey')
COLOR_VARIANTS=('' '-light' '-dark')
SIZE_VARIANTS=('' '-compact')

# Check command availability
function has_command() {
  command -v $1 > /dev/null
}

if [[ "$(command -v gnome-shell)" ]]; then
  SHELL_VERSION="$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f -1)"
  if [[ "${SHELL_VERSION:-}" -ge "40" ]]; then
    GS_VERSION="new"
  else
    GS_VERSION="old"
  fi
  else
    echo "'gnome-shell' not found, using styles for last gnome-shell version available."
    GS_VERSION="new"
fi

install() {
  local dest="$1"
  local name="$2"
  local theme="$3"
  local color="$4"
  local size="$5"

  [[ "$color" == '-dark' ]] && local ELSE_DARK="$color"
  [[ "$color" == '-light' ]] && local ELSE_LIGHT="$color"

  local THEME_DIR="$dest/$name$theme$color$size"

  [[ -d "$THEME_DIR" ]] && rm -rf "${THEME_DIR:?}"

  theme_tweaks && install_theme_color

  echo "Installing '$THEME_DIR'..."

  mkdir -p                                                                      "$THEME_DIR"
  cp -r "$REPO_DIR/COPYING"                                                     "$THEME_DIR"

  echo "[Desktop Entry]" >>                                                     "$THEME_DIR/index.theme"
  echo "Type=X-GNOME-Metatheme" >>                                              "$THEME_DIR/index.theme"
  echo "Name=$name$theme$color$size" >>                                         "$THEME_DIR/index.theme"
  echo "Comment=An Materia Gtk+ theme based on Elegant Design" >>               "$THEME_DIR/index.theme"
  echo "Encoding=UTF-8" >>                                                      "$THEME_DIR/index.theme"
  echo "" >>                                                                    "$THEME_DIR/index.theme"
  echo "[X-GNOME-Metatheme]" >>                                                 "$THEME_DIR/index.theme"
  echo "GtkTheme=$name$theme$color$size" >>                                     "$THEME_DIR/index.theme"
  echo "MetacityTheme=$name$theme$color$size" >>                                "$THEME_DIR/index.theme"
  echo "IconTheme=Tela-circle${ELSE_DARK:-}" >>                                 "$THEME_DIR/index.theme"
  echo "CursorTheme=Vimix${ELSE_DARK:-}" >>                                     "$THEME_DIR/index.theme"
  echo "ButtonLayout=close,minimize,maximize:menu" >>                           "$THEME_DIR/index.theme"

  mkdir -p                                                                      "$THEME_DIR/gnome-shell"
  cp -r "$SRC_DIR/gnome-shell/pad-osd.css"                                      "$THEME_DIR/gnome-shell"

  if [[ "$tweaks" == 'true' ]]; then
    if [[ "${GS_VERSION:-}" == 'new' ]]; then
      sassc $SASSC_OPT "$SRC_DIR/gnome-shell/shell-40-0/gnome-shell${ELSE_DARK:-}$size.scss" "$THEME_DIR/gnome-shell/gnome-shell.css"
    else
      sassc $SASSC_OPT "$SRC_DIR/gnome-shell/shell-3-28/gnome-shell${ELSE_DARK:-}$size.scss" "$THEME_DIR/gnome-shell/gnome-shell.css"
    fi
  else
    if [[ "${GS_VERSION:-}" == 'new' ]]; then
      cp -r "$SRC_DIR/gnome-shell/shell-40-0/gnome-shell${ELSE_DARK:-}$size.css"    "$THEME_DIR/gnome-shell/gnome-shell.css"
    else
      cp -r "$SRC_DIR/gnome-shell/shell-3-28/gnome-shell${ELSE_DARK:-}$size.css"    "$THEME_DIR/gnome-shell/gnome-shell.css"
    fi
  fi

  cp -r "$SRC_DIR/gnome-shell/common-assets"                                    "$THEME_DIR/gnome-shell/assets"
  cp -r "$SRC_DIR/gnome-shell/assets${ELSE_DARK:-}/"*.svg                       "$THEME_DIR/gnome-shell/assets"

  if [[ "$primary" == 'true' ]]; then
    cp -r "$SRC_DIR/gnome-shell/theme$theme/checkbox${ELSE_DARK:-}.svg"         "$THEME_DIR/gnome-shell/assets/checkbox.svg"
  fi

  if [[ "$theme" != '' ]]; then
    cp -r "$SRC_DIR/gnome-shell/theme$theme/more-results${ELSE_DARK:-}.svg"     "$THEME_DIR/gnome-shell/assets/more-results.svg"
    cp -r "$SRC_DIR/gnome-shell/theme$theme/toggle-on${ELSE_DARK:-}.svg"        "$THEME_DIR/gnome-shell/assets/toggle-on.svg"
  fi

  cd "$THEME_DIR/gnome-shell"
  ln -s assets/no-events.svg no-events.svg
  ln -s assets/process-working.svg process-working.svg
  ln -s assets/no-notifications.svg no-notifications.svg

  mkdir -p                                                                      "$THEME_DIR/gtk-2.0"
  cp -r "$SRC_DIR/gtk-2.0/common/"{apps.rc,hacks.rc,main.rc}                    "$THEME_DIR/gtk-2.0"
  cp -r "$SRC_DIR/gtk-2.0/gtkrc$theme${ELSE_DARK:-}"                            "$THEME_DIR/gtk-2.0/gtkrc"
  cp -r "$SRC_DIR/gtk-2.0/assets-folder/assets$theme${ELSE_DARK:-}"             "$THEME_DIR/gtk-2.0/assets"

  if [[ "$primary" != "true" ]]; then
    cp -rf "$SRC_DIR/gtk-2.0/assets-folder/assets-default-radio${ELSE_DARK:-}"/*.png "$THEME_DIR/gtk-2.0/assets"
  fi

  mkdir -p                                                                      "$THEME_DIR/gtk-3.0"
  cp -r "$SRC_DIR/gtk/assets$theme"                                             "$THEME_DIR/gtk-3.0/assets"
  cp -r "$SRC_DIR/gtk/scalable"                                                 "$THEME_DIR/gtk-3.0/assets"
  cp -r "$SRC_DIR/gtk/thumbnail${ELSE_DARK:-}.png"                              "$THEME_DIR/gtk-3.0/thumbnail.png"

  if [[ "$tweaks" == 'true' ]]; then
    sassc $SASSC_OPT "$SRC_DIR/gtk/3.0/gtk$color$size.scss"                     "$THEME_DIR/gtk-3.0/gtk.css"
    [[ "$color" != '-dark' ]] && \
    sassc $SASSC_OPT "$SRC_DIR/gtk/3.0/gtk-dark$size.scss"                      "$THEME_DIR/gtk-3.0/gtk-dark.css"
  else
    cp -r "$SRC_DIR/gtk/3.0/gtk$color$size.css"                                 "$THEME_DIR/gtk-3.0/gtk.css"
    [[ "$color" != '-dark' ]] && \
    cp -r "$SRC_DIR/gtk/3.0/gtk-dark$size.css"                                  "$THEME_DIR/gtk-3.0/gtk-dark.css"
  fi

  mkdir -p                                                                      "$THEME_DIR/gtk-4.0"
  cp -r "$SRC_DIR/gtk/assets$theme"                                             "$THEME_DIR/gtk-4.0/assets"
  cp -r "$SRC_DIR/gtk/scalable"                                                 "$THEME_DIR/gtk-4.0/assets"

  if [[ "$tweaks" == 'true' ]]; then
    sassc $SASSC_OPT "$SRC_DIR/gtk/4.0/gtk$color$size.scss"                     "$THEME_DIR/gtk-4.0/gtk.css"
    [[ "$color" != '-dark' ]] && \
    sassc $SASSC_OPT "$SRC_DIR/gtk/4.0/gtk-dark$size.scss"                      "$THEME_DIR/gtk-4.0/gtk-dark.css"
  else
    cp -r "$SRC_DIR/gtk/4.0/gtk$color$size.css"                                 "$THEME_DIR/gtk-4.0/gtk.css"
    [[ "$color" != '-dark' ]] && \
    cp -r "$SRC_DIR/gtk/4.0/gtk-dark$size.css"                                  "$THEME_DIR/gtk-4.0/gtk-dark.css"
  fi

  mkdir -p                                                                      "$THEME_DIR/xfwm4"
  cp -r "$SRC_DIR/xfwm4/assets${ELSE_LIGHT:-}/"*.png                            "$THEME_DIR/xfwm4"
  cp -r "$SRC_DIR/xfwm4/themerc${ELSE_LIGHT:-}"                                 "$THEME_DIR/xfwm4/themerc"

  mkdir -p                                                                      "$THEME_DIR/cinnamon"
  cp -r "$SRC_DIR/cinnamon/common-assets"                                       "$THEME_DIR/cinnamon/assets"
  cp -r "$SRC_DIR/cinnamon/assets${ELSE_DARK:-}/"*.svg                          "$THEME_DIR/cinnamon/assets"

  if [[ "$tweaks" == 'true' ]]; then
    sassc $SASSC_OPT "$SRC_DIR/cinnamon/cinnamon${ELSE_DARK:-}$size.scss"       "$THEME_DIR/cinnamon/cinnamon.css"
  else
    cp -r "$SRC_DIR/cinnamon/cinnamon${ELSE_DARK:-}$size.css"                   "$THEME_DIR/cinnamon/cinnamon.css"
  fi

  cp -r "$SRC_DIR/cinnamon/thumbnail${ELSE_DARK:-}.png"                         "$THEME_DIR/cinnamon/thumbnail.png"

  mkdir -p                                                                      "$THEME_DIR/metacity-1"
  cp -r "$SRC_DIR/metacity-1/metacity-theme-2${color}.xml"                      "$THEME_DIR/metacity-1/metacity-theme-2.xml"
  cp -r "$SRC_DIR/metacity-1/metacity-theme-3.xml"                              "$THEME_DIR/metacity-1"
  cp -r "$SRC_DIR/metacity-1/assets"                                            "$THEME_DIR/metacity-1"
  cp -r "$SRC_DIR/metacity-1/thumbnail${ELSE_DARK:-}.png"                       "$THEME_DIR/metacity-1/thumbnail.png"
  cd "$THEME_DIR/metacity-1" && ln -s metacity-theme-2.xml metacity-theme-1.xml

  mkdir -p                                                                      "$THEME_DIR/plank"
  cp -r "$SRC_DIR/plank/dock.theme"                                             "$THEME_DIR/plank"
}

#  Install needed packages
install_package() {
  if [ ! "$(which sassc 2> /dev/null)" ]; then
    echo sassc needs to be installed to generate the css.
    if has_command zypper; then
      sudo zypper in sassc
    elif has_command apt-get; then
      sudo apt-get install sassc
    elif has_command dnf; then
      sudo dnf install sassc
    elif has_command dnf; then
      sudo dnf install sassc
    elif has_command pacman; then
      sudo pacman -S --noconfirm sassc
    fi
  fi
}

tweaks_temp() {
  cp -rf ${SRC_DIR}/_sass/_tweaks.scss ${SRC_DIR}/_sass/_tweaks-temp.scss
  cp -rf ${SRC_DIR}/gnome-shell/sass/_tweaks.scss ${SRC_DIR}/gnome-shell/sass/_tweaks-temp.scss
}

change_radio_color() {
  sed -i "/\$check_radio:/s/default/primary/" ${SRC_DIR}/_sass/_tweaks-temp.scss
  echo "Change radio color ..."
}

install_compact_panel() {
  sed -i "/\$panel_style:/s/float/compact/" ${SRC_DIR}/gnome-shell/sass/_tweaks-temp.scss
  echo -e "Install compact panel version ..."
}

install_solid() {
  sed -i "/\$opacity:/s/default/solid/" ${SRC_DIR}/gnome-shell/sass/_tweaks-temp.scss
  sed -i "/\$opacity:/s/default/solid/" ${SRC_DIR}/_sass/_tweaks-temp.scss
  echo -e "Install solid version ..."
}

install_black() {
  sed -i "/\$blackness:/s/false/true/" ${SRC_DIR}/gnome-shell/sass/_tweaks-temp.scss
  sed -i "/\$blackness:/s/false/true/" ${SRC_DIR}/_sass/_tweaks-temp.scss
  echo -e "Install black version ..."
}

install_theme_color() {
  if [[ "$theme" != '' ]]; then
    case "$theme" in
      -purple)
        theme_color='purple'
        ;;
      -pink)
        theme_color='pink'
        ;;
      -red)
        theme_color='red'
        ;;
      -orange)
        theme_color='orange'
        ;;
      -yellow)
        theme_color='yellow'
        ;;
      -green)
        theme_color='green'
        ;;
      -grey)
        theme_color='grey'
        ;;
    esac
    sed -i "/\$theme:/s/default/${theme_color}/" ${SRC_DIR}/gnome-shell/sass/_tweaks-temp.scss
    sed -i "/\$theme:/s/default/${theme_color}/" ${SRC_DIR}/_sass/_tweaks-temp.scss
  fi
}

theme_tweaks() {
  install_package; tweaks_temp

  if [[ "$panel" = "compact" || "$opacity" == 'solid' || "$blackness" == "true" || "$accent" == "true" || "$primary" == "true" ]]; then
    tweaks='true'
  fi

if [[ "$panel" == "compact" ]] ; then
  install_compact_panel
fi

if [[ "$opacity" == "solid" ]] ; then
  install_solid
fi

if [[ "$blackness" == "true" ]] ; then
  install_black
fi

if [[ "$primary" == "true" ]] ; then
  change_radio_color
fi
}

install_theme() {
  for theme in "${themes[@]}"; do
    for color in "${colors[@]}"; do
      for size in "${sizes[@]}"; do
        install "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$theme" "$color" "$size"
      done
    done
  done
}
