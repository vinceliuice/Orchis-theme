#! /usr/bin/env bash

for theme in '' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-grey'; do
for color in '' '-dark'; do

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
      -orange)
        theme_color='#F57C00'
        ;;
      -yellow)
        theme_color='#FBC02D'
        ;;
      -green)
        theme_color='#4CAF50'
        ;;
      -grey)
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
      -orange)
        theme_color='#FB8C00'
        ;;
      -yellow)
        theme_color='#FFD600'
        ;;
      -green)
        theme_color='#66BB6A'
        ;;
      -grey)
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
