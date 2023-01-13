#! /usr/bin/env bash

RENDER_SVG="$(command -v rendersvg)" || true
INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true

INDEX="assets.txt"

./make-assets.sh

for theme in '' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey'; do
  for type in '' '-Nord' '-Dracula'; do
    ASSETS_DIR="assets${theme}${type}"
    SRC_FILE="assets${theme}${type}.svg"

    #[[ -d $ASSETS_DIR ]] && rm -rf $ASSETS_DIR
    mkdir -p $ASSETS_DIR

    for i in `cat $INDEX`; do
    echo "Rendering '$ASSETS_DIR/$i.png'"

    if [[ -f "$ASSETS_DIR/$i.png" ]]; then
      echo "'$ASSETS_DIR/$i.png' exists."
    elif [[ -n "${RENDER_SVG}" ]]; then
      "$RENDER_SVG" --export-id "$i" \
                    "$SRC_FILE" "$ASSETS_DIR/$i.png"
    else
      "$INKSCAPE" --export-id="$i" \
                  --export-id-only \
                  --export-filename="$ASSETS_DIR/$i.png" "$SRC_FILE" >/dev/null
      if [[ -n "${OPTIPNG}" ]]; then
        "$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i.png"
      fi
    fi

    echo "Rendering '$ASSETS_DIR/$i@2.png'"

    if [[ -f "$ASSETS_DIR/$i@2.png" ]]; then
      echo "'$ASSETS_DIR/$i@2.png' exists."
    elif [[ -n "${RENDER_SVG}" ]]; then
      "$RENDER_SVG" --export-id "$i" \
                    --dpi 192 \
                    --zoom 2 \
                    "$SRC_FILE" "$ASSETS_DIR/$i@2.png"
    else
      "$INKSCAPE" --export-id="$i" \
                  --export-id-only \
                  --export-dpi=192 \
                  --export-filename="$ASSETS_DIR/$i@2.png" "$SRC_FILE" >/dev/null
      if [[ -n "${OPTIPNG}" ]]; then
        "$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i@2.png"
      fi
    fi

    done
  done
done

for theme in '' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey'; do
  for type in '' '-Nord' '-Dracula'; do
    if [[ "${theme}" == '' && "${type}" == '' ]]; then
      echo "keep assets.svg file..."
    else
      ASSETS_FILE="assets${theme}${type}.svg"
      rm -rf "${ASSETS_FILE}"
    fi
  done
done

echo -e "DONE!"
