#!/bin/bash
set -ueo pipefail

if [[ ! "$(command -v sassc)" ]]; then
  echo "'sassc' needs to be installed to generate the CSS."
  exit 1
fi

SASSC_OPT=('-M' '-t' 'expanded')

_COLOR_VARIANTS=('' '-light' '-dark')
_GCOLOR_VARIANTS=('' '-dark')
_SIZE_VARIANTS=('' '-compact')
_THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-grey')

if [[ -n "${THEME_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _THEME_VARIANTS <<< "${THEME_VARIANTS:-}"
fi

if [[ -n "${COLOR_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

if [[ -n "${GCOLOR_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _GCOLOR_VARIANTS <<< "${GCOLOR_VARIANTS:-}"
fi

if [[ -n "${SIZE_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _SIZE_VARIANTS <<< "${SIZE_VARIANTS:-}"
fi

echo "== Generating the CSS..."

for theme in "${_THEME_VARIANTS[@]}"; do
for color in "${_COLOR_VARIANTS[@]}"; do
  for size in "${_SIZE_VARIANTS[@]}"; do
    sassc "${SASSC_OPT[@]}" "src/gtk/3.0/gtk$theme$color$size."{scss,css}
  done
done
done

for theme in "${_THEME_VARIANTS[@]}"; do
for color in "${_GCOLOR_VARIANTS[@]}"; do
  for size in "${_SIZE_VARIANTS[@]}"; do
    sassc "${SASSC_OPT[@]}" "src/gnome-shell/gnome-shell$theme$color$size."{scss,css}
  done
done
done

echo "== done!"
