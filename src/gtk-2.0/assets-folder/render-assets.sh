#! /usr/bin/env bash

RENDER_SVG="$(command -v rendersvg)" || true
INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true

INDEX_COMMON="assets-common.txt"
INDEX_THEME="assets-theme.txt"

./make-assets.sh

for color in '' '-Dark'; do
  for type in '' '-Nord' '-Dracula'; do
    ASSETS_DIR="assets-common${color}${type}"
    SRC_FILE="assets-common${color}${type}.svg"

    # [[ -d $ASSETS_DIR ]] && rm -rf $ASSETS_DIR
    mkdir -p $ASSETS_DIR

    for i in `cat $INDEX_COMMON`; do
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

for theme in '' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey'; do
  for color in '' '-Dark'; do
    for type in '' '-Nord' '-Dracula'; do
      ASSETS_DIR="assets${theme}${color}${type}"
      SRC_FILE="assets${theme}${color}${type}.svg"

      # [[ -d $ASSETS_DIR ]] && rm -rf $ASSETS_DIR
      mkdir -p $ASSETS_DIR

      for i in `cat $INDEX_THEME`; do
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
done

for theme in '' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey'; do
  for color in '' '-Dark'; do
    for type in '' '-Nord' '-Dracula'; do
      if [[ "${theme}" == '' && "${type}" == '' ]]; then
        echo "keep assets${color}.svg file..."
      else
        rm -rf "assets${theme}${color}${type}.svg"
      fi
    done
  done
done

for color in '' '-Dark'; do
  for type in '-Nord' '-Dracula'; do
    rm -rf "assets-common${color}${type}.svg"
  done
done
echo -e "DONE!"
