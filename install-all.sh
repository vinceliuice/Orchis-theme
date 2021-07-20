#! /usr/bin/env bash

REPO_DIR="$(dirname "$(readlink -m "${0}")")"
source "${REPO_DIR}/core.sh"

usage() {
  cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
  -n, --name NAME         Specify theme name (Default: $THEME_NAME)
  -c, --color VARIANT...  Specify color variant(s) [standard|light|dark] (Default: All variants)s)
  -s, --size VARIANT      Specify size variant [standard|compact] (Default: All variants)
  --tweaks                Specify versions for tweaks [solid|compact|black|primary] (Options can mix)
                          1. solid:    no transparency panel variant
                          2. compact:  no floating panel variant
                          3. black:    full black variant
                          4. primary:  Change radio icon checked color to primary theme color (Default is Green)
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

themes=()
themecolors=()
colors=()
sizes=()

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
    --tweaks)
      shift
      for variant in $@; do
        case "$variant" in
          solid)
            opacity="solid"
            shift
            ;;
          compact)
            panel="compact"
            shift
            ;;
          black)
            blackness="true"
            shift
            ;;
          primary)
            primary="true"
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
            echo "ERROR: Unrecognized size variant '${1:-}'."
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

if [[ "${#themecolors[@]}" -eq 0 ]] ; then
  themecolors=("${THEME_COLORS[@]}")
fi

if [[ "${#colors[@]}" -eq 0 ]] ; then
  colors=("${COLOR_VARIANTS[@]}")
fi

if [[ "${#sizes[@]}" -eq 0 ]] ; then
  sizes=("${SIZE_VARIANTS[@]}")
fi

install_all_color() {
  for theme_color in "${themecolors[@]}"; do
    if [[ "$theme_color" != "default" ]]; then
      accent='true'
    fi

    tweaks_temp; install_theme_color "$theme_color"
    customize_theme

    case "$theme_color" in
      default)
        theme=("${THEME_VARIANTS[0]}")
        shift
        ;;
      purple)
        theme=("${THEME_VARIANTS[1]}")
        shift
        ;;
      pink)
        theme=("${THEME_VARIANTS[2]}")
        shift
        ;;
      red)
        theme=("${THEME_VARIANTS[3]}")
        shift
        ;;
      orange)
        theme=("${THEME_VARIANTS[4]}")
        shift
        ;;
      yellow)
        theme=("${THEME_VARIANTS[5]}")
        shift
        ;;
      green)
        theme=("${THEME_VARIANTS[6]}")
        shift
        ;;
      grey)
        theme=("${THEME_VARIANTS[7]}")
        shift
        ;;
    esac

    for color in "${colors[@]}"; do
      for size in "${sizes[@]}"; do
        install "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$theme" "$color" "$size"
      done
    done
  done
}

install_all_color "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$theme" "$color" "$size"
