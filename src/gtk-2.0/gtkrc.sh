make_gtkrc() {
  local theme="${1}"
  local color="${2}"

  if [[ "${color}" != '-Dark' ]]; then
    case "$theme" in
      '')
        theme_color='#1A73E8'
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
        theme_color='#3281EA'
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

#  if [[ "$blackness" == 'true' ]]; then
#        background_light='#FFFFFF'
#        background_dark='#0F0F0F'
#        background_darker='#121212'
#        background_alt='#212121'
#        titlebar_light='#F2F2F2'
#        titlebar_dark='#030303'
#  else
#        background_light='#FFFFFF'
#        background_dark='#2C2C2C'
#        background_darker='#3C3C3C'
#        background_alt='#464646'
#        titlebar_light='#F2F2F2'
#        titlebar_dark='#242424'
#  fi

  if [[ "$theme" != '' ]]; then
    rm -rf "gtkrc${theme}${color}"
    cp -rf "gtkrc${color}" "gtkrc${theme}${color}"

    if [[ "${color}" == '-Dark' ]]; then
      sed -i "s/#3281EA/${theme_color}/g"                                         "gtkrc${theme}${color}"
#       sed -i "s/#3C3C3C/${background_darker}/g"                                   "gtkrc${theme}${color}"
#       sed -i "s/#242424/${titlebar_dark}/g"                                       "gtkrc${theme}${color}"
    else
      sed -i "s/#1A73E8/${theme_color}/g"                                         "gtkrc${theme}${color}"
#       sed -i "s/#F2F2F2/${titlebar_light}/g"                                      "gtkrc${theme}${color}"
    fi
  fi

#  sed -i "s/#FFFFFF/${background_light}/g"                                      "gtkrc${theme}${color}"
#  sed -i "s/#2C2C2C/${background_dark}/g"                                       "gtkrc${theme}${color}"
#  sed -i "s/#464646/${background_alt}/g"                                        "gtkrc${theme}${color}"
}

for theme in '' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey'; do
  for color in '' '-Dark'; do
    make_gtkrc "${theme}" "${color}"
  done
done
