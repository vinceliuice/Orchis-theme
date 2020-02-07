#!/bin/bash
set -ueo pipefail

RENDER_SVG="$(command -v rendersvg)" || true
INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true

if [[ "$1" == "dark" ]]; then
  SRC_FILE="assets-dark.svg"
  ASSETS_DIR="assets-dark"
else
  SRC_FILE="assets.svg"
  ASSETS_DIR="assets"
fi

i="$2"

# @TODO: remove $ZOOM when it will be fixed/implemented in resvg
GTK2_HIDPI="$(echo "${GTK2_HIDPI-False}" | tr '[:upper:]' '[:lower:]')"
if [[ "${GTK2_HIDPI}" == "true" ]]; then
  DPI=192
  ZOOM=2
else
  DPI=96
  ZOOM=1
fi

echo "Rendering '$ASSETS_DIR/$i.png'"
if [[ -n "${RENDER_SVG}" ]]; then
  # @TODO: remove --zoom when it will be fixed/implemented in resvg
  "$RENDER_SVG" --export-id "$i" \
                --dpi ${DPI} \
                --zoom ${ZOOM} \
                "$SRC_FILE" "$ASSETS_DIR/$i.png"
else
  "$INKSCAPE" --export-id="$i" \
              --export-id-only \
              --export-dpi=${DPI} \
              --export-png="$ASSETS_DIR/$i.png" "$SRC_FILE" >/dev/null
fi

if [[ -n "${OPTIPNG}" ]]; then
  "$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i.png"
fi
