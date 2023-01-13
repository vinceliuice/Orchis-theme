#! /usr/bin/env bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

./make-thumbnails.sh

for theme in '' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey'; do
  for type in '' '-Nord' '-Dracula'; do
    SRC_FILE="thumbnail${theme}${type}.svg"
    for color in '' '-Light' '-Dark'; do
            echo
            echo Rendering thumbnail${theme}${color}${type}.png
            $INKSCAPE --export-id=thumbnail${color} \
                      --export-id-only \
                      --export-dpi=96 \
                      --export-filename=thumbnail${theme}${color}${type}.png $SRC_FILE >/dev/null \
            && $OPTIPNG -o7 --quiet thumbnail${theme}${color}${type}.png
      done
    done
  done

for theme in '' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey'; do
  for type in '' '-Nord' '-Dracula'; do
    if [[ ${theme} == '' && ${type} == '' ]]; then
      echo "keep thumbnail.svg"
    else
      rm -rf "thumbnail${theme}${type}.svg"
    fi
  done
done

exit 0
