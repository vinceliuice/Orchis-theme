#! /usr/bin/env bash

for theme in '' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey'; do
  for color in '' '-Dark'; do
      if [[ "$color" == '' ]]; then
        case "$theme" in
          '')
            theme_color='#1a73e8'
            ;;
          -Purple)
            theme_color='#AB47BC'
            ;;
          -Pink)
            theme_color='#EC407A'
            ;;
          -Red)
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
          -Teal)
            theme_color='#009688'
            ;;
          -Grey)
            theme_color='#464646'
            ;;
        esac
      else
        case "$theme" in
          '')
            theme_color='#3281ea'
            ;;
          -Purple)
            theme_color='#BA68C8'
            ;;
          -Pink)
            theme_color='#F06292'
            ;;
          -Red)
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
          -Teal)
            theme_color='#4DB6AC'
            ;;
          -Grey)
            theme_color='#DDDDDD'
            ;;
        esac
      fi

      if [[ "$theme" != '' ]]; then
        cp -r "assets${color}.svg" "assets${theme}${color}.svg"
        if [[ "$color" == '' ]]; then
          sed -i "s/#1a73e8/${theme_color}/g" "assets${theme}${color}.svg"
        else
          sed -i "s/#3281ea/${theme_color}/g" "assets${theme}${color}.svg"
        fi
      fi

  done
done

echo -e "DONE!"
