#! /usr/bin/env bash

REPO_DIR="$(dirname "$(readlink -m "${0}")")"
source "${REPO_DIR}/core.sh"

usage() {
cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
  -n, --name NAME         Specify theme name (Default: $THEME_NAME)

  -t, --theme VARIANT     Specify theme color variant(s) [default|purple|pink|red|orange|yellow|green|teal|grey|all] (Default: blue)
  -c, --color VARIANT     Specify color variant(s) [standard|light|dark] (Default: All variants)s)
  -s, --size VARIANT      Specify size variant [standard|compact] (Default: All variants)

  -i, --icon VARIANT      Specify icon variant(s) for shell panel activities button
                          [default|apple|simple|gnome|ubuntu|arch|manjaro|fedora|debian|void|opensuse|popos|mxlinux|zorin|endeavouros|tux|nixos|gentoo|budgie|solus]
                          (Default: ChromeOS style)

  -l, --libadwaita        Link installed Orchis gtk-4.0 theme to config folder for all libadwaita app use Orchis theme
  -f, --fixed             Fixed accent(blue) color for gnome-shell >= 47 libadwaita theme

  --tweaks                Specify versions for tweaks [solid|compact|black|primary|macos|submenu|(nord/dracula)] (Options can mix)
                          1. solid              No transparency panel variant
                          2. compact            No floating panel variant
                          3. black              Full black variant
                          4. primary            Change radio icon checked color to primary theme color (Default is Green)
                          5. macos              Change window buttons to MacOS style
                          6. submenu            Set normal submenus color contrast (dark submenu style on dark version)
                          7. [nord|dracula]     Nord/dracula colorscheme themes (nord and dracula can not mix use!)
                          8. dock               Fix style for 'dash-to-dock' or 'ubuntu-dock' extension

  --round                 Change theme round corner border-radius [Input the px value you want] (Suggested: 2px < value < 16px)
                          1. 3px
                          2. 4px
                          3. 5px
                          ...
                          13. 15px

  --shell                 install gnome-shell version [38|40|42|44|46] (Without this option script will detect shell version and install the right theme)
                          1. 38                 Gnome-shell version <= 38.0
                          2. 40                 Gnome-shell version = 40.0
                          3. 42                 Gnome-shell version = 42.0
                          4. 44                 Gnome-shell version = 44.0
                          5. 46                 Gnome-shell version = 46.0
                          6. 47                 Gnome-shell version = 47.0
                          7. 48                 Gnome-shell version = 48.0

  -r, --remove,
  -u, --uninstall         Uninstall/Remove installed themes

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
    -f|--fixed)
      fixed="true"
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
      for shell in $@; do
        case "$shell" in
          38)
            shell="38"
            shift
            ;;
          40)
            shell="40"
            shift
            ;;
          42)
            shell="42"
            shift
            ;;
          44)
            shell="44"
            shift
            ;;
          46)
            shell="46"
            shift
            ;;
          47)
            shell="47"
            shift
            ;;
          48)
            shell="48"
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
          nord)
            nord="true"
            ctype="-Nord"
            echo -e "Install nord colorscheme ..."
            shift
            ;;
          dracula)
            dracula="true"
            ctype="-Dracula"
            echo -e "Install dracula colorscheme ..."
            shift
            ;;
          dock)
            dockfix="true"
            echo -e "\nFix 'dash-to-dock' or 'ubuntu-dock' style ..."
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
    -i|--icon)
      activities='icon'
      shift
      for icons in "$@"; do
        case "$icons" in
          default)
            icon='-default'
            shift
            ;;
          apple)
            icon='-apple'
            shift
            ;;
          simple)
            icon='-simple'
            shift
            ;;
          gnome)
            icon='-gnome'
            shift
            ;;
          ubuntu)
            icon='-ubuntu'
            shift
            ;;
          arch)
            icon='-arch'
            shift
            ;;
          manjaro)
            icon='-manjaro'
            shift
            ;;
          fedora)
            icon='-fedora'
            shift
            ;;
          debian)
            icon='-debian'
            shift
            ;;
          void)
            icon='-void'
            shift
            ;;
          opensuse)
            icon='-opensuse'
            shift
            ;;
          popos)
            icon='-popos'
            shift
            ;;
          mxlinux)
            icon='-mxlinux'
            shift
            ;;
          zorin)
            icon='-zorin'
            shift
            ;;
          endeavouros)
            icon='-endeavouros'
            shift
            ;;
          tux)
            icon='-tux'
            shift
            ;;
          nixos)
            icon='-nixos'
            shift
            ;;
          gentoo)
            icon='-gentoo'
            shift
            ;;
          budgie)
            icon='-budgie'
            shift
            ;;
          solus)
            icon='-solus'
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized icon variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
        echo "Install $icons icon for gnome-shell panel..."
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

if [[ "${#lcolors[@]}" -eq 0 ]] ; then
  lcolors=("${COLOR_VARIANTS[1]}")
fi

if [[ ${remove} == 'true' ]]; then
  if [[ "$libadwaita" == 'true' ]]; then
    uninstall_link
  elif [[ "$all" == 'true' ]]; then
    uninstall_theme && uninstall_link
  else
    uninstall_theme
  fi
else
  if [[ "$libadwaita" == 'true' && "$UID" == "$ROOT_UID" ]]; then
    echo -e "Do not run -l with sudo, that will link libadwaita theme to root folder !"
    exit 0
  fi

  clean_theme
  install_theme

  if [[ "$libadwaita" == 'true' && "$UID" != "$ROOT_UID" ]]; then
    link_theme
  fi

  if [[ "$dockfix" == 'true' ]]; then
    fix_dash_to_dock
  fi
fi

echo
echo "Done."
