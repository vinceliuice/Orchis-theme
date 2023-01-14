#! /usr/bin/env bash

for theme in '' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey'; do
  for color in '' '-Dark'; do
    for type in '' '-Nord' '-Dracula'; do
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

        if [[ "$type" == '-Nord' ]]; then
          background_color='#f0f1f4'
          base_color='#f8fafc'

          case "$theme" in
            '')
              theme_color='#5e81ac'
              ;;
            -Purple)
              theme_color='#b57daa'
              ;;
            -Pink)
              theme_color='#cd7092'
              ;;
            -Red)
              theme_color='#c35b65'
              ;;
            -Orange)
              theme_color='#d0846c'
              ;;
            -Yellow)
              theme_color='#e4b558'
              ;;
            -Green)
              theme_color='#82ac5d'
              ;;
            -Teal)
              theme_color='#83b9b8'
              ;;
            -Grey)
              theme_color='#3a4150'
              ;;
          esac
        fi

        if [[ "$type" == '-Dracula' ]]; then
          background_color='#f0f1f4'
          base_color='#f9f9fb'

          case "$theme" in
            '')
              theme_color='#5d70ac'
              ;;
            -Purple)
              theme_color='#a679ec'
              ;;
            -Pink)
              theme_color='#f04cab'
              ;;
            -Red)
              theme_color='#f44d4d'
              ;;
            -Orange)
              theme_color='#f8a854'
              ;;
            -Yellow)
              theme_color='#e8f467'
              ;;
            -Green)
              theme_color='#4be772'
              ;;
            -Teal)
              theme_color='#20eed9'
              ;;
            -Grey)
              theme_color='#3c3f51'
              ;;
          esac
        fi
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

        if [[ "$type" == '-Nord' ]]; then
          background_color='#1c1f26'
          base_color='#242932'

          case "$theme" in
            '')
              theme_color='#89a3c2'
              ;;
            -Purple)
              theme_color='#c89dbf'
              ;;
            -Pink)
              theme_color='#dc98b1'
              ;;
            -Red)
              theme_color='#d4878f'
              ;;
            -Orange)
              theme_color='#dca493'
              ;;
            -Yellow)
              theme_color='#eac985'
              ;;
            -Green)
              theme_color='#a0c082'
              ;;
            -Teal)
              theme_color='#83b9b8'
              ;;
            -Grey)
              theme_color='#d9dce3'
              ;;
          esac
        fi

        if [[ "$type" == '-Dracula' ]]; then
          background_color='#1c1e26'
          base_color='#242632'

          case "$theme" in
            '')
              theme_color='#6272a4'
              ;;
            -Purple)
              theme_color='#bd93f9'
              ;;
            -Pink)
              theme_color='#ff79c6'
              ;;
            -Red)
              theme_color='#ff5555'
              ;;
            -Orange)
              theme_color='#ffb86c'
              ;;
            -Yellow)
              theme_color='#f1fa8c'
              ;;
            -Green)
              theme_color='#50fa7b'
              ;;
            -Teal)
              theme_color='#50fae9'
              ;;
            -Grey)
              theme_color='#d9dae3'
              ;;
          esac
        fi
      fi

      if [[ "$type" != '' ]]; then
        cp -r "assets${color}.svg" "assets${theme}${color}${type}.svg"
        if [[ "$color" == '' ]]; then
          sed -i "s/#1a73e8/${theme_color}/g" "assets${theme}${color}${type}.svg"
        else
          sed -i "s/#3281ea/${theme_color}/g" "assets${theme}${color}${type}.svg"
        fi
        cp -r "assets-common${color}.svg" "assets-common${color}${type}.svg"
        if [[ "$color" == '-Dark' ]]; then
          sed -i "s/#212121/${background_color}/g" "assets-common${color}${type}.svg"
          sed -i "s/#2C2C2C/${base_color}/g" "assets-common${color}${type}.svg"
        else
          sed -i "s/#F2F2F2/${background_color}/g" "assets-common${color}${type}.svg"
          sed -i "s/#FFFFFF/${base_color}/g" "assets-common${color}${type}.svg"
        fi
      elif [[ "$theme" != '' ]]; then
        cp -r "assets${color}.svg" "assets${theme}${color}.svg"
        if [[ "$color" == '' ]]; then
          sed -i "s/#1a73e8/${theme_color}/g" "assets${theme}${color}.svg"
        else
          sed -i "s/#3281ea/${theme_color}/g" "assets${theme}${color}.svg"
        fi
      fi
    done
  done
done

echo -e "DONE!"
