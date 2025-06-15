
function _init()
    --poke(0x5f2c,3)
    sfx(6)

	player_init(59, 59, false)

	--init_actors()

    init_light()
    level_index = -1
    load_next_level()

end


function _update60()

   
    player_update()
    --update_infinity()
    player_animate()
    menu_update1()
    menu_update3()    

    camera_update()
    update_light()
    --shift_infinity()
    --dream_infinity()
    update_sfx()
    update_smoke()
    update_foam()
    update_particles()
    init_particles(num_particles)

end

function oprint(str,x,y,c,co) --outline print
    for xx=-1,1,1 do
        for yy=-1,1,1 do
            print(str,x+xx,y+yy,co)
        end
    end
    print(str,x,y,c)
end

function bigprint(str,x,y,c,co,scale)
    poke(0x5f54,0x60) -- screen is spritesheet. spr and sspr use screen as source
    oprint(str,x,y,c,co) -- outline print to desired location
    local x0 = x-1
    local y0 = y-1
    local w = #str*4 + 2
    local h = 7 -- only works on single line strings for now
    palt(0b1111111111111111) -- set all colors transparent
    palt(c,false) -- only draw the text and outline colors
    palt(co,false)
    sspr(x0,y0,w,h,x0,y0,w*scale,h*scale) -- stretch the text with desired scale
    palt()
    poke(0x5f54,0x00) -- set spritesheet back to source for spr
end

function _draw()
    
   -- draw_cam()
    
    draw_light()
    
    --draw_actors()

    update_bubble(flr(player.x) + player.w / 4, flr(player.y)+player.h / 4)
    --camera(0, 0)
    if (info) show_performance()
    camera(cam_x, cam_y)
    clip()
   --print("KEYS:" .. num_keys_get,10+cam_x,10+cam_y, 14)
   if 1 == level_index then 
        oprint("\^w\^t NIGHT\^-w\^-tMARE" ,320 + min_x ,50 + cam_y, 14, 7)
    end
    if 3 == level_index then 
        oprint("\^w\^t KADINSKY" ,50 ,50 + cam_y, 14, 7)
    end
    if 0 == level_index then
        oprint("".. chr(131).. "\^w\^tTHE".."\^-w\^-t8-BIT HOLE", 96 + min_x, 12 + cam_y, 14, 7)
    end
    if 2 == level_index then 
        --print("\^i\^w\^tDOUBLE-USE" ,150 + min_x, 112 + cam_y, 14)
        oprint("\^w\^tDOUBLE\^-w\^-t-USE", 150 + min_x, 112 + cam_y, 14, 7)
    end
    if 4 == level_index then 
        oprint("\^-w\^-tOUT OF\^w\^tTIME", 16 + min_x, 104 + cam_y, 14, 7)
    end 
    if 6 == level_index then 
        oprint("\^-w\^-tOUT OF\^w\^tLUCK", 16 + min_x, 104 + cam_y, 14, 7)
    end 
    if 5 == level_index then 
        print ("\^w\^t THANKS FOR PLAYING!", 50, 30 + cam_y, 14, 7)
        oprint ("a GAME IN A <bubble>", 50, 48 + cam_y, 14, 7)
        print ("by Jakobe - gAMEPLAY & SOUND PROGRAMMING", 100, 56 + cam_y, 14, 7)
        print ("Clastic Artistic - lEVEL DESIGN & TEXTURE DESIGN", 80, 64 + cam_y, 14, 7)
        print ("FracturedQuartz - mUSIC, SOUND DESIGN & VFX", 120, 72 + cam_y, 14, 7)
        print ("CrisisMoonCartoons - cONCEPT ART & ANIMATION", 140, 80 + cam_y, 14, 7)
        print ("Cweeperk - sOUND DESIGN, NARRATION DESIGN & ui", 110, 88 + cam_y, 14, 7)    
        print ("Loumi - pIXEL ART ", 160, 96 + cam_y, 14, 7)
        print ("and Ando <ancient> - pROGRAMMING, VFX & PRODUCER ", 130, 104 + cam_y, 14, 7)
    end
    clip(xl,yt,xr-xl+1,yb-yt+1)
end

function show_performance()
    clip()
    camera(0, cam_y)
    local cpu=flr(stat(1)*100)
    local fps=-60/flr(-stat(1))
    local perf=
    "" ..cpu .. "% cpu @ " ..
    fps ..  " fps"
    print(perf,0,122+cam_y,0)
    print(perf,0,121+cam_y,fps==60 and 7 or 8)

    if target_x and target_y then
        local cood=
        "x:" ..target_x .. " y:" ..target_y
        print(cood,0,100+cam_y,7)
        local shif =
        "dream:" ..dream_shift .. " time:"..time_shift .. " ratio: ".. (dream_shift + 1) / (dream_shift + time_shift + 2)
        print(shif, 0,110+cam_y,7) 
    end
    --[[if tshift_x and tshift_y then
        local tshif = "x:" .. tshift_x .. " y:" .. tshift_y .. " seed:" .. seed
        print(tshif, 0, 0 + cam_y, 7)
    end]]--

    camera()
    clip(xl,yt,xr-xl+1,yb-yt+1)
end
