#! /usr/bin/env bash

for theme in '' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Grey'; do
for color in '' '-Dark'; do

  if [[ "$color" == '' ]]; then
    case "$theme" in
      -purple)
        theme_color='#AB47BC'
        ;;
      -pink)
        theme_color='#EC407A'
        ;;
      -red)
        theme_color='#E53935'
        ;;
      -Orange)
        theme_color='#F57C00'
        ;;
      -Yellow)
        theme_color='#FBC02D'
        ;;
      -Green)
        theme_color='#4CAF50'
        ;;
      -Grey)
        theme_color='#616161'
        ;;
    esac
  else
    case "$theme" in
      -purple)
        theme_color='#BA68C8'
        ;;
      -pink)
        theme_color='#F06292'
        ;;
      -red)
        theme_color='#F44336'
        ;;
      -Orange)
        theme_color='#FB8C00'
        ;;
      -Yellow)
        theme_color='#FFD600'
        ;;
      -Green)
        theme_color='#66BB6A'
        ;;
      -Grey)
        theme_color='#757575'
        ;;
    esac
  fi

  if [[ "$theme" != '' ]]; then
    cp -rf "assets${color}.svg" "assets${theme}${color}.svg"
    if [[ "$color" == '' ]]; then
      sed -i "s/#1A73E8/${theme_color}/g" "assets${theme}${color}.svg"
    else
      sed -i "s/#3281ea/${theme_color}/g" "assets${theme}${color}.svg"
    fi
  fi
done
done

echo -e "DONE!"
