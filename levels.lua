
--[[
Inspired by Celestes approach, maps will be one big grid that 
the player navigates layer by layer
When the player dies, load the current layer
When they reach the exit, load the next layer
The next layer will just be the current layer + a height offset
Loading entails moving the player and changing the bounds of the camera

]]--

--simple camera
cam_x = 0
cam_y = 0

--map limits 
map_start = 0
map_end = 640
level_index = -1
awake_timer = 0

function load_level(x, y, restart_music, restart_level)
    fail_in_a_row = 0
    cursed_keys_current_anime = {}
    cursed_chests_current_anime = {}
    frame_timer = 0 
    ui_chest_timer = 0
    ui_key_timer = 0
	player_init(x, y, restart_level)
	bubble_time = max_bubble_time
    num_keys_get = 0
    num_opened_chests = 0
    if restart_music then
        if not player.awaking then 
            music(level_index % 6, 300, 3)
        else
        music(-1)
        end
    end
end

next_level = {}
pre_level = {}
hint_limit = {}
next_level[-1] = 3 pre_level[3] = -1 hint_limit[3] = 0
next_level[3] = 0 pre_level[0] = 3 hint_limit[0] = 0
next_level[0] = 2 pre_level[2] = 0 hint_limit[2] = 1
next_level[2] = 1 pre_level[1] = 2 hint_limit[1] = 2
next_level[1] = 5 pre_level[5] = 1

