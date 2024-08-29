#! /usr/bin/env bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

svg_main() {
  local color="${1}"
  local style="${2}"
  local screen="${3}"

  local SRC_FILE="assets-${type}${color}${style}.svg"
  local ASSETS_DIR="${type}/assets${color}${style}${screen}"

  case "${screen}" in
    -hdpi)
      DPI='144'
      ;;
    -xhdpi)
      DPI='192'
      ;;
    *)
      DPI='96'
      ;;
  esac

  mkdir -p "$ASSETS_DIR"

  if [[ -f "$ASSETS_DIR/$i.svg" ]]; then
    echo -e "$ASSETS_DIR/$i.svg exists."
  else
    echo
    echo -e "Rendering $ASSETS_DIR/$i.svg"
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-dpi=$DPI \
              --export-filename=$ASSETS_DIR/$i.svg $SRC_FILE >/dev/null
    # $OPTIPNG -o7 --quiet "$ASSETS_DIR/$i.svg"
    svgo "$ASSETS_DIR/$i.svg"
  fi

  (
  cd $ASSETS_DIR
  ln -sf title.svg title-1-active.svg
  ln -sf title.svg title-2-active.svg
  ln -sf title.svg title-3-active.svg
  ln -sf title.svg title-4-active.svg
  ln -sf title.svg title-5-active.svg
  ln -sf title.svg title-1-inactive.svg
  ln -sf title.svg title-2-inactive.svg
  ln -sf title.svg title-3-inactive.svg
  ln -sf title.svg title-4-inactive.svg
  ln -sf title.svg title-5-inactive.svg
  ln -sf top-left-active.svg top-left-inactive.svg
  ln -sf top-right-active.svg top-right-inactive.svg
  )
}

xpm_main() {
  local screen="${1}"

  local SRC_FILE="assets-${type}.svg"
  local ASSETS_DIR="${type}/assets${screen}"

  case "${screen}" in
    -hdpi)
      DPI='144'
      ;;
    -xhdpi)
      DPI='192'
      ;;
    *)
      DPI='96'
      ;;
  esac

  mkdir -p "$ASSETS_DIR"

  if [[ -f "$ASSETS_DIR/$i.xpm" ]]; then
    echo -e "$ASSETS_DIR/$i.xpm exists."
  else
    echo
    echo -e "Rendering $ASSETS_DIR/$i.xpm"
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-dpi=$DPI \
              --export-filename=$ASSETS_DIR/$i.png $SRC_FILE >/dev/null
    magick "$ASSETS_DIR/$i.png" "$ASSETS_DIR/$i.xpm"
    sed -i "s/c #2C2C2C/c #2C2C2C s active_color_2/g" "$ASSETS_DIR/$i.xpm"
    sed -i "s/c gray20/c gray20 s inactive_color_1/g" "$ASSETS_DIR/$i.xpm"
    rm -rf $ASSETS_DIR/$i.png
  fi

  (
  cd $ASSETS_DIR
  ln -sf button-active.xpm close-active.xpm
  ln -sf button-active.xpm close-prelight.xpm
  ln -sf button-active.xpm close-pressed.xpm
  ln -sf button-inactive.xpm close-inactive.xpm
  ln -sf button-active.xpm hide-active.xpm
  ln -sf button-active.xpm hide-prelight.xpm
  ln -sf button-active.xpm hide-pressed.xpm
  ln -sf button-inactive.xpm hide-inactive.xpm
  ln -sf button-active.xpm maximize-active.xpm
  ln -sf button-active.xpm maximize-prelight.xpm
  ln -sf button-active.xpm maximize-pressed.xpm
  ln -sf button-inactive.xpm maximize-inactive.xpm
  ln -sf button-active.xpm maximize-toggled-active.xpm
  ln -sf button-active.xpm maximize-toggled-prelight.xpm
  ln -sf button-active.xpm maximize-toggled-pressed.xpm
  ln -sf button-inactive.xpm maximize-toggled-inactive.xpm
  ln -sf button-active.xpm shade-active.xpm
  ln -sf button-active.xpm shade-prelight.xpm
  ln -sf button-active.xpm shade-pressed.xpm
  ln -sf button-inactive.xpm shade-inactive.xpm
  ln -sf button-active.xpm shade-toggled-active.xpm
  ln -sf button-active.xpm shade-toggled-prelight.xpm
  ln -sf button-active.xpm shade-toggled-pressed.xpm
  ln -sf button-inactive.xpm shade-toggled-inactive.xpm
  ln -sf button-active.xpm stick-active.xpm
  ln -sf button-active.xpm stick-prelight.xpm
  ln -sf button-active.xpm stick-pressed.xpm
  ln -sf button-inactive.xpm stick-inactive.xpm
  ln -sf button-active.xpm stick-toggled-active.xpm
  ln -sf button-active.xpm stick-toggled-prelight.xpm
  ln -sf button-active.xpm stick-toggled-pressed.xpm
  ln -sf button-inactive.xpm stick-toggled-inactive.xpm
  ln -sf button-active.xpm menu-active.xpm
  ln -sf button-active.xpm menu-prelight.xpm
  ln -sf button-active.xpm menu-pressed.xpm
  ln -sf button-inactive.xpm menu-inactive.xpm
  ln -sf title-active.xpm title-1-active.xpm
  ln -sf title-active.xpm title-2-active.xpm
  ln -sf title-active.xpm title-3-active.xpm
  ln -sf title-active.xpm title-4-active.xpm
  ln -sf title-active.xpm title-5-active.xpm
  ln -sf title-inactive.xpm title-1-inactive.xpm
  ln -sf title-inactive.xpm title-2-inactive.xpm
  ln -sf title-inactive.xpm title-3-inactive.xpm
  ln -sf title-inactive.xpm title-4-inactive.xpm
  ln -sf title-inactive.xpm title-5-inactive.xpm
  ln -sf left-active.xpm right-active.xpm
  ln -sf left-inactive.xpm right-inactive.xpm
  )
}

make_svg() {
  local type="svg"
  local INDEX="assets-${type}.txt"

  for i in `cat $INDEX`; do
    for color in '' '-Light'; do
      for style in '' '-mac'; do
        for screen in '' '-hdpi' '-xhdpi'; do
          svg_main "${color}" "${style}" "${screen}"
        done
      done
    done
  done
}

make_xpm() {
  local type="xpm"
  local INDEX="assets-${type}.txt"

  for i in `cat $INDEX`; do
    for screen in '' '-hdpi' '-xhdpi'; do
      xpm_main "${screen}"
    done
  done
}

make_svg && make_xpm

