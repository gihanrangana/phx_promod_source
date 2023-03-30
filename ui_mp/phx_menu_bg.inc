itemDef
{
    rect                      0 0 280 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
    style                     WINDOW_STYLE_FILLED
    borderSize                1
    foreColor                 1 1 1 1
    backColor                 0 0 0 0.35
    borderColor               0 0 0 0
    outlineColor              0 0 0 0
    textScale                 0.55
    visible                   when ( ( dvarint( "vk_oldschool" ) != 1 ) )
    decoration                
}

itemDef
{
    rect                      -40 0 8 480 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
    style                     WINDOW_STYLE_SHADER
    borderSize                1
    foreColor                 1 1 1 0.75
    backColor                 0 0 0 0
    borderColor               0 0 0 0
    outlineColor              0 0 0 0
    textScale                 0.55
    exp                       material ( ( ( "gradient" ) ) );
    visible                   when ( ( dvarint( "vk_oldschool" ) != 1 ) )
    decoration                
}