function load_next_level()
    --current_index = -1 
    level_index = next_level[level_index]
    if 0 == level_index then
        x1 = 128 
        y1 = 3 * 16 * 8
        x0 = x1 + 24
        y0 = y1 + 8
        gravity = 0.04
        min_x = x1
        min_y = y1
        max_x = x1 + 128
        max_y = y1 + 128
        num_particles = 32
        water = true
        air = false
    end
    if 1 == level_index then
        x1 = 0 
        y1 = 0
        x0 = x1 + 59
        y0 = y1 + 59
        gravity = 0.04
        friction = 0.85
        min_x = x1
        min_y = y1
        max_x = x1 + 640
        max_y = y1 + 128 
        num_particles = 160
        water = true
        air = false
    end
    if 2 == level_index then
        x1 = 256
        y1 = 3 * 16 * 8
        x0 = x1 + 8
        y0 = y1 + 112
        gravity = 0.08
        friction = 0.5
        min_x = x1
        min_y = y1
        max_x = x1 + 256
        max_y = y1 + 128
        num_particles = 0
        water = false
        air = true
    end
    if 3 == level_index then
        x1 = 0 
        y1 = 3 * 16 * 8
        x0 = x1 + 59
        y0 = y1 + 59
        gravity = 0.04
        friction = 0.85
        min_x = x1
        min_y = y1
        max_x = x1 + 128 
        max_y = y1 + 128
        num_particles = 32
        water = true
        air = false
    end
    if 5 == level_index then
        x1 = 0 
        y1 = 1 * 16 * 8
        x0 = x1 + 59
        y0 = y1 + 59
        gravity = 0.04
        friction = 0.85
        min_x = x1
        min_y = y1
        max_x = x1 + 640
        max_y = y1 + 128
        num_particles = 160
        water = true
        air = false
    end
    init_particles(num_particles)
    last_x = x0
    last_y = y0
    offset_x = 0
    offset_y = 0
    move_x = 0
    move_y = 0

    x2 = x1 + 128
    y2 = y1 + 128 
    cam_y = y1
    if player.awaking then
        for i = x1, x2 - 1, 8 do
            for j = y1, y2 - 1, 8 do
                celx = flr(i / 8)
                cely = flr(j / 8)
                if fget(mget(celx, cely), 5) then 
                    x0 = celx * 8
                    y0 = cely * 8 
                end
            end
        end
    end
    

    

    load_level(x0, y0, true, player.awaking)
    
    if player.awaking then 
        player.sp = 59 
    end

    if 0 == level_index then
        if 2 == difficulty then 
            bubble_time = 200
            max_bubble_time = 250
            max_bubble_per = 0.8
        elseif 1 == difficulty then 
            bubble_time = 240
            max_bubble_time = 300
            max_bubble_per = 0.8
        elseif 0 == difficulty then
            bubble_time = 320
            max_bubble_time = 400
            max_bubble_per = 0.8
        end

    elseif 1 == level_index then
        if 2 == difficulty then 
            bubble_time = 180
            max_bubble_time = 300
            boost_time = 300
            max_bubble_per = 0.6
        elseif 1 == difficulty then
            bubble_time = 300
            max_bubble_time = 400
            boost_time = 300
            max_bubble_per = 0.75
        elseif 0 == difficulty then
            bubble_time = 400
            max_bubble_time = 500
            boost_time = 400
            max_bubble_per = 0.8
        end
    elseif 2 == level_index then
        if 2 == difficulty then 
            bubble_time = 160
            boost_time = 200
            max_bubble_time = 200
            max_bubble_per = 0.8
        elseif 1 == difficulty then 
            bubble_time = 360
            boost_time = 400
            max_bubble_time = 400
            max_bubble_per = 0.9
        elseif 0 == difficulty then
            bubble_time = 500
            boost_time = 500
            max_bubble_time = 500
            max_bubble_per = 1
        end
    elseif 3 == level_index then
        bubble_time = 400
        boost_time = 400
        max_bubble_time = 400
        max_bubble_per = 1
    elseif 5 == level_index then
        bubble_time = 400
        boost_time = 400
        max_bubble_time = 400
        max_bubble_per = 1
    end
    
    
    init_blending(6)
    num_keys_get = 0
    num_opened_chests = 0
    num_crystal_get = 0
    if 1 == level_index then
        num_cursed_keys = 4  
        num_cursed_chests = 5 

        num_boost = 3 
        num_crystal = 2 

        num_crystal_required = 2
        num_opened_chests_required = 2
        weirdness_key = 0.5
        weirdness_chest = 0.5
        hint = false
    end
    if 2 == level_index then
        num_cursed_keys = 2
        num_cursed_chests = 2

        num_boost = 1
        num_crystal = 1

        num_crystal_required = 1
        num_opened_chests_required = 2
        weirdness_key = 1
        weirdness_chest = 1
        hint = false
    end
    if 0 == level_index then 
        num_cursed_keys = 1
        num_cursed_chests = 2

        num_boost = 0
        num_crystal = 2

        num_crystal_required = 1
        num_opened_chests_required = 1
        weirdness_key = 1
        weirdness_chest = 0.5
        hint = false
    end 
    if 3 == level_index then
        num_cursed_keys = 1  
        num_cursed_chests = 1 

        num_boost = 0 
        num_crystal = 1 

        num_crystal_required = 1
        num_opened_chests_required = 1
        weirdness_key = 1
        weirdness_chest = 1
        hint = true
    end
end

function reload_level()
    sfx_timer = 10
    sfx(0)
    level_index = pre_level[level_index]
    --level_index -= 1
    player.awaking= true 
    awake_timer = 100
    fail = fail_in_a_row
    h = hint
    load_next_level()
    fail_in_a_row = fail + 1
    
    if fail_in_a_row > hint_limit[level_index] then
        hint = true
    else
        hint = h
    end
end

--called in update function
function camera_update()
    frame_timer += 1
    --simple camera
    --cam_x = player.x - 64 + player.w / 2
    --printh("player pos x y ".. player.x.. ", ".. player.y, "log0.txt")
    smooth = 4
    delta_x = (flr(player.x) - 64 + player.w / 2 - cam_x + 0.5) / smooth

    cam_x += delta_x
    if cam_x < map_start then
        cam_x = map_start
    end

end

--Called in draw function
function draw_cam()
    clip() 
   camera(cam_x, cam_y)
end