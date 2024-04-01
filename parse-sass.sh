#!/bin/bash

if [[ ! "$(command -v sassc)" ]]; then
  echo "'sassc' needs to be installed to generate the CSS."
  exit 1
fi

SASSC_OPT=('-M' '-t' 'expanded')

_COLOR_VARIANTS=('' '-Light' '-Dark')
_GCOLOR_VARIANTS=('' '-Dark')
_SIZE_VARIANTS=('' '-Compact')

if [[ -n "${COLOR_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

if [[ -n "${GCOLOR_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _GCOLOR_VARIANTS <<< "${GCOLOR_VARIANTS:-}"
fi

if [[ -n "${SIZE_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _SIZE_VARIANTS <<< "${SIZE_VARIANTS:-}"
fi

cp -rf src/_sass/_tweaks.scss src/_sass/_tweaks-temp.scss

echo "== Generating the CSS..."

for color in "${_COLOR_VARIANTS[@]}"; do
  for size in "${_SIZE_VARIANTS[@]}"; do
    sassc "${SASSC_OPT[@]}" "src/gtk/3.0/gtk$color$size."{scss,css}
    sassc "${SASSC_OPT[@]}" "src/gtk/4.0/gtk$color$size."{scss,css}
  done
done

for color in "${_GCOLOR_VARIANTS[@]}"; do
  for size in "${_SIZE_VARIANTS[@]}"; do
    sassc "${SASSC_OPT[@]}" "src/gnome-shell/shell-3-28/gnome-shell$color$size."{scss,css}
    sassc "${SASSC_OPT[@]}" "src/gnome-shell/shell-40-0/gnome-shell$color$size."{scss,css}
    sassc "${SASSC_OPT[@]}" "src/gnome-shell/shell-42-0/gnome-shell$color$size."{scss,css}
    sassc "${SASSC_OPT[@]}" "src/gnome-shell/shell-44-0/gnome-shell$color$size."{scss,css}
    sassc "${SASSC_OPT[@]}" "src/gnome-shell/shell-46-0/gnome-shell$color$size."{scss,css}
    sassc "${SASSC_OPT[@]}" "src/cinnamon/cinnamon$color$size."{scss,css}
  done
done

echo "== done!"
