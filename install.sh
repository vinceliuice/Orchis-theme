#! /usr/bin/env bash

REPO_DIR="$(dirname "$(readlink -m "${0}")")"
source "${REPO_DIR}/core.sh"

usage() {
cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
  -n, --name NAME         Specify theme name (Default: $THEME_NAME)

  -t, --theme VARIANT     Specify theme color variant(s) [default|purple|pink|red|orange|yellow|green|teal|grey|nord|all] (Default: blue)
  -c, --color VARIANT     Specify color variant(s) [standard|light|dark] (Default: All variants)s)
  -s, --size VARIANT      Specify size variant [standard|compact] (Default: All variants)

  -l, --libadwaita        Link installed Orchis gtk-4.0 theme to config folder for all libadwaita app use Orchis theme

  --round                 Change theme round corner border-radius [Input the px value you want] (Suggested: 2px < value < 16px)

  -r, --remove,
  -u, --uninstall         Uninstall/Remove installed themes

  --tweaks                Specify versions for tweaks [solid|compact|black|primary] (Options can mix)
                          1. solid:    No transparency panel variant
                          2. compact:  No floating panel variant
                          3. black:    Full black variant
                          4. primary:  Change radio icon checked color to primary theme color (Default is Green)
                          5. macos:    Change window buttons to MacOS style
                          6. submenu:  Theme sub-menus, by Default submenus contrast

  --shell                 install gnome-shell version [38|40|42]
                          1. 38:       Gnome-shell version < 40.0
                          2. 40:       Gnome-shell version = 40.0
                          3. 42:       Gnome-shell version >= 42.0

  -h, --help              Show help
EOF
}

themes=()
colors=()
sizes=()
othemes=()
ocolors=()
osizes=()
lcolors=()

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
    -r|--remove|-u|--uninstall)
      remove="true"
      shift
      ;;
    -l|--libadwaita)
      libadwaita="true"
      shift
      ;;
    --round)
      round="true"
      corner="$2"
      echo -e "Change round corner ${corner} value ..."
      shift 2
      ;;
    --shell)
      shift
      for variant in $@; do
        case "$variant" in
          38)
            shell="32-8"
            shift
            ;;
          40)
            shell="40-0"
            shift
            ;;
          42)
            shell="42-0"
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized shell variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    --tweaks)
      shift
      for variant in $@; do
        case "$variant" in
          solid)
            opacity="solid"
            echo -e "Install solid version ..."
            shift
            ;;
          compact)
            panel="compact"
            echo -e "Install compact panel version ..."
            shift
            ;;
          black)
            blackness="true"
            echo -e "Install black version ..."
            shift
            ;;
          primary)
            primary="true"
            echo "Change radio and check assets color ..."
            shift
            ;;
          macos)
            macstyle="true"
            echo -e "Install MacOS style window button version ..."
            shift
            ;;
          submenu)
            submenu="true"
            echo -e "Install with themed sub-menus ..."
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized tweaks variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -t|--theme)
      accent='true'
      shift
      for variant in "$@"; do
        case "$variant" in
          default)
            themes+=("${THEME_VARIANTS[0]}")
            shift
            ;;
          purple)
            themes+=("${THEME_VARIANTS[1]}")
            shift
            ;;
          pink)
            themes+=("${THEME_VARIANTS[2]}")
            shift
            ;;
          red)
            themes+=("${THEME_VARIANTS[3]}")
            shift
            ;;
          orange)
            themes+=("${THEME_VARIANTS[4]}")
            shift
            ;;
          yellow)
            themes+=("${THEME_VARIANTS[5]}")
            shift
            ;;
          green)
            themes+=("${THEME_VARIANTS[6]}")
            shift
            ;;
          teal)
            themes+=("${THEME_VARIANTS[7]}")
            shift
            ;;
          grey)
            themes+=("${THEME_VARIANTS[8]}")
            shift
            ;;
          nord)
            themes+=("${THEME_VARIANTS[9]}")
            shift
            ;;
          all)
            themes+=("${THEME_VARIANTS[@]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized theme variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -c|--color)
      shift
      for variant in "$@"; do
        case "$variant" in
          standard)
            colors+=("${COLOR_VARIANTS[0]}")
            lcolors+=("${COLOR_VARIANTS[0]}")
            shift
            ;;
          light)
            colors+=("${COLOR_VARIANTS[1]}")
            lcolors+=("${COLOR_VARIANTS[1]}")
            shift
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[2]}")
            lcolors+=("${COLOR_VARIANTS[2]}")
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
    -s|--size)
      shift
      for variant in "$@"; do
        case "$variant" in
          standard)
            sizes+=("${SIZE_VARIANTS[0]}")
            shift
            ;;
          compact)
            sizes+=("${SIZE_VARIANTS[1]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized size variant '$1'."
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
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${#themes[@]}" -eq 0 ]] ; then
  themes=("${THEME_VARIANTS[0]}")
fi

if [[ "${#colors[@]}" -eq 0 ]] ; then
  colors=("${COLOR_VARIANTS[@]}")
fi

if [[ "${#sizes[@]}" -eq 0 ]] ; then
  sizes=("${SIZE_VARIANTS[@]}")
fi

if [[ "${#othemes[@]}" -eq 0 ]] ; then
  othemes=("${OLD_THEME_VARIANTS[@]}")
fi

if [[ "${#ocolors[@]}" -eq 0 ]] ; then
  ocolors=("${OLD_COLOR_VARIANTS[@]}")
fi

if [[ "${#osizes[@]}" -eq 0 ]] ; then
  osizes=("${OLD_SIZE_VARIANTS[@]}")
fi

if [[ "${#lcolors[@]}" -eq 0 ]] ; then
  lcolors=("${COLOR_VARIANTS[1]}")
fi

clean_theme

if [[ ${remove} == 'true' ]]; then
  if [[ "$libadwaita" == 'true' ]]; then
    uninstall_link
  elif [[ "$all" == 'true' ]]; then
    uninstall_theme && uninstall_link
  else
    uninstall_theme
  fi
else
  install_theme

  if [[ "$libadwaita" == 'true' ]]; then
    link_theme
  fi
fi

echo
echo "Done."
