
REPO_DIR="$(dirname "$(readlink -m "${0}")")"
SRC_DIR="$REPO_DIR/src"

source "${REPO_DIR}/gtkrc.sh"

ROOT_UID=0
DEST_DIR=

# Destination directory
if [[ "$UID" -eq "$ROOT_UID" ]]; then
  DEST_DIR="/usr/share/themes"
else
  DEST_DIR="$HOME/.themes"
fi

SASSC_OPT="-M -t expanded"

THEME_NAME=$2
THEME_VARIANTS=('' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey')
COLOR_VARIANTS=('' '-Light' '-Dark')
SIZE_VARIANTS=('' '-Compact')

# Old name variants
OLD_THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-grey')
OLD_COLOR_VARIANTS=('' '-light' '-dark')
OLD_SIZE_VARIANTS=('' '-compact')

ctype=

# Check command availability
function has_command() {
  command -v $1 > /dev/null
}

install() {
  local dest="$1"
  local name="$2"
  local theme="$3"
  local color="$4"
  local size="$5"
  local ctype="$6"

  if [[ "$color" == '-Dark' ]]; then
    local ELSE_DARK="$color"
    local icon_color='-dark'
    local else_icon_dark="$icon_color"
  fi

  if [[ "$color" == '-Light' ]]; then
    local ELSE_LIGHT="$color"
    local icon_color='-light'
    local else_icon_light="$icon_color"
  fi

  local THEME_DIR="${1}/${2}${3}${4}${5}${6}"

  [[ -d "$THEME_DIR" ]] && rm -rf "$THEME_DIR"

  theme_tweaks && install_theme_color

  echo "Installing '$THEME_DIR'..."

  mkdir -p                                                                      "$THEME_DIR"
  cp -r "$REPO_DIR/COPYING"                                                     "$THEME_DIR"

  echo "[Desktop Entry]" >>                                                     "$THEME_DIR/index.theme"
  echo "Type=X-GNOME-Metatheme" >>                                              "$THEME_DIR/index.theme"
  echo "Name=${2}${3}${4}${5}${6}" >>                                           "$THEME_DIR/index.theme"
  echo "Comment=An flat Materia Gtk+ theme based on Elegant Design" >>          "$THEME_DIR/index.theme"
  echo "Encoding=UTF-8" >>                                                      "$THEME_DIR/index.theme"
  echo "" >>                                                                    "$THEME_DIR/index.theme"
  echo "[X-GNOME-Metatheme]" >>                                                 "$THEME_DIR/index.theme"
  echo "GtkTheme=${2}${3}${4}${5}${6}" >>                                       "$THEME_DIR/index.theme"
  echo "MetacityTheme=${2}${3}${4}${5}${6}" >>                                  "$THEME_DIR/index.theme"
  echo "IconTheme=Tela-circle${else_icon_dark:-}" >>                            "$THEME_DIR/index.theme"
  echo "CursorTheme=Vimix${else_icon_dark:-}" >>                                "$THEME_DIR/index.theme"
  echo "ButtonLayout=close,minimize,maximize:menu" >>                           "$THEME_DIR/index.theme"

  mkdir -p                                                                      "$THEME_DIR/gnome-shell"
  cp -r "$SRC_DIR/gnome-shell/pad-osd.css"                                      "$THEME_DIR/gnome-shell"

  if [[ "$tweaks" == 'true' ]]; then
    sassc $SASSC_OPT "$SRC_DIR/gnome-shell/shell-$GS_VERSION/gnome-shell${ELSE_DARK:-}$size.scss" "$THEME_DIR/gnome-shell/gnome-shell.css"
  else
    cp -r "$SRC_DIR/gnome-shell/shell-$GS_VERSION/gnome-shell${ELSE_DARK:-}$size.css" "$THEME_DIR/gnome-shell/gnome-shell.css"
  fi

  cp -r "$SRC_DIR/gnome-shell/common-assets"                                    "$THEME_DIR/gnome-shell/assets"
  cp -r "$SRC_DIR/gnome-shell/assets${ELSE_DARK:-}/"*.svg                       "$THEME_DIR/gnome-shell/assets"

  if [[ "$primary" == 'true' ]]; then
    cp -r "$SRC_DIR/gnome-shell/theme$theme$ctype/checkbox${ELSE_DARK:-}.svg"   "$THEME_DIR/gnome-shell/assets/checkbox.svg"
  fi

  cp -r "$SRC_DIR/gnome-shell/theme$theme$ctype/more-results${ELSE_DARK:-}.svg" "$THEME_DIR/gnome-shell/assets/more-results.svg"
  cp -r "$SRC_DIR/gnome-shell/theme$theme$ctype/toggle-on${ELSE_DARK:-}.svg"    "$THEME_DIR/gnome-shell/assets/toggle-on.svg"

  cd "$THEME_DIR/gnome-shell"
  ln -s assets/no-events.svg no-events.svg
  ln -s assets/process-working.svg process-working.svg
  ln -s assets/no-notifications.svg no-notifications.svg

  mkdir -p                                                                      "$THEME_DIR/gtk-2.0"
  cp -r "$SRC_DIR/gtk-2.0/common/"{apps.rc,hacks.rc,main.rc}                    "$THEME_DIR/gtk-2.0"
  cp -r "$SRC_DIR/gtk-2.0/assets-folder/assets-common${ELSE_DARK:-}$ctype"      "$THEME_DIR/gtk-2.0/assets"
  cp -r "$SRC_DIR/gtk-2.0/assets-folder/assets$theme${ELSE_DARK:-}$ctype/"*"png" "$THEME_DIR/gtk-2.0/assets"

  if [[ "$primary" != "true" ]]; then
    cp -rf "$SRC_DIR/gtk-2.0/assets-folder/assets-default-radio${ELSE_DARK:-}$ctype"/*.png "$THEME_DIR/gtk-2.0/assets"
  fi

  mkdir -p                                                                      "$THEME_DIR/gtk-3.0"
  cp -r "$SRC_DIR/gtk/assets$theme$ctype"                                       "$THEME_DIR/gtk-3.0/assets"
  cp -r "$SRC_DIR/gtk/scalable"                                                 "$THEME_DIR/gtk-3.0/assets"
  cp -r "$SRC_DIR/gtk/thumbnails/thumbnail$theme${ELSE_DARK:-}$ctype.png"       "$THEME_DIR/gtk-3.0/thumbnail.png"

  if [[ "$tweaks" == 'true' ]]; then
    sassc $SASSC_OPT "$SRC_DIR/gtk/3.0/gtk$color$size.scss"                     "$THEME_DIR/gtk-3.0/gtk.css"
    sassc $SASSC_OPT "$SRC_DIR/gtk/3.0/gtk-Dark$size.scss"                      "$THEME_DIR/gtk-3.0/gtk-dark.css"
  else
    cp -r "$SRC_DIR/gtk/3.0/gtk$color$size.css"                                 "$THEME_DIR/gtk-3.0/gtk.css"
    cp -r "$SRC_DIR/gtk/3.0/gtk-Dark$size.css"                                  "$THEME_DIR/gtk-3.0/gtk-dark.css"
  fi

  mkdir -p                                                                      "$THEME_DIR/gtk-4.0"
  cp -r "$SRC_DIR/gtk/assets$theme$ctype"                                       "$THEME_DIR/gtk-4.0/assets"
  cp -r "$SRC_DIR/gtk/scalable"                                                 "$THEME_DIR/gtk-4.0/assets"

  if [[ "$tweaks" == 'true' ]]; then
    sassc $SASSC_OPT "$SRC_DIR/gtk/4.0/gtk$color$size.scss"                     "$THEME_DIR/gtk-4.0/gtk.css"
    sassc $SASSC_OPT "$SRC_DIR/gtk/4.0/gtk-Dark$size.scss"                      "$THEME_DIR/gtk-4.0/gtk-dark.css"
  else
    cp -r "$SRC_DIR/gtk/4.0/gtk$color$size.css"                                 "$THEME_DIR/gtk-4.0/gtk.css"
    cp -r "$SRC_DIR/gtk/4.0/gtk-Dark$size.css"                                  "$THEME_DIR/gtk-4.0/gtk-dark.css"
  fi

  mkdir -p                                                                      "$THEME_DIR/xfwm4"

  if [[ "$macstyle" == "true" ]] ; then
    cp -r "$SRC_DIR/xfwm4/assets${ELSE_LIGHT:-}$ctype-mac/"*.png                "$THEME_DIR/xfwm4"
  else
    cp -r "$SRC_DIR/xfwm4/assets${ELSE_LIGHT:-}$ctype/"*.png                    "$THEME_DIR/xfwm4"
  fi

  cp -r "$SRC_DIR/xfwm4/themerc${ELSE_LIGHT:-}$ctype"                           "$THEME_DIR/xfwm4/themerc"

  mkdir -p                                                                      "$THEME_DIR/cinnamon"
  cp -r "$SRC_DIR/cinnamon/common-assets"                                       "$THEME_DIR/cinnamon/assets"
  cp -r "$SRC_DIR/cinnamon/assets${ELSE_DARK:-}/"*.svg                          "$THEME_DIR/cinnamon/assets"
  cp -r "$SRC_DIR/cinnamon/theme$theme$ctype/add-workspace-active${ELSE_DARK:-}.svg" "$THEME_DIR/cinnamon/assets/add-workspace-active.svg"
  cp -r "$SRC_DIR/cinnamon/theme$theme$ctype/corner-ripple${ELSE_DARK:-}.svg"   "$THEME_DIR/cinnamon/assets/corner-ripple.svg"
  cp -r "$SRC_DIR/cinnamon/theme$theme$ctype/toggle-on${ELSE_DARK:-}.svg"       "$THEME_DIR/cinnamon/assets/toggle-on.svg"

  if [[ "$primary" == 'true' ]]; then
    cp -r "$SRC_DIR/cinnamon/theme$theme$ctype/checkbox${ELSE_DARK:-}.svg"      "$THEME_DIR/cinnamon/assets/checkbox.svg"
    cp -r "$SRC_DIR/cinnamon/theme$theme$ctype/radiobutton${ELSE_DARK:-}.svg"   "$THEME_DIR/cinnamon/assets/radiobutton.svg"
  fi

  if [[ "$tweaks" == 'true' ]]; then
    sassc $SASSC_OPT "$SRC_DIR/cinnamon/cinnamon${ELSE_DARK:-}$size.scss"       "$THEME_DIR/cinnamon/cinnamon.css"
  else
    cp -r "$SRC_DIR/cinnamon/cinnamon${ELSE_DARK:-}$size.css"                   "$THEME_DIR/cinnamon/cinnamon.css"
  fi

  cp -r "$SRC_DIR/cinnamon/thumbnails/thumbnail$theme${ELSE_DARK:-}$ctype.png"  "$THEME_DIR/cinnamon/thumbnail.png"

  mkdir -p                                                                      "$THEME_DIR/metacity-1"
  cp -r "$SRC_DIR/metacity-1/metacity-theme-2${color}.xml"                      "$THEME_DIR/metacity-1/metacity-theme-2.xml"
  cp -r "$SRC_DIR/metacity-1/metacity-theme-3.xml"                              "$THEME_DIR/metacity-1"
  cp -r "$SRC_DIR/metacity-1/assets"                                            "$THEME_DIR/metacity-1"
  cp -r "$SRC_DIR/metacity-1/thumbnail${ELSE_DARK:-}.png"                       "$THEME_DIR/metacity-1/thumbnail.png"
  cd "$THEME_DIR/metacity-1" && ln -s metacity-theme-2.xml metacity-theme-1.xml

  mkdir -p                                                                      "$THEME_DIR/plank"
  cp -r "$SRC_DIR/plank/"*                                                      "$THEME_DIR/plank"
}

uninstall() {
  local dest="$1"
  local name="$2"
  local theme="$3"
  local color="$4"
  local size="$5"
  local ctype="$6"

  local THEME_DIR="${1}/${2}${3}${4}${5}${6}"

  [[ -d "$THEME_DIR" ]] && rm -rf "$THEME_DIR" && echo -e "Uninstalling "$THEME_DIR" ..."
}

clean() {
  local dest="$1"
  local name="$2"
  local theme="$3"
  local color="$4"
  local size="$5"

  local THEME_DIR="$dest/$name$theme$color$size"

  if [[ "${theme}" == '' && "${color}" == '' && "${size}" == '' ]]; then
    todo='nothing'
  elif [[ -d "${THEME_DIR}" ]]; then
    rm -rf "${THEME_DIR}"
    echo -e "Find: ${THEME_DIR} ! removing it ..."
  fi
}

uninstall_link() {
  rm -rf "${HOME}/.config/gtk-4.0/"{assets,gtk.css,gtk-dark.css}
  echo -e "\nRemoving ${HOME}/.config/gtk-4.0 links..."
}

link_libadwaita() {
  local dest="$1"
  local name="$2"
  local theme="$3"
  local color="$4"
  local size="$5"
  local ctype="$6"

  local THEME_DIR="${1}/${2}${3}${4}${5}${6}"

  echo -e "\nLink '$THEME_DIR/gtk-4.0' to '${HOME}/.config/gtk-4.0' for libadwaita..."

  mkdir -p                                                                      "${HOME}/.config/gtk-4.0"
  rm -rf "${HOME}/.config/gtk-4.0/"{assets,gtk.css,gtk-dark.css}
  ln -sf "${THEME_DIR}/gtk-4.0/assets"                                          "${HOME}/.config/gtk-4.0/assets"
  ln -sf "${THEME_DIR}/gtk-4.0/gtk.css"                                         "${HOME}/.config/gtk-4.0/gtk.css"
  ln -sf "${THEME_DIR}/gtk-4.0/gtk-dark.css"                                    "${HOME}/.config/gtk-4.0/gtk-dark.css"
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
    elif has_command pacman; then
      sudo pacman -S --noconfirm sassc
    fi
  fi
}

tweaks_temp() {
  cp -rf ${SRC_DIR}/_sass/_tweaks.scss ${SRC_DIR}/_sass/_tweaks-temp.scss
}

change_radio_color() {
  sed -i "/\$check_radio:/s/default/primary/" ${SRC_DIR}/_sass/_tweaks-temp.scss
}

install_compact_panel() {
  sed -i "/\$panel_style:/s/float/compact/" ${SRC_DIR}/_sass/_tweaks-temp.scss
}

install_solid() {
  sed -i "/\$opacity:/s/default/solid/" ${SRC_DIR}/_sass/_tweaks-temp.scss
}

install_black() {
  sed -i "/\$blackness:/s/false/true/" ${SRC_DIR}/_sass/_tweaks-temp.scss
}

install_mac() {
  sed -i "/\$mac_style:/s/false/true/" ${SRC_DIR}/_sass/_tweaks-temp.scss
}

round_corner() {
  sed -i "/\$default_corner:/s/12px/${corner}/" ${SRC_DIR}/_sass/_tweaks-temp.scss
}

install_submenu() {
  sed -i "/\$submenu_style:/s/false/true/" ${SRC_DIR}/_sass/_tweaks-temp.scss
}

install_nord() {
  sed -i "/\@import/s/color-palette-default/color-palette-nord/" ${SRC_DIR}/_sass/_tweaks-temp.scss
  sed -i "/\$colorscheme:/s/default/nord/" ${SRC_DIR}/_sass/_tweaks-temp.scss
}

install_dracula() {
  sed -i "/\@import/s/color-palette-default/color-palette-dracula/" ${SRC_DIR}/_sass/_tweaks-temp.scss
  sed -i "/\$colorscheme:/s/default/dracula/" ${SRC_DIR}/_sass/_tweaks-temp.scss
}

install_theme_color() {
  if [[ "$theme" != '' ]]; then
    case "$theme" in
      -Purple)
        theme_color='purple'
        ;;
      -Pink)
        theme_color='pink'
        ;;
      -Red)
        theme_color='red'
        ;;
      -Orange)
        theme_color='orange'
        ;;
      -Yellow)
        theme_color='yellow'
        ;;
      -Green)
        theme_color='green'
        ;;
      -Teal)
        theme_color='teal'
        ;;
      -Grey)
        theme_color='grey'
        ;;
    esac
    sed -i "/\$theme:/s/default/${theme_color}/" ${SRC_DIR}/_sass/_tweaks-temp.scss
  fi
}

theme_tweaks() {
  install_package; tweaks_temp

  if [[ "$panel" == "compact" || "$opacity" == 'solid' || "$blackness" == "true" || "$accent" == "true" || "$primary" == "true" || "$round" == "true" || "$macstyle" == "true" || "$submenu" == "true" || "$nord" == 'true' || "$dracula" == 'true' ]]; then
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

  if [[ "$round" == "true" ]] ; then
    round_corner
  fi

  if [[ "$macstyle" == "true" ]] ; then
    install_mac
  fi

  if [[ "$submenu" == "true" ]] ; then
    install_submenu
  fi

  if [[ "$nord" == "true" ]] ; then
    install_nord
  fi

  if [[ "$dracula" == "true" ]] ; then
    install_dracula
  fi
}

check_shell() {
  if [[ "$shell" == "38" ]]; then
    GS_VERSION="3-28"
    echo "Install for gnome-shell version < 40.0"
  elif [[ "$shell" == "40" ]]; then
    GS_VERSION="40-0"
    echo "Install for gnome-shell version = 40.0"
  elif [[ "$shell" == "42" ]]; then
    GS_VERSION="42-0"
    echo "Install for gnome-shell version = 42.0"
  elif [[ "$shell" == "44" ]]; then
    GS_VERSION="44-0"
    echo "Install for gnome-shell version = 44.0"
  elif [[ "$(command -v gnome-shell)" ]]; then
    gnome-shell --version
    SHELL_VERSION="$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f -1)"
    if [[ "${SHELL_VERSION:-}" -ge "44" ]]; then
      GS_VERSION="44-0"
    elif [[ "${SHELL_VERSION:-}" -ge "42" ]]; then
      GS_VERSION="42-0"
    elif [[ "${SHELL_VERSION:-}" -ge "40" ]]; then
      GS_VERSION="40-0"
    else
      GS_VERSION="3-28"
    fi
    else
      echo "'gnome-shell' not found, using styles for last gnome-shell version available."
      GS_VERSION="44-0"
  fi
}

install_theme() {
  check_shell

  for theme in "${themes[@]}"; do
    for color in "${colors[@]}"; do
      for size in "${sizes[@]}"; do
        install "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$theme" "$color" "$size" "$ctype"
        make_gtkrc "${dest:-$DEST_DIR}" "${name:-$THEME_NAME}" "$theme" "$color" "$size" "$ctype"
      done
    done
  done

  if (which xfce4-popup-whiskermenu 2> /dev/null); then
    sed -i "s|.*menu-opacity=.*|menu-opacity=0|" "$HOME/.config/xfce4/panel/whiskermenu"*".rc"
  fi

  if (pgrep xfce4-session &> /dev/null); then
    xfce4-panel -r
  fi

  local DASH_TO_DOCK_STYLESHEET="$HOME/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/stylesheet.css"

  if [[ -f "$DASH_TO_DOCK_STYLESHEET" ]]; then
    mv "$DASH_TO_DOCK_STYLESHEET" "$DASH_TO_DOCK_STYLESHEET".bak
  fi
}

uninstall_theme() {
  for theme in "${THEME_VARIANTS[@]}"; do
    for color in "${colors[@]}"; do
      for size in "${sizes[@]}"; do
        uninstall "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$theme" "$color" "$size" "$ctype"
      done
    done
  done
}

clean_theme() {
  for theme in "${othemes[@]}"; do
    for color in "${ocolors[@]}"; do
      for size in "${osizes[@]}"; do
        clean "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$theme" "$color" "$size"
      done
    done
  done
}

link_theme() {
  for theme in "${themes[@]}"; do
    for color in "${lcolors[@]}"; do
      for size in "${sizes[0]}"; do
        link_libadwaita "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$theme" "$color" "$size" "$ctype"
      done
    done
  done
}
