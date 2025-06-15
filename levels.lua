-- Token minimised -- 


--[[
Inspired by Celestes approach, maps will be one big grid that 
the player navigates layer by layer
When the player dies, load the current layer
When they reach the exit, load the next layer
The next layer will just be the current layer + a height offset
Loading entails moving the player and changing the bounds of the camera

]]--

--simple camera
cam_x, cam_y = 0, 0

--map limits 
map_start, map_end = 0, 640

level_index = -1
awake_timer = 0

function load_level(x, y, restart_music, restart_level)
    fail_in_a_row = 0
    cursed_keys_current_anime = {}
    cursed_chests_current_anime = {}
    cursed_flowers_current_anime = {}
    frame_timer, infinite_timer, ui_chest_timer, ui_key_timer = 0, 0, 0, 0
	player_init(x, y, restart_level)
	bubble_time = max_bubble_time
    num_keys_get, num_opened_chest = 0, 0
    if restart_music then
        if player.awaking then 
            music(-1)
        else
            if 4 != level_index and 6 != level_index then 
                music(level_index % 6, 300, 3)
            elseif 4 == level_index or 6 == level_index then 
                --music(6 + level_index % 6, 300, 3)
                music(-1)
            end
        end

    end
end

next_level, pre_level, hint_limit = {}, {}, {}

pre_level[-1] = -1
next_level[-1] = 3 pre_level[3] = -1 hint_limit[3] = 0
next_level[3] = 0 pre_level[0] = 3 hint_limit[0] = 0
next_level[0] = 2 pre_level[2] = 0 hint_limit[2] = 1
next_level[2] = 4 pre_level[4] = 2 hint_limit[4] = 10
next_level[4] = 1 pre_level[1] = 4 hint_limit[1] = 2
--next_level[1] = 7 pre_level[7] = 1 hint_limit[7] = 3
--next_level[7] = 5 pre_level[5] = 7 hint_limit[5] = 1
next_level[1] = 6 pre_level[6] = 1 hint_limit[6] = 2
next_level[6] = 5 pre_level[5] = 6 hint_limit[5] = 1



