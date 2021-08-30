#! /bin/bash

THEME_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=Orchis

_COLOR_VARIANTS=('' '-light' '-dark')
_COMPA_VARIANTS=('' '-compact')
_THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-grey')

if [ ! -z "${COMPA_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _COMPA_VARIANTS <<< "${COMPA_VARIANTS:-}"
fi

if [ ! -z "${COLOR_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

if [ ! -z "${THEME_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _THEME_VARIANTS <<< "${THEME_VARIANTS:-}"
fi

Tar_themes() {
for theme in "${_THEME_VARIANTS[@]}"; do
  rm -rf ${THEME_NAME}${theme}.tar.xz
done

for theme in "${_THEME_VARIANTS[@]}"; do
  tar -Jcvf ${THEME_NAME}${theme}.tar.xz ${THEME_NAME}${theme} ${THEME_NAME}${theme}-compact ${THEME_NAME}${theme}{-light,-dark} ${THEME_NAME}${theme}{-light,-dark}-compact
done
}

Clear_theme() {
for theme in "${_THEME_VARIANTS[@]}"; do
  for color in "${_COLOR_VARIANTS[@]}"; do
    for compact in "${_COMPA_VARIANTS[@]}"; do
      [[ -d "${THEME_NAME}${theme}${color}${compact}" ]] && rm -rf "${THEME_NAME}${theme}${color}${compact}"
    done
  done
done
}

cd ..


./install.sh -t all -d $THEME_DIR

cd $THEME_DIR && Tar_themes && Clear_theme

