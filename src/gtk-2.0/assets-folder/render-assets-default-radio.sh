#! /usr/bin/env bash

RENDER_SVG="$(command -v rendersvg)" || true
INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true

INDEX="assets-default-radio.txt"

for color in '' '-dark'; do

ASSETS_DIR="assets-default-radio${color}"
SRC_FILE="assets-default-radio${color}.svg"

[[ -d $ASSETS_DIR ]] && rm -rf $ASSETS_DIR
mkdir -p $ASSETS_DIR

for i in `cat $INDEX`; do
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

done
done

echo -e "DONE!"
