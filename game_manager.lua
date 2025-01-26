
function _init()
    sfx(6)

	player_init(59, 59)

	--init_actors()

    init_light()

    

end

function _update()

	--update_actors()

end

function _update60()
	player_update()
	player_animate()
       

   update_light()

   camera_update()

end

function _draw()
    
   -- draw_cam()
    
    draw_light()
    
    --draw_actors()

    update_bubble(player.x + player.w / 4, player.y+player.h / 4)

    --show_performance()
end

function show_performance()
    clip()
    local cpu=flr(stat(1)*100)
    local fps=-60/flr(-stat(1))
    local perf=
    cpu .. "% cpu @ " ..
    fps ..  " fps"
    print(perf,0,122+cam_y,0)
    print(perf,0,121+cam_y,fps==60 and 7 or 8)
end
