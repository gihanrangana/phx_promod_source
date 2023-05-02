// #include "ui/menudef.h"

itemDef {
    rect        0 0 0 30 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_SUBTOP
    type        ITEM_TYPE_TEXT
    exp         text ( "Developed by ^2|PHX| GHOST")
    textfont	UI_FONT_DEFAULT
    textscale	0.4
    textstyle	CHOICE_TEXTSTYLE
    textAlign	CHOICE_TEXTALIGN
    textAlignX	CHOICE_TEXT_OFFSET_X
    forecolor	CHOICE_TEXTCOLOR
    visible     1
}

itemDef {
    rect        0 0 0 65 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_SUBTOP
    type        ITEM_TYPE_TEXT
    exp         text ( "^1PHOENIX Promod ^3v1.0")
    textfont	UI_FONT_DEFAULT
    textscale	0.3
    textstyle	ITEM_TEXTSTYLE_NORMAL
    textAlign	CHOICE_TEXTALIGN
    textAlignX	CHOICE_TEXT_OFFSET_X
    forecolor	CHOICE_TEXTCOLOR
    visible     1
}
itemDef
{
    rect                      20 390 24 24 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
    style                     WINDOW_STYLE_SHADER
    borderSize                0
    foreColor                 1 1 1 1
    backColor                 0 0 0 0
    borderColor               0 0 0 0
    outlineColor              0 0 0 0
    textScale                 0.55
    exp						  material( "discord" )
    visible                   1
    decoration  
}
itemDef
{
    rect                      50 390 24 24 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
    style                     WINDOW_STYLE_EMPTY
    foreColor                 1 1 1 1
    textScale                 0.3
    textAlign                 ITEM_ALIGN_MIDDLE_LEFT
    exp						  text( "bit.ly/phx-discord" )
    visible                   1
    decoration  
}

itemDef
{
    rect                      20 420 24 24 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
    style                     WINDOW_STYLE_SHADER
    borderSize                0
    foreColor                 1 1 1 1
    backColor                 0 0 0 0
    borderColor               0 0 0 0
    outlineColor              0 0 0 0
    textScale                 0.55
    exp						  material( "whatsapp" )
    visible                   1
    decoration  
}
itemDef
{
    rect                      50 420 24 24 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
    style                     WINDOW_STYLE_EMPTY
    foreColor                 1 1 1 1
    textScale                 0.3
    textAlign                 ITEM_ALIGN_MIDDLE_LEFT
    exp						  text( "bit.ly/phx-community" )
    visible                   1
    decoration  
}

// itemDef {
//     rect                    0 0 200 200 HORIZONTAL_ALIGN_SUBLEFT VERTICAL_ALIGN_CENTER
//     style                   WINDOW_STYLE_SHADER
//     foreColor               1 1 1 1
//     backColor               0 0 0 0
//     borderColor             0 0 0 0
//     outlineColor            0 0 0 0
//     textScale               0.55
//     exp                     material ( ( ( "phx_logo" ) ) )
//     visible                 1
//     decoration
// }
// itemDef
// {
//     rect                      0 0 290 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
//     style                     WINDOW_STYLE_FILLED
//     borderSize                1
//     foreColor                 1 1 1 1
//     backColor                 0 0 0 0.35
//     borderColor               0 0 0 0
//     outlineColor              0 0 0 0
//     textScale                 0.55
//     visible                   when ( ( dvarint( "vk_oldschool" ) != 1 ) )
//     decoration                
// }

// itemDef
// {
//     rect                      -40 0 8 480 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
//     style                     WINDOW_STYLE_SHADER
//     borderSize                1
//     foreColor                 1 1 1 0.75
//     backColor                 0 0 0 0
//     borderColor               0 0 0 0
//     outlineColor              0 0 0 0
//     textScale                 0.55
//     exp                       material ( ( ( "gradient" ) ) );
//     visible                   when ( ( dvarint( "vk_oldschool" ) != 1 ) )
//     decoration                
// }