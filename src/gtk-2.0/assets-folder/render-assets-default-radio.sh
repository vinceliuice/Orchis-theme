#! /usr/bin/env bash

RENDER_SVG="$(command -v rendersvg)" || true
INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true

INDEX="assets-default-radio.txt"

for color in '' '-Dark'; do
  for type in '' '-Nord' '-Dracula'; do

    ASSETS_DIR="assets-default-radio${color}${type}"
    SRC_FILE="assets-default-radio${color}${type}.svg"

    # [[ -d $ASSETS_DIR ]] && rm -rf $ASSETS_DIR
    mkdir -p $ASSETS_DIR

    if [[ "$type" == '-Nord' ]]; then
      assets_color_light='#8bd9b4'
      assets_color_dark='#60a684'
    elif [[ "$type" == '-Dracula' ]]; then
      assets_color_light='#66ffb5'
      assets_color_dark='#48db94'
    fi

    if [[ "$type" != '' ]]; then
      cp -r "assets-default-radio${color}.svg" "assets-default-radio${color}${type}.svg"
      if [[ "$color" == '' ]]; then
        sed -i "s/#0F9D58/${assets_color_light}/g" "assets-default-radio${color}${type}.svg"
      else
        sed -i "s/#81C995/${assets_color_dark}/g" "assets-default-radio${color}${type}.svg"
      fi
    fi

    for i in `cat $INDEX`; do
      if [[ -f "$ASSETS_DIR/$i.png" ]]; then
        echo "'$ASSETS_DIR/$i.png' exists."
      else
        echo "Rendering '$ASSETS_DIR/$i.png'"
        if [[ -n "${RENDER_SVG}" ]]; then
          "$RENDER_SVG" --export-id "$i" \
                        "$SRC_FILE" "$ASSETS_DIR/$i.png"
        else
          "$INKSCAPE" --export-id="$i" \
                      --export-id-only \
                      --export-filename="$ASSETS_DIR/$i.png" "$SRC_FILE" >/dev/null
        fi
        if [[ -n "${OPTIPNG}" ]]; then
          "$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i.png"
        fi
      fi
    done
  done
done

for color in '' '-Dark'; do
  for type in '-Nord' '-Dracula'; do
    ASSETS_FILE="assets-default-radio${color}${type}.svg"
    rm -rf "${ASSETS_FILE}"
  done
done

echo -e "DONE!"
