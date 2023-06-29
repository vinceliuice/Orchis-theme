make_gtkrc() {
  local GTKRC_DIR="${SRC_DIR}/gtk-2.0"

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

    if [[ "$ctype" == '-Nord' ]]; then
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

    if [[ "$ctype" == '-Dracula' ]]; then
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

    if [[ "$ctype" == '-Nord' ]]; then
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

    if [[ "$ctype" == '-Dracula' ]]; then
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

  if [[ "$blackness" == 'true' ]]; then
    case "$ctype" in
      '')
        background_light='#F2F2F2'
        background_dark='#000000'
        base_light='#FFFFFF'
        base_dark='#0F0F0F'
        titlebar_light='#FFFFFF'
        titlebar_dark='#0F0F0F'
        menu_light='#FFFFFF'
        menu_dark='#121212'
        text_light='#212121'
        text_dark='#FFFFFF'
        tooltip_bg='#2C2C2C'
        ;;
      -Nord)
        background_light='#f0f1f4'
        background_dark='#000000'
        base_light='#f8fafc'
        base_dark='#0d0e11'
        titlebar_light='#f8fafc'
        titlebar_dark='#0d0e11'
        menu_light='#f8fafc'
        menu_dark='#0f1115'
        text_light='#1c1f26'
        text_dark='#f8fafc'
        tooltip_bg='#242932'
        ;;
      -Dracula)
        background_light='#f0f1f4'
        background_dark='#000000'
        base_light='#f9f9fb'
        base_dark='#0d0d11'
        titlebar_light='#f9f9fb'
        titlebar_dark='#0d0d11'
        menu_light='#f9f9fb'
        menu_dark='#0f1015'
        text_light='#1c1e26'
        text_dark='#f9f9fb'
        tooltip_bg='#242632'
        ;;
    esac
  else
    case "$ctype" in
      '')
        background_light='#F2F2F2'
        background_dark='#212121'
        base_light='#FFFFFF'
        base_dark='#2C2C2C'
        titlebar_light='#FFFFFF'
        titlebar_dark='#2C2C2C'
        menu_light='#FFFFFF'
        menu_dark='#3C3C3C'
        text_light='#212121'
        text_dark='#FFFFFF'
        tooltip_bg='#616161'
        ;;
      -Nord)
        background_light='#f0f1f4'
        background_dark='#1c1f26'
        base_light='#f8fafc'
        base_dark='#242932'
        titlebar_light='#f8fafc'
        titlebar_dark='#242932'
        menu_light='#f8fafc'
        menu_dark='#333a47'
        text_light='#1c1f26'
        text_dark='#f8fafc'
        tooltip_bg='#464f62'
        ;;
      -Dracula)
        background_light='#f0f1f4'
        background_dark='#1c1e26'
        base_light='#f9f9fb'
        base_dark='#242632'
        titlebar_light='#f9f9fb'
        titlebar_dark='#242632'
        menu_light='#f9f9fb'
        menu_dark='#343746'
        text_light='#1c1e26'
        text_dark='#f9f9fb'
        tooltip_bg='#474b61'
        ;;
    esac
  fi

  cp -r "${GTKRC_DIR}/gtkrc${ELSE_DARK:-}"                                     "${THEME_DIR}/gtk-2.0/gtkrc"
  sed -i "/tooltip_bg_color/s/#616161/${tooltip_bg}/"                          "${THEME_DIR}/gtk-2.0/gtkrc"

  if [[ "${color}" == '-Dark' ]]; then
    sed -i "s/#3281EA/${theme_color}/g"                                        "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/bg_color/s/#212121/${background_dark}/"                           "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/base_color/s/#2C2C2C/${base_dark}/"                               "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/titlebar_bg_color/s/#2C2C2C/${titlebar_dark}/"                    "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/menu_color/s/#3C3C3C/${menu_dark}/"                               "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/text_color/s/#FFFFFF/${text_dark}/"                               "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/fg_color/s/#FFFFFF/${text_dark}/"                                 "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/titlebar_fg_color/s/#FFFFFF/${text_dark}/"                        "${THEME_DIR}/gtk-2.0/gtkrc"
  else
    sed -i "s/#1A73E8/${theme_color}/g"                                        "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/bg_color/s/#F2F2F2/${background_light}/"                          "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/base_color/s/#FFFFFF/${base_light}/"                              "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/titlebar_bg_color/s/#FFFFFF/${titlebar_light}/"                   "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/menu_color/s/#FFFFFF/${menu_light}/"                              "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/text_color/s/#212121/${text_light}/"                              "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/fg_color/s/#212121/${text_light}/"                                "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "/titlebar_fg_color/s/#212121/${text_light}/"                       "${THEME_DIR}/gtk-2.0/gtkrc"
  fi
}
