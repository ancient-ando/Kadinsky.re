-- Tokens minimalised --
--variables
gravity, friction = 0.04, 0.85
--number of frames player can spend in the air and still be able to jump
max_coyote, coyote_time = 10, 0


function player_init(spawn_x, spawn_y, awaking)
    
    player = 
        {
            sp = 48,
            x = spawn_x,
            y = spawn_y,
            last_x = 0,
            last_y = 0,
            w = 8,
            h = 8,
            flip = false,
            dx = 0,
            dy = 0,
            max_dx = 1,
            max_dy = 3,
            acc = 0.5,
            boost = 2,
            ani = 0,
            running = false ,
            jumping = false ,
            sliding = false ,
            landed = false,
            teleporting = false,
            jumped = false,
            awaking = awaking,
            bubble_size = 1
        }
end


k_left, k_right, k_up, k_down, k_x = 0, 1, 2, 3, 5
--player
function player_update()

    player.bubble_size = radius * radius * 64
    --wake-up
    if player.awaking then
        player.dy, player.dx = 0, 0
        if  awake_timer > 0 then
            awake_timer -= 1
            return 
        elseif btn(k_left) or btn(k_right) or btn(k_up) or btn(k_down) or btnp(k_x) then
            player.awaking = false
            if 6 > level_index then 
                music(level_index % 6, 300, 3)
            elseif 6 <= level_index then
                music(6 + level_index % 6, 300, 3)
            end
        else 
            return 
        end
    end
    --teleportation 
    if player.teleporting then
        player.dy, player.dx = 0, 0
        if tele_timer > 0 then
            tele_timer -= 1
        else
            load_next_level()
            player.teleporting = false
        end
        return 
    end
    --physics
    player.dy += gravity
    player.dx *= friction 

    --printh("coyote ".. coyote_time, "log.txt")
    --jump 
    if btnp(k_x) and not player.jumped and 
    (player.landed or coyote_time > 0) then
        jump = player.jumped and "yes" or "no"
        land = player.landed and "yes" or "no"

        init_smoke(player)
        init_foam(player)
        --printh("coyote + jumped + landed ".. coyote_time .. jump.. " "..land, "log.txt")
        psfx(11)
        player.dy -= player.boost
        player.landed, player.jumped = false, true
    end
    --controls
    if btn(k_left) then 
        player.dx -= player.acc
        player.running, player.flip = true, true
    end
    if btn(k_right) then
        player.dx += player.acc
        player.running, player.flip = true, false
    end
    --slide
    if player.running and
    not btn(k_left) and
    not btn(k_right) and
    not player.falling and 
    not player.jumping then
        player.running, player.sliding = false, true
    end

    --collision
    if player.dy > 0 then
        --[[if coyote_time <= 0 then
            coyote_time = 10
        end]]--
        if 0 == iframe_time and collide_map(player, "down", 3) then
            --reload_level()
            iframe_time = 120
            sfx(12)
        end
        if not player.falling and coyote_time <= 0 then
            coyote_time = max_coyote
        end


        player.falling, player.landed, player.jumping = true, false, false

        player.dy = limit_speed(player.dy, player.max_dy)
        if collide_map(player, "down", 0) then
            
            player.landed, player.jumped, player.falling = true, false, false
            player.dy = 0

            while pixel_perfect_collide(0, x1r, y1r - 1, x2r, y2r - 1) do
                player.y -= 1
                y1r -= 1
                y2r -= 1
            end
            if not player.was_landed then 
                init_smoke(player)
                init_foam(player)
            end
        end 
    elseif player.dy < 0 then
        if 0 == iframe_time and collide_map(player, "up", 3) then
            --reload_level()
            iframe_time = 120
            sfx(12)
        end
        player.jumping = true
        if collide_map(player, "up", 1) then
            player.dy = 0
        end
    end

    --left & right
    if player.dx < 0 then
        if 0 == iframe_time and collide_map(player, "left", 3) then
            --reload_level()
            iframe_time = 120
            sfx(12)
        end
        player.dx = limit_speed(player.dx, player.max_dx)
        if collide_map(player, "left", 1) then
            player.dx = 0
            if collide_map(player, "left", 4) or collide_map(player, "down", 4) then
                player.x -= 1
                player.y -= 1
                x1r -= 1 
                x2r -= 1
                y1r -= 1
                y2r -= 1

            end 
        end
        
    end
    if player.dx > 0 then
        if 0 == iframe_time and collide_map(player, "right", 3) then
            --reload_level()
            iframe_time = 120
            sfx(12)
        end
        player.dx = limit_speed(player.dx, player.max_dx)
        if collide_map(player, "right", 1) then
            player.dx = 0
            if collide_map(player, "right", 4) or collide_map(player, "down", 4) then
                player.x += 1
                player.y -= 1
                x1r += 1 
                x2r += 1
                y1r -= 1
                y2r -= 1

            end 
        end
    end

    --stop sliding 
    if player.sliding then
        if abs(player.dx) <.2
        or player.running then
            player.dx = 0
            player.sliding = false
        end
    end

    player.x += flr(player.dx + 0.5)
    --player.x += player.dx

    player.y += player.dy 

     --coyote time
    if coyote_time > 0 then
       coyote_time -= 1
    end
    if iframe_time > 0 then 
        if vbubble_time > 0.3 then 
            vbubble_time *= 0.9
        end 
        iframe_time -= 1
    else 
        vbubble_time = min(bubble_time, vbubble_time / 0.9)
        if vbubble_time / bubble_time > 0.27 and vbubble_time / bubble_time < 0.3 then
            sfx(19)
        end  
    end 
    player.was_landed = player.landed
    --printh(player.bubble_size, "log.txt")
