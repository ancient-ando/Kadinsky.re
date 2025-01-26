pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

#include player_circle.lua
#include light.lua
#include dream.lua
#include levels.lua
--#include moving_plats.lua
#include cursed.lua
#include game_manager.lua

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11100000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22110000211000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33311000331100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
42211000442210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55111000551100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66d5100066dd51000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
776d100077776d510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88221000888421000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94221000999421000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a9421000aa9942100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb331000bbb331000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccd51000ccdd51000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd511000dd5110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee421000ee4442100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f9421000fff942100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000444440004444400004444400044444000444440004444400044444c004444400000000000000000000000000000000000000000000000000000000
0000000000ccccc000ccccc00ccccccc0c0cccccc00cccccc0cccccc00cccccc0ccccccc04444400000000000000000000000000000000000000000000000000
000000000cf72f200cf72f2c000ff72fc0cff72f0ccff72f0c0ff72f0c0ff72f000ff72f0ccccc00000000000000000000000000000000000000000000000000
000000000cfffff00cfffef0000ffffe000ffffe000ffffe000ffffec00ffffe000ffffecf72f200000000000000000000000000000000000000000000000000
00000000000cc00000cccc000fccc0000fccc0000fccc0000fccc00000ccc0000000ccc0cfffef00000000000000000000000000000000000000000000000000
0000000000cccc000f0cc0f0000cc000000cc000000cc000000cc0000f0cc0000000cc0f00ccccf0000000000000000000000000000000000000000000000000
000000000f0cd0f0000cd0000cc0d00000cd00000dd0c00000dc000000dc000000000cd00f0ccd00000000000000000000000000000000000000000000000000
0000000000c00d0000c00d000000d00000cd00000000c00000dc00000dc00000000000cd0000ccdd000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00bbbbbbbbbbbb0000000000000000000000000000000000000000000000000300000000000000000000000300000000
3bbb3bbbbbbb3bbb3b333bb3bbbbb33b0bbbb3b3bbb3bbb000000000000000000000000000666600000000000003333600000000000000000000000600000000
33b333b33bb33bbb33443b3433bbb343bb3b34343b3433bb000000000000000000366600006c6d00000000000366666600000000000000000000000c00000000
4b3444343bb343b3444443b443bb3444bbb33444434443bb000000000000000000676d00006c6d00000000000676666600000000000000000000000d00000000
4b3424443b344434494443b4443b3444bb3444444449443b0000000000000000666c6d0366666d03666000036666766d00000000666000000000000d00000000
434444444344494444444b3444434424b344444d444443bb000000000000000076d66d0676d66d0676d3300676dcccdd0000000076d330000000000d00000000
44444d44444444444445434449444444bb34f4444544443b0000000000000000c6dccd0cc6dccd0cc676660cc6d666dd00000000c67666000000000d00000000
4944444444d444f4444444444444e44433444444444444430000000000000000663dc30d663dc30d66dc6d0d6c3dd6d30000000066dc6d000000000d00000000
4444444444444444444444444444444400000000000000000000000000000000dd3dd30ddd3dd300ddddd30ddd3ddd3300000000ddddd3000000000d00000000
4444445444444544444444444444494400000000000000000000000000000000dd3dd30ddd3dd300ddddd30ddd3ddd3300000000ddddd3000000000d00000000
4444944444f4444446442244444e444400000000000000000000000000000000dd3dd30ddd3dd300ddddd30ddd3ddd3300000000ddddd3000000000d00000000
444444444444444444442e244444474400000000000000000000000000000000dd3dd30ddd3dd300ddddd30ddd3ddd3300000000ddddd3000000000d00000000
44f444444d664444444442244f44477400000000000000000000000000000000dd3dd30ddd3dd300ddddd30ddd3ddd3300000000ddddd3000000000d00000000
444446444d66649444a444444444764400000000000000000000000000000000dd3dd30ddd3dd300ddddd30ddd3ddd3300000000ddddd3000000000d00000000
4444444444ddd4444444f4444477644400000000000000000000000000000000dd3dd30ddd3dd300ddddd30ddd3ddd3300000000ddddd3000000000d00000000
4e44444444444444444444444447444400000000000000000000000000000000dd3dd30ddd3dd300ddddd30ddd3ddd3300000000ddddd3000000000d00000000
33333333333333334444444444444444000000000009999000000000000000009999999999999999ddddd30ddd3ddd3300000000000000000000000000000000
bbbb3bbbbbbbb3bb9999499999999499000000000009000000000000000000009999999999999999ddddd30ddd3ddd3300000000000000000000000000000000
bbb3bbbbbbbb3bbb9994999999994999000000000009990000099900000000009999999999999999ddddd30ddd3ddd3300000000000000000000000000000000
33333333333333334444444444444444000000000009000000090000000000009999999099999999ddddd300dd3ddd3300000000000000000000000000000000
b3bbbb3bb3bbbbbb9499994994999999000000000099000000099000000000009999999999999999ddddd300dd31dd3300000000000000000000000000000000
bb3bbb3bbb3bbbbb9949994999499999000000000999900000090000000000000999999099999999ddddd300dd30011000000000000000000000000000000000
33333333333333334444444444444444000000000990990000090000000000000000900099999999ddddd300dd30000000000000000000000000000000000000
003bb300000000000049940000000000000000000099990000000000000000009999999999999999dd30d0000d00000000000000000000000000000000000000
003bb300003bb3000049940000499400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003bb300003bb3000049940000499400000000000000000000000000000000000000000000000000000000000000000000666600000000000000000000000000
0033b300003bb300004494000049940000000000000ee000000000000000000000000999000000000000000000000000006c6d00000000000036660000000000
003bb3000033330000499400004444000000000000eeeee0000000000000000099999999000000000000000000000000006c6d000000000000676d0000000000
003bb300003bb30000499400004994000000000000eeee0000000000000000009999999900000000000000000000000066666d0000000000666c6d0000000000
003b3300003bb30000494400004994000000000000eeee0000000000000000009999999900000000000000000000000076d66d000000000076d66d0000000000
003bb300003bb300004994000049940000000000000ee000000000000000000099999999000000000000000000000000c6dccd0000000000c6dccd0000000000
003bb300003bb300004994000049940000000000000e0000000000000000000099999999000000000000000000000000663dc30000000000663dc30000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000066666630000000000333360000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000c66666660000000036666660000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000066c6666d00000000676666c0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006636ccdd663000006636766c0000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000666cccd666600000666cccdc0000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000037d666d6c7d00000c7dc66dc0000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000363d66dcc6300000663dd6dc0000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000dd3ddd3ddd300000dd3ddd3d0000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000dd3ddd3ddd300000dd3ddd3d0000000000000006000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000dd3ddd3ddd300000dd3ddd3d000000000006630c000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d3ddd3ddd300000dd3ddd3d000000000066660c000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d3ddd3ddd300000dd3ddd3d00000000663c7d0c000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d3ddd3ddd300000dd3ddd3d00000000666c6d0c000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d3ddd3ddd300000dd3ddd3d00000000c7dccd0c000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d3ddd3ddd300000dd3ddd3d00000000663dc30d000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d3ddd3ddd300000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d3ddd3d0d000000000000000000000000000000000000000000000000000000
00000054000000000000000000000000000000000000000000000000000000003d3ddd3d00000000000000000300000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d3ddd3d00000000000000036660000000000000000000000000000000000000
00000005546600000000000000000000000000000000000000000000000000003d3ddd3d00000000000003666666600000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d3ddd3d00000000000366666666660000000000000000000000000000000000
00000005356600000000000000442424540000000000000000000000000000003d3ddd3d0000000000076666666666d000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d3ddd3d000000000006c7666666ddd000000000000000000000000000000000
00000005056600000000000000052505050000000000000000000000000000003d3ddd3ddd300000000c6cccccccddd000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d3ddd3ddd300000000cc6ccccccddd000000000000000000000000000000000
00000005055400000000004424050515250000000000000000000000000000003d3ddd3ddd300000000c66ccccccddd000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003d00dd3ddd300000000666ccccccdd3000000000000000000000000000000000
000000052535050524242405350525050500000000000000000000000000000010000000dd300000000dd6cccccc333000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000ddddddddd333000000000000000000000000000000000
04040405050505050505050505050505050404040404040404040404040404040404040400000000000ddddddddd333000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000ddddddddd333000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000017000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000007000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000017000000000017000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000007000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007070707070700000000000000000000070707070404000000000000000000000505050500800400400400000000000004040405000400000400000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
7170545454545454545454545454545400000000000000000000404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070545454545454545454545454545400000000000000000000000000006061710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7171545454545454545454545454545400000000000000000000000000007100710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7071545454545454545454545454545454545454545454540000000000006061715454545454545400000000000000005454545454545454000000000000000054545454545454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7170545454545454545454545454545454545454545454540000000000007100715454545454545400000000000000005454545454545454000000000000000054545454545454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7170545454545454545454545454545454545454545454540000000000006061715454545454545400000000000000005454545454545454000061600000000054545454545454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070545454545454545454545454545454545454545454540000000000007100715454545454545400000000000000005454545454545454006160000000000054545454545441414141450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7170545453535454545454545454545454545454545454540000000000006061715454545454545400000000000000005454545454545454616000000000000054545454545454505050524145000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7171545453535454545454605454545454545454545454540000000000007100715454545454545444004500000000005454545454545461600000000000000054545454545454545050505050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070545454565454546854715468545454545454545454540000000000006061715454545454544451005145000000005454545454546160000000000000000054545454545454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7171545462625454546160616061545454545454545454540000000000007100715454545454545251005152000000005454545454616054000000000000000054545454545454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070545473735454545470547154545454545454545454540000000000006061715454545454545451005100000060605454545461605454000000000000606054546161615454540061006100006060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7071545444456554545471547054545454545454545454540000000000007171715454617054545400000000000071715454546160545454aaab00000000717154545454545454540000000000007171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7071544450504345546570547054706854545465545454540000000000006061715454707054545400000000000071715454606054545454babb00000000717154545454545454540000000000007171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040405050525050414043424142404342424340424142434240424240424142424243404241424342404242404241424242434042414243424042424042414242424340424142434240424240424142000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5050505350505051505050535052505150505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5454545454545454545454545454545454545454545454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5454545454545454545454545454545454545454545454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5454545454545454545454545454545454545454545454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5454545454545454545454545454545454545454545454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000062636363636362000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000072000000000072000000000000626362636263626300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000072000000000072000000000000727372737273727300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
01060000160311104611030150421a056180211c03000004000020000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000600001a040200301f0301904022040200400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060000200401b050160401a0301804017030190401e050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
150400002e33037030323402e0402132029020213201a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5604000004711077210a7310d76110771137711577116771177611876119761187511875117741167411474113741117410e7310c7310a7310973109731087310772106721057210471103711017110071100711
010100002d74531761327412f7312b721297110000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001
9d050000016120161200612006120061201612016120162201622026320363204632056420664207642096420a6420d6420e6421065211652126521566217672186721d672196721867210652096420562203615
