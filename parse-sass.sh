#!/bin/bash
set -ueo pipefail

if [[ ! "$(command -v sassc)" ]]; then
  echo "'sassc' needs to be installed to generate the CSS."
  exit 1
fi

SASSC_OPT=('-M' '-t' 'expanded')

_COLOR_VARIANTS=('' '-dark')

if [[ -n "${COLOR_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

echo "== Generating the CSS..."

for color in "${_COLOR_VARIANTS[@]}"; do
  sassc "${SASSC_OPT[@]}" "src/gtk/3.0/gtk$color."{scss,css}
  sassc "${SASSC_OPT[@]}" "src/gnome-shell/gnome-shell$color."{scss,css}
done