function load_next_level()
    iframe_time, aframe_time, last_mech = 0, 0, 0
    --current_index = -1 
    level_index = next_level[level_index]
    level = level_index
    tshift_x, tshift_y, shift_x, shift_y = 0, 0, 0, 0

    set_sfx_speeds({36, 30, 40, 44, 50, 52}, 28)

    --[[if 7 == level_index then
        set_sfx_speeds({36, 30, 40, 44, 50, 52}, 56)
        time_shift, dream_shift = 0, 0
        x1, y1, x0, y0 = 640, 0, 768, 128
        gravity = 0.02
        min_x, min_y, max_x, max_y = x1, y1, x1 + 256, y1 + 256
        mid_x, mid_y = (min_x + max_x) / 2, (min_y + max_y) / 2
        q1_x, q1_y = (min_x + mid_x) / 2, (min_y + mid_y) / 2
        q3_x, q3_y = (mid_x + max_x) / 2, (mid_y + max_y) / 2
        num_particles = 128
        water, air = true, true
    end]]--
    
    if 0 == level_index then
        x1, y1, x0, y0 = 128, 384, 128 + 24, 384 + 8 
        gravity = 0.04
        min_x, min_y, max_x, max_y = x1, y1, x1 + 128, y1 + 128
        num_particles = 32
        water, air = true, false
    end
    if 1 == level_index then
        x1, y1, x0, y0 = 0, 0, 59, 59
        gravity = 0.04
        friction = 0.85
        min_x, min_y, max_x, max_y = x1, y1, x1 + 640, y1 + 128
        num_particles = 160
        water, air = true, false
    end
    if 2 == level_index then
        x1, y1, x0, y0 = 256, 384, 256 + 8, 384 + 112
        gravity = 0.08
        friction = 0.5
        min_x, min_y, max_x, max_y = x1, y1, x1 + 256, y1 + 128
        num_particles = 0
        water, air = false, true
    end
    if 3 == level_index then
        x1, y1, x0, y0 = 0, 384, 59, 384 + 59
        gravity = 0.04
        friction = 0.85
        min_x, min_y, max_x, max_y = x1, y1, x1 + 128, y1 + 128
        num_particles = 32
        water, air = true, false
    end
    if 4 == level_index then
        x1, y1, x0, y0 = 640, 448, 640 + 16, 448 + 16
        gravity = 0.04
        friction = 0.85
        min_x, min_y, max_x, max_y = x1, y1, x1 + 64, y1 + 64
        num_particles = 0
        water, air = true, false
    end
    if 5 == level_index then
        x1, y1, x0, y0 = 0, 128, 59, 128 + 59
        gravity = 0.04
        friction = 0.85
        min_x, min_y, max_x, max_y = x1, y1, x1 + 640, y1 + 128
        num_particles = 160
        water, air = true, false
    end
    if 6 == level_index then
        x1, y1, x0, y0 = 640, 384, 640 + 16, 384 + 16
        gravity = 0.08
        friction = 0.85
        min_x, min_y, max_x, max_y = x1, y1, x1 + 256, y1 + 128
        num_particles = 0
        water, air = false, true
    end
    particles = {}
    init_particles(num_particles)
    last_x, last_y = x0, y0
    offset_x, offset_y, move_x, move_y = 0, 0, 0, 0

    x2, y2 = x1 + 128, y1 + 128
    cam_y = y1
    if player.awaking then
        local f = false
        for i = x1, x2 - 1, 8 do
            for j = y1, y2 - 1, 8 do
                --celx = flr(i / 8)
                --cely = flr(j / 8)
                celx, cely = i \ 8, j \ 8
                --if fget(mget(celx, cely), 5) then 
                if 59 == mget(celx, cely) and not f then  
                    f = true 
                    x0, y0 = celx * 8, cely * 8
                end
            end
        end
        for i = min_x, max_x - 1, 8 do
            for j = min_y, max_y - 1, 8 do
                --celx = flr(i / 8)
                --cely = flr(j / 8)
                celx, cely = i \ 8, j \ 8
                --if fget(mget(celx, cely), 5) then 
                local c = mget(celx, cely)
                if 130 == c or 146 == c then 
                    mset(celx, cely, c - 1) 
                end
            end
        end
    end



    load_level(x0, y0, true, player.awaking)
    player.sp = player.awaking and 59 or player.sp

    --[[if 7 == level_index then
        bubble_time, boost_time, max_bubble_time, max_bubble_per = 200, 300, 300, 0.66
    elseif 6 == level_index then]]--
    if 0 == level_index then
        if 2 == difficulty then 
            bubble_time, boost_time, max_bubble_time, max_bubble_per = 224, 0, 280, 0.8
        elseif 1 == difficulty then 
            bubble_time, boost_time, max_bubble_time, max_bubble_per = 300, 0, 375, 0.8
        elseif 0 == difficulty then
            bubble_time, boost_time, max_bubble_time, max_bubble_per = 400, 0, 500, 0.8
        end

    elseif 1 == level_index then
        if 2 == difficulty then 
            bubble_time, boost_time, max_bubble_time, max_bubble_per = 210, 300, 350, 0.6
        elseif 1 == difficulty then
            bubble_time, boost_time, max_bubble_time, max_bubble_per = 300, 300, 400, 0.75
        elseif 0 == difficulty then
            bubble_time, boost_time, max_bubble_time, max_bubble_per = 400, 400, 500, 0.8
        end
    elseif 2 == level_index then
        if 2 == difficulty then 
            bubble_time, boost_time, max_bubble_time, max_bubble_per = 220, 250, 275, 0.8
        elseif 1 == difficulty then 
            bubble_time, boost_time, max_bubble_time, max_bubble_per = 360, 400, 400, 0.9
        elseif 0 == difficulty then
            bubble_time, boost_time, max_bubble_time, max_bubble_per = 500, 500, 500, 1
        end
    elseif 3 == level_index then
        bubble_time, boost_time, max_bubble_time, max_bubble_per = 400, 400, 400, 1
    elseif 4 == level_index then
        bubble_time, boost_time, max_bubble_time, max_bubble_per = 180, 200, 200, 0.9
    elseif 5 == level_index then
        bubble_time, boost_time, max_bubble_time, max_bubble_per = 400, 400, 400, 1
    elseif 6 == level_index then 
        bubble_time, boost_time, max_bubble_time, max_bubble_per = 400, 400, 400, 1
    end 
    
    vbubble_time = bubble_time --Visual bubble time 

    init_blending(6)

    num_keys_get, num_opened_chests, num_crystal_get = 0, 0, 0
    --[[if 7 == level_index then
        num_cursed_keys, num_cursed_chests, num_boost, num_crystal = 4, 5, 3, 2
        num_crystal_required, num_opened_chests_required = 2, 2
        weirdness_key, weirdness_chest = 0.5, 1
        hint = false
    end]]--
    weirdness_flower = 1
    if 1 == level_index then
        num_cursed_keys, num_cursed_chests, num_boost, num_crystal = 5, 5, 3, 2
        num_crystal_required, num_opened_chests_required = 2, 2
        weirdness_key, weirdness_chest = 0.5, 0.8
        hint = false
    end
    if 2 == level_index then
        num_cursed_keys, num_cursed_chests, num_boost, num_crystal = 2, 2, 1, 1
        num_crystal_required, num_opened_chests_required = 1, 2
        weirdness_key, weirdness_chest = 1, 1
        hint = false
    end
    if 0 == level_index then 
        num_cursed_keys, num_cursed_chests, num_boost, num_crystal = 1, 2, 0, 2
        num_crystal_required, num_opened_chests_required = 1, 1
        weirdness_key, weirdness_chest = 1, 0.5
        hint = false
    end 
    if 3 == level_index then
        num_cursed_keys, num_cursed_chests, num_boost, num_crystal = 1, 1, 0, 1
        num_crystal_required, num_opened_chests_required = 1, 1
        weirdness_key, weirdness_chest = 1, 1
        hint = false
    end
    if 4 == level_index then
        num_cursed_keys, num_cursed_chests, num_boost, num_crystal = 3, 3, 0, 3
        num_crystal_required, num_opened_chests_required = 3, 0
        weirdness_key, weirdness_chest = 1, 1
        hint = false
    end
    if 6 == level_index then 
        num_cursed_keys, num_cursed_chests, num_boost, num_crystal = 1, 1, 0, 1
        num_crystal_required, num_opened_chests_required = 1, 0
        weirdness_key, weirdness_chest, weirdness_flower = 1, 1, 0.42
        hint = false
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
    if fail_in_a_row >= hint_limit[next_level[level_index]] then 
        hint = true
    end
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
    if abs(player.last_x - player.x) > 0.01 or abs(player.last_y - player.y) > 0.01 then
        frame_timer += 1
        player.last_x, player.last_y = player.x, player.y
    end
    --simple camera
    --cam_x = player.x - 64 + player.w / 2
    --printh("player pos x y ".. player.x.. ", ".. player.y, "log0.txt")
    local m_x, m_y = flr(player.x) - 64 + player.w / 2 - cam_x, flr(player.y) - 64 + player.h / 2 - cam_y
    if 4 != level_index then  
        smooth = 4
        delta_x = (m_x + 0.5) / smooth
        cam_x += delta_x
        if cam_x < map_start then
            cam_x = map_start
        end
    end 
    if 4 == level_index then
        --cam_x += m_x
        --cam_y += m_y
        smooth = 4
        delta_x = (m_x + 0.5) / smooth
        cam_x += delta_x
        if cam_x < map_start then
            cam_x = map_start
        end
        cam_y = min_y + 16 
    end

end

--Called in draw function
function draw_cam()
    clip() 
    camera(cam_x, cam_y)
end