end
function player_animate()
    local shift = 48
    if player.awaking then 
        if awake_timer > 30 then
            if time() - player.ani > .5 then
                player.ani = time()
                player.sp -= 1
                if player.sp < 10 + shift then
                    player.sp = 11 + shift
                end
            end 
        else
            if time() - player.ani > .5 then
                player.ani = time()
                player.sp -= 1
                if player.sp < 8 + shift then
                    player.sp = shift + 1
                    --player.awaking = false
                end
            end
        end
    elseif player.teleporting then
        if time() - player.ani > .15 then
            player.ani = time()
            if player.sp < 12 + shift or player.sp > 15 + shift then
                player.sp = 12 + shift
            else
                player.sp += 1
                if player.sp > 15 + shift then
                    player.sp = 12 + shift
                end
            end
        end
    elseif player.jumping then
        player.sp = 7 + shift
    elseif player.falling then
        player.sp = 8 + shift
    elseif player.slide then 
        player.sp = 9 + shift
    elseif player.running then
        if time() - player.ani > .1 then
            player.ani = time()
            player.sp += 1
            if player.sp > 6 + shift then 
                player.sp = 3 + shift
            end
        end
    else --idle
        if time() - player.ani > .3 then 
            player.ani = time()
            player.sp += 1 
            if player.sp > 2 + shift then
                player.sp = 1 + shift 
            end
        end
    end
end


--collisions
function pixel_perfect_collide(flag, x1, y1, x2, y2)
    local perfect_collision = false
    local celx, cely = 49 % 16, 49 \ 16
    for i = x1, x2, 1 do 
        for j = y1, y2, 1 do 
            local deltai, deltaj = i - x1, j - y1
            local x, y = celx * 8 + deltai, cely * 8 + deltaj
            if -1 != deltai and 8 != deltai and -1 != deltaj and 8 != deltaj and 0 != sget(x, y) then 
                local celi, celj = i \ 8, j \ 8
                local sij = mget(celi, celj)
                local sx, sy = sij % 16, sij \ 16
                if 0 != sij and fget(sij, flag) and 0 != sget(sx * 8 + flr(i) % 8, sy * 8 + flr(j) % 8) then
                    perfect_collision = true
                end
            end
        end
    end
    return perfect_collision
end
function collide_map(obj, dir, flag)
    local x, y, w, h = obj.x, obj.y, obj.w, obj.h 
    local x1, y1, x2, y2 = 0, 0, 0, 0
    if dir == "left" then
        x1, y1, x2, y2 = x - 1, y, x, y + h - 1
    elseif dir == "right" then
        x1, y1, x2, y2 = x + w - 1, y, x + w, y + h - 1
    elseif dir == "up" then
        x1, y1, x2, y2 = x + 2, y - 1, x + w - 3, y + 2
    elseif dir == "down" then
        x1, y1, x2, y2 = x + 2, y + h - 2, x + w - 3, y + h 
    end
    --update collison box 
    x1r, y1r, x2r, y2r = x1, y1, x2, y2

    x1 /= 8
    y1 /= 8
    x2 /= 8
    y2 /= 8
    if (fget(mget(x1, y1), flag) 
    or fget(mget(x1, y2), flag) 
    or fget(mget(x2, y1), flag)
    or fget(mget(x2, y2), flag)) and pixel_perfect_collide(flag, x1r, y1r, x2r, y2r) then 
        return true
    else 
        return false 
    end
end

--speed limit
function limit_speed(num, maximum)
    return mid(-maximum, num, maximum)
end