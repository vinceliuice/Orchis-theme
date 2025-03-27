
REPO_DIR="$(dirname "$(readlink -m "${0}")")"
SRC_DIR="$REPO_DIR/src"

source "${REPO_DIR}/gtkrc.sh"

ROOT_UID=0
DEST_DIR=

MY_USERNAME="${SUDO_USER:-$(logname 2> /dev/null || echo "${USER}")}"
MY_HOME=$(getent passwd "${MY_USERNAME}" | cut -d: -f6)

# Destination directory
if [[ "$UID" -eq "$ROOT_UID" ]]; then
  DEST_DIR="/usr/share/themes"
elif [[ -n "$XDG_DATA_HOME" ]]; then
  DEST_DIR="$XDG_DATA_HOME/themes"
elif [[ -d "$HOME/.themes" ]]; then
  DEST_DIR="$HOME/.themes"
elif [[ -d "$HOME/.local/share/themes" ]]; then
  DEST_DIR="$HOME/.local/share/themes"
else
  DEST_DIR="$HOME/.themes"
fi

SASSC_OPT="-M -t expanded"

THEME_NAME=Orchis
THEME_VARIANTS=('' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey')
COLOR_VARIANTS=('' '-Light' '-Dark')
SIZE_VARIANTS=('' '-Compact')

ctype=
icon='-default'

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
  local icon="$7"

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

  mkdir -p                                                                                   "$THEME_DIR"
  cp -r "$REPO_DIR/COPYING"                                                                  "$THEME_DIR"

  echo "[Desktop Entry]" >>                                                                  "$THEME_DIR/index.theme"
  echo "Type=X-GNOME-Metatheme" >>                                                           "$THEME_DIR/index.theme"
  echo "Name=${2}${3}${4}${5}${6}" >>                                                        "$THEME_DIR/index.theme"
  echo "Comment=An flat Materia Gtk+ theme based on Elegant Design" >>                       "$THEME_DIR/index.theme"
  echo "Encoding=UTF-8" >>                                                                   "$THEME_DIR/index.theme"
  echo "" >>                                                                                 "$THEME_DIR/index.theme"
  echo "[X-GNOME-Metatheme]" >>                                                              "$THEME_DIR/index.theme"
  echo "GtkTheme=${2}${3}${4}${5}${6}" >>                                                    "$THEME_DIR/index.theme"
  echo "MetacityTheme=${2}${3}${4}${5}${6}" >>                                               "$THEME_DIR/index.theme"
  echo "IconTheme=Tela-circle${else_icon_dark:-}" >>                                         "$THEME_DIR/index.theme"
  echo "CursorTheme=Vimix${else_icon_dark:-}" >>                                             "$THEME_DIR/index.theme"
  echo "ButtonLayout=close,minimize,maximize:menu" >>                                        "$THEME_DIR/index.theme"

  mkdir -p                                                                                   "$THEME_DIR/gnome-shell"
  cp -r "$SRC_DIR/gnome-shell/pad-osd.css"                                                   "$THEME_DIR/gnome-shell"
  sassc $SASSC_OPT "$SRC_DIR/gnome-shell/shell-$GS_VERSION/gnome-shell${ELSE_DARK:-}$size.scss" "$THEME_DIR/gnome-shell/gnome-shell.css"

  cp -r "$SRC_DIR/gnome-shell/common-assets"                                                 "$THEME_DIR/gnome-shell/assets"
  cp -r "$SRC_DIR/gnome-shell/assets${ELSE_DARK:-}/"*.svg                                    "$THEME_DIR/gnome-shell/assets"

  if [[ "$primary" == 'true' ]]; then
    cp -r "$SRC_DIR/gnome-shell/theme$theme$ctype/checkbox${ELSE_DARK:-}.svg"                "$THEME_DIR/gnome-shell/assets/checkbox.svg"
  fi

  cp -r "$SRC_DIR/gnome-shell/theme$theme$ctype/more-results${ELSE_DARK:-}.svg"              "$THEME_DIR/gnome-shell/assets/more-results.svg"
  cp -r "$SRC_DIR/gnome-shell/theme$theme$ctype/toggle-on${ELSE_DARK:-}.svg"                 "$THEME_DIR/gnome-shell/assets/toggle-on.svg"

  cp -r "$SRC_DIR/gnome-shell/activities/activities${icon}.svg"                              "$THEME_DIR/gnome-shell/assets/activities.svg"

  cd "$THEME_DIR/gnome-shell"
  ln -s assets/no-events.svg no-events.svg
  ln -s assets/process-working.svg process-working.svg
  ln -s assets/no-notifications.svg no-notifications.svg

  mkdir -p                                                                                   "$THEME_DIR/gtk-2.0"
  cp -r "$SRC_DIR/gtk-2.0/common/"{apps.rc,hacks.rc,main.rc}                                 "$THEME_DIR/gtk-2.0"
  cp -r "$SRC_DIR/gtk-2.0/assets-folder/assets-common${ELSE_DARK:-}$ctype"                   "$THEME_DIR/gtk-2.0/assets"
  cp -r "$SRC_DIR/gtk-2.0/assets-folder/assets$theme${ELSE_DARK:-}$ctype/"*"png"             "$THEME_DIR/gtk-2.0/assets"

  make_gtkrc

  if [[ "$primary" != "true" ]]; then
    cp -rf "$SRC_DIR/gtk-2.0/assets-folder/assets-default-radio${ELSE_DARK:-}$ctype"/*.png   "$THEME_DIR/gtk-2.0/assets"
  fi

  mkdir -p                                                                                   "$THEME_DIR/gtk-3.0"
  cp -r "$SRC_DIR/gtk/assets$theme$ctype"                                                    "$THEME_DIR/gtk-3.0/assets"
  cp -r "$SRC_DIR/gtk/scalable"                                                              "$THEME_DIR/gtk-3.0/assets"
  cp -r "$SRC_DIR/gtk/thumbnails/thumbnail$theme${ELSE_DARK:-}$ctype.png"                    "$THEME_DIR/gtk-3.0/thumbnail.png"
  sassc $SASSC_OPT "$SRC_DIR/gtk/3.0/gtk$color$size.scss"                                    "$THEME_DIR/gtk-3.0/gtk.css"
  sassc $SASSC_OPT "$SRC_DIR/gtk/3.0/gtk-Dark$size.scss"                                     "$THEME_DIR/gtk-3.0/gtk-dark.css"

  mkdir -p                                                                                   "$THEME_DIR/gtk-4.0"
  cp -r "$SRC_DIR/gtk/assets$theme$ctype"                                                    "$THEME_DIR/gtk-4.0/assets"
  cp -r "$SRC_DIR/gtk/scalable"                                                              "$THEME_DIR/gtk-4.0/assets"
  sassc $SASSC_OPT "$SRC_DIR/gtk/4.0/gtk$color$size.scss"                                    "$THEME_DIR/gtk-4.0/gtk.css"
  sassc $SASSC_OPT "$SRC_DIR/gtk/4.0/gtk-Dark$size.scss"                                     "$THEME_DIR/gtk-4.0/gtk-dark.css"

  mkdir -p                                                                                   "$THEME_DIR/xfwm4"
  cp -r "$SRC_DIR/xfwm4/xpm/assets/"*.xpm                                                    "$THEME_DIR/xfwm4"
  cp -r "$SRC_DIR/xfwm4/themerc"                                                             "$THEME_DIR/xfwm4/themerc"
  mkdir -p                                                                                   "$THEME_DIR-hdpi/xfwm4"
  cp -r "$SRC_DIR/xfwm4/xpm/assets-hdpi/"*.xpm                                               "$THEME_DIR-hdpi/xfwm4"
  cp -r "$SRC_DIR/xfwm4/themerc"                                                             "$THEME_DIR-hdpi/xfwm4/themerc"
  mkdir -p                                                                                   "$THEME_DIR-xhdpi/xfwm4"
  cp -r "$SRC_DIR/xfwm4/svg/assets${ELSE_LIGHT:-}-xhdpi/"*.svg                               "$THEME_DIR-xhdpi/xfwm4"
  cp -r "$SRC_DIR/xfwm4/xpm/assets-xhdpi/"*.xpm                                              "$THEME_DIR-xhdpi/xfwm4"
  cp -r "$SRC_DIR/xfwm4/themerc"                                                             "$THEME_DIR-xhdpi/xfwm4/themerc"

  if [[ "$macstyle" == "true" ]] ; then
    cp -r "$SRC_DIR/xfwm4/svg/assets${ELSE_LIGHT:-}-mac/"*.svg                               "$THEME_DIR/xfwm4"
    cp -r "$SRC_DIR/xfwm4/svg/assets${ELSE_LIGHT:-}-mac-hdpi/"*.svg                          "$THEME_DIR-hdpi/xfwm4"
    cp -r "$SRC_DIR/xfwm4/svg/assets${ELSE_LIGHT:-}-mac-xhdpi/"*.svg                         "$THEME_DIR-xhdpi/xfwm4"
    mv -f "$THEME_DIR/xfwm4/button-mac-active.xpm"                                           "$THEME_DIR/xfwm4/button-active.xpm"
    mv -f "$THEME_DIR-hdpi/xfwm4/button-mac-active.xpm"                                      "$THEME_DIR-hdpi/xfwm4/button-active.xpm"
    mv -f "$THEME_DIR-xhdpi/xfwm4/button-mac-active.xpm"                                     "$THEME_DIR-xhdpi/xfwm4/button-active.xpm"
    mv -f "$THEME_DIR/xfwm4/button-mac-inactive.xpm"                                         "$THEME_DIR/xfwm4/button-inactive.xpm"
    mv -f "$THEME_DIR-hdpi/xfwm4/button-mac-inactive.xpm"                                    "$THEME_DIR-hdpi/xfwm4/button-inactive.xpm"
    mv -f "$THEME_DIR-xhdpi/xfwm4/button-mac-inactive.xpm"                                   "$THEME_DIR-xhdpi/xfwm4/button-inactive.xpm"
  else
    cp -r "$SRC_DIR/xfwm4/svg/assets${ELSE_LIGHT:-}/"*.svg                                   "$THEME_DIR/xfwm4"
    cp -r "$SRC_DIR/xfwm4/svg/assets${ELSE_LIGHT:-}-hdpi/"*.svg                              "$THEME_DIR-hdpi/xfwm4"
    cp -r "$SRC_DIR/xfwm4/svg/assets${ELSE_LIGHT:-}-xhdpi/"*.svg                             "$THEME_DIR-xhdpi/xfwm4"
  fi

  if [[ "$macstyle" == "true" && "$ctype" != '' ]] ; then
    xfwm_button
  fi

  mkdir -p                                                                                   "$THEME_DIR/cinnamon"
  cp -r "$SRC_DIR/cinnamon/common-assets"                                                    "$THEME_DIR/cinnamon/assets"
  cp -r "$SRC_DIR/cinnamon/assets${ELSE_DARK:-}/"*.svg                                       "$THEME_DIR/cinnamon/assets"
  cp -r "$SRC_DIR/cinnamon/theme$theme$ctype/add-workspace-active${ELSE_DARK:-}.svg"         "$THEME_DIR/cinnamon/assets/add-workspace-active.svg"
  cp -r "$SRC_DIR/cinnamon/theme$theme$ctype/corner-ripple${ELSE_DARK:-}.svg"                "$THEME_DIR/cinnamon/assets/corner-ripple.svg"
  cp -r "$SRC_DIR/cinnamon/theme$theme$ctype/toggle-on${ELSE_DARK:-}.svg"                    "$THEME_DIR/cinnamon/assets/toggle-on.svg"

  if [[ "$primary" == 'true' ]]; then
    cp -r "$SRC_DIR/cinnamon/theme$theme$ctype/checkbox${ELSE_DARK:-}.svg"                   "$THEME_DIR/cinnamon/assets/checkbox.svg"
    cp -r "$SRC_DIR/cinnamon/theme$theme$ctype/radiobutton${ELSE_DARK:-}.svg"                "$THEME_DIR/cinnamon/assets/radiobutton.svg"
  fi

  sassc $SASSC_OPT "$SRC_DIR/cinnamon/cinnamon${ELSE_DARK:-}$size.scss"                      "$THEME_DIR/cinnamon/cinnamon.css"

  cp -r "$SRC_DIR/cinnamon/thumbnails/thumbnail$theme${ELSE_DARK:-}$ctype.png"               "$THEME_DIR/cinnamon/thumbnail.png"

  mkdir -p                                                                                   "$THEME_DIR/metacity-1"

  if [[ "$macstyle" == "true" ]] ; then
    cp -r "$SRC_DIR/metacity-1/metacity-theme-3-mac.xml"                                     "$THEME_DIR/metacity-1/metacity-theme-3.xml"
    cp -r "$SRC_DIR/metacity-1/assets-mac"                                                   "$THEME_DIR/metacity-1/assets"
    cp -r "$SRC_DIR/metacity-1/thumbnail${ELSE_DARK:-}-mac.png"                              "$THEME_DIR/metacity-1/thumbnail.png"
  else
    cp -r "$SRC_DIR/metacity-1/metacity-theme-3.xml"                                         "$THEME_DIR/metacity-1"
    cp -r "$SRC_DIR/metacity-1/assets"                                                       "$THEME_DIR/metacity-1"
    cp -r "$SRC_DIR/metacity-1/thumbnail${ELSE_DARK:-}.png"                                  "$THEME_DIR/metacity-1/thumbnail.png"
  fi

  (
    cd "$THEME_DIR/metacity-1" && ln -s metacity-theme-3.xml metacity-theme-2.xml && ln -s metacity-theme-3.xml metacity-theme-1.xml
  )

  mkdir -p                                                                                   "$THEME_DIR/plank"
  cp -r "$SRC_DIR/plank/"*                                                                   "$THEME_DIR/plank"
}

uninstall() {
  local dest="$1"
  local name="$2"
  local theme="$3"
  local color="$4"
  local size="$5"
  local ctype="$6"

  local THEME_DIR="${1}/${2}${3}${4}${5}${6}"

  [[ -d "$THEME_DIR" ]] && rm -rf "$THEME_DIR"{'','-hdpi','-xhdpi'} && echo -e "Uninstalling "$THEME_DIR" ..."
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

xfwm_button() {
  case "$ctype" in
    '')
      button_close="#fd5f51"
      button_max="#38c76a"
      button_min="#fdbe04"
      ;;
    -Nord)
      button_close="#bf616a"
      button_max="#a3be8c"
      button_min="#ebcb8b"
      ;;
    -Dracula)
      if [[ "$color" == '-Light' ]]; then
        button_close="#ed5d5d"
        button_max="#43db68"
        button_min="#e3d93b"
      else
        button_close="#f44d4d"
        button_max="#4be772"
        button_min="#e8f467"
      fi
      ;;
  esac

  sed -i "s/#fd5f51/${button_close}/g"                                          "${THEME_DIR}/xfwm4/close-active.svg"
  sed -i "s/#fd5f51/${button_close}/g"                                          "${THEME_DIR}/xfwm4/close-prelight.svg"
  sed -i "s/#fd5f51/${button_close}/g"                                          "${THEME_DIR}/xfwm4/close-pressed.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}/xfwm4/maximize-active.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}/xfwm4/maximize-prelight.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}/xfwm4/maximize-pressed.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}/xfwm4/maximize-toggled-active.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}/xfwm4/maximize-toggled-prelight.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}/xfwm4/maximize-toggled-pressed.svg"
  sed -i "s/#fdbe04/${button_min}/g"                                            "${THEME_DIR}/xfwm4/hide-active.svg"
  sed -i "s/#fdbe04/${button_min}/g"                                            "${THEME_DIR}/xfwm4/hide-prelight.svg"
  sed -i "s/#fdbe04/${button_min}/g"                                            "${THEME_DIR}/xfwm4/hide-pressed.svg"

  sed -i "s/#fd5f51/${button_close}/g"                                          "${THEME_DIR}-hdpi/xfwm4/close-active.svg"
  sed -i "s/#fd5f51/${button_close}/g"                                          "${THEME_DIR}-hdpi/xfwm4/close-prelight.svg"
  sed -i "s/#fd5f51/${button_close}/g"                                          "${THEME_DIR}-hdpi/xfwm4/close-pressed.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-hdpi/xfwm4/maximize-active.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-hdpi/xfwm4/maximize-prelight.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-hdpi/xfwm4/maximize-pressed.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-hdpi/xfwm4/maximize-toggled-active.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-hdpi/xfwm4/maximize-toggled-prelight.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-hdpi/xfwm4/maximize-toggled-pressed.svg"
  sed -i "s/#fdbe04/${button_min}/g"                                            "${THEME_DIR}-hdpi/xfwm4/hide-active.svg"
  sed -i "s/#fdbe04/${button_min}/g"                                            "${THEME_DIR}-hdpi/xfwm4/hide-prelight.svg"
  sed -i "s/#fdbe04/${button_min}/g"                                            "${THEME_DIR}-hdpi/xfwm4/hide-pressed.svg"

  sed -i "s/#fd5f51/${button_close}/g"                                          "${THEME_DIR}-xhdpi/xfwm4/close-active.svg"
  sed -i "s/#fd5f51/${button_close}/g"                                          "${THEME_DIR}-xhdpi/xfwm4/close-prelight.svg"
  sed -i "s/#fd5f51/${button_close}/g"                                          "${THEME_DIR}-xhdpi/xfwm4/close-pressed.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-xhdpi/xfwm4/maximize-active.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-xhdpi/xfwm4/maximize-prelight.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-xhdpi/xfwm4/maximize-pressed.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-xhdpi/xfwm4/maximize-toggled-active.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-xhdpi/xfwm4/maximize-toggled-prelight.svg"
  sed -i "s/#38c76a/${button_max}/g"                                            "${THEME_DIR}-xhdpi/xfwm4/maximize-toggled-pressed.svg"
  sed -i "s/#fdbe04/${button_min}/g"                                            "${THEME_DIR}-xhdpi/xfwm4/hide-active.svg"
  sed -i "s/#fdbe04/${button_min}/g"                                            "${THEME_DIR}-xhdpi/xfwm4/hide-prelight.svg"
  sed -i "s/#fdbe04/${button_min}/g"                                            "${THEME_DIR}-xhdpi/xfwm4/hide-pressed.svg"
}

#  Install needed packages
install_package() {
  if [ ! "$(which sassc 2> /dev/null)" ]; then
    echo sassc needs to be installed to generate the css.
    if has_command zypper; then
      sudo zypper in sassc
    elif has_command apt; then
      sudo apt install sassc
    elif has_command apt-get; then
      sudo apt-get install sassc
    elif has_command dnf; then
      sudo dnf install sassc
    elif has_command yum; then
      sudo yum install sassc
    elif has_command pacman; then
      sudo pacman -S --noconfirm sassc
    fi
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
  elif [[ "$shell" == "46" ]]; then
    GS_VERSION="46-0"
    echo "Install for gnome-shell version = 46.0"
  elif [[ "$shell" == "47" ]]; then
    GS_VERSION="47-0"
    echo "Install for gnome-shell version = 47.0"
  elif [[ "$shell" == "48" ]]; then
    GS_VERSION="48-0"
    echo "Install for gnome-shell version = 48.0"
  elif [[ "$(command -v gnome-shell)" ]]; then
    gnome-shell --version
    GNOME_SHELL="true"
    SHELL_VERSION="$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f -1)"
    if [[ "${SHELL_VERSION:-}" -ge "48" ]]; then
      GS_VERSION="48-0"
    elif [[ "${SHELL_VERSION:-}" -ge "47" ]]; then
      GS_VERSION="47-0"
    elif [[ "${SHELL_VERSION:-}" -ge "46" ]]; then
      GS_VERSION="46-0"
    elif [[ "${SHELL_VERSION:-}" -ge "44" ]]; then
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
    GS_VERSION="48-0"
    GNOME_SHELL="false"
  fi
}

tweaks_temp() {
  cp -rf $SRC_DIR/_sass/_tweaks.scss $SRC_DIR/_sass/_tweaks-temp.scss
}

change_radio_color() {
  sed -i "/\$check_radio:/s/default/primary/" $SRC_DIR/_sass/_tweaks-temp.scss
}

install_compact_panel() {
  sed -i "/\$panel_style:/s/float/compact/" $SRC_DIR/_sass/_tweaks-temp.scss
}

install_solid() {
  sed -i "/\$opacity:/s/default/solid/" $SRC_DIR/_sass/_tweaks-temp.scss
}

install_black() {
  sed -i "/\$blackness:/s/false/true/" $SRC_DIR/_sass/_tweaks-temp.scss
}

install_mac() {
  sed -i "/\$mac_style:/s/false/true/" $SRC_DIR/_sass/_tweaks-temp.scss
}

round_corner() {
  sed -i "/\$default_corner:/s/12px/${corner}/" $SRC_DIR/_sass/_tweaks-temp.scss
}

install_submenu() {
  sed -i "/\$submenu_style:/s/false/true/" $SRC_DIR/_sass/_tweaks-temp.scss
}

install_nord() {
  sed -i "/\@import/s/color-palette-default/color-palette-nord/" $SRC_DIR/_sass/_tweaks-temp.scss
  sed -i "/\$colorscheme:/s/default/nord/" $SRC_DIR/_sass/_tweaks-temp.scss
}

install_dracula() {
  sed -i "/\@import/s/color-palette-default/color-palette-dracula/" $SRC_DIR/_sass/_tweaks-temp.scss
  sed -i "/\$colorscheme:/s/default/dracula/" $SRC_DIR/_sass/_tweaks-temp.scss
}

activities_style() {
  sed -i "/\$activities:/s/normal/icon/" $SRC_DIR/_sass/_tweaks-temp.scss
}

gnome_version() {
  sed -i "/\$gnome_version:/s/old/new/" $SRC_DIR/_sass/_tweaks-temp.scss
}

accent_type() {
  sed -i "/\$accent_type:/s/default/fixed/" $SRC_DIR/_sass/_tweaks-temp.scss
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
    sed -i "/\$theme:/s/default/${theme_color}/" $SRC_DIR/_sass/_tweaks-temp.scss
  fi
}

theme_tweaks() {
  install_package; tweaks_temp

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

  if [[ "$activities" = "icon" ]] ; then
    activities_style
  fi

  if [[ "$GNOME_SHELL" = "true" && ("$GS_VERSION" = "47-0" || "$GS_VERSION" = "48-0") ]] ; then
    gnome_version
  fi

  if [[ "$fixed" = "true" || "$dracula" == "true" || "$nord" == "true" ]] ; then
    accent_type
  fi
}

backup_file() {
  if [[ -f "${1}.bak" || -d "${1}.bak" ]]; then
    case "${2}" in
      sudo)
        sudo rm -rf "${1}" ;;
      *)
        rm -rf "${1}" ;;
    esac
  fi

  if [[ -f "${1}" || -d "${1}" ]]; then
    case "${2}" in
      sudo)
        sudo mv -n "${1}"{"",".bak"} ;;
      *)
        mv -n "${1}"{"",".bak"} ;;
    esac
  fi
}

fix_dash_to_dock() {
  local DASH_TO_DOCK_DIR_ROOT="/usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
  local DASH_TO_DOCK_DIR_HOME="${MY_HOME}/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
  local UBUNTU_DOCK_DIR_ROOT="/usr/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com"
  local UBUNTU_DOCK_DIR_HOME="${MY_HOME}/.local/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com"

  if [[ -d "${DASH_TO_DOCK_DIR_HOME}" ]]; then
    backup_file "${DASH_TO_DOCK_DIR_HOME}/stylesheet.css"
  elif [[ -d "${DASH_TO_DOCK_DIR_ROOT}" ]]; then
    backup_file "${DASH_TO_DOCK_DIR_ROOT}/stylesheet.css" "sudo"
  fi

  if [[ -d "${UBUNTU_DOCK_DIR_HOME}" ]]; then
    backup_file "${UBUNTU_DOCK_DIR_HOME}/stylesheet.css"
  elif [[ -d "${UBUNTU_DOCK_DIR_ROOT}" ]]; then
    backup_file "${UBUNTU_DOCK_DIR_ROOT}/stylesheet.css" "sudo"
  fi

  if has_command dbus-launch; then
    dbus-launch dconf write /org/gnome/shell/extensions/dash-to-dock/apply-custom-theme true
  fi
}

install_theme() {
  check_shell

  for theme in "${themes[@]}"; do
    for color in "${colors[@]}"; do
      for size in "${sizes[@]}"; do
        install "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$theme" "$color" "$size" "$ctype" "$icon"
      done
    done
  done

  if (which xfce4-popup-whiskermenu 2> /dev/null) && $(sed -i "s|.*menu-opacity=.*|menu-opacity=0|" "$HOME/.config/xfce4/panel/whiskermenu"*".rc" &> /dev/null); then
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
    for color in "${COLOR_VARIANTS[@]}"; do
      for size in "${SIZE_VARIANTS[@]}"; do
        for scheme in '' '-Nord' '-Dracula'; do
          uninstall "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$theme" "$color" "$size" "$scheme"
        done
      done
    done
  done
}

clean_theme() {
  if [[ "$DEST_DIR" == "$HOME/.themes" ]]; then
    local dest="$HOME/.local/share/themes"

    for theme in "${themes[@]}"; do
      for color in "${colors[@]}"; do
        for size in "${sizes[@]}"; do
          uninstall "${dest}" "${_name:-$THEME_NAME}" "$theme" "$color" "$size" "$scheme"
        done
      done
    done
  fi
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
