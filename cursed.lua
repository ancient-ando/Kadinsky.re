cursed_keys_current_frame, cursed_keys_last_frame, 
cursed_chests_current_frame, cursed_chests_last_frame = {}, {}, {}, {}

bubble_delta = 4

function get_hash(celx, cely)
    return 100 * celx + cely
end
function get_hashx(h)
    return flr(h / 100) * 8
end
function get_hashy(h)
    return h % 100 * 8
end
critical_distance = 15
function get_cursed_keys()

    local celx, cely = (player.x + player.w / 2) \ 8, (player.y + player.h / 2) \ 8
    --if fget(mget(celx, cely), 7) then 
    if 133 == mget(celx, cely) then 
        --rect(celx * 8 - 2, cely * 8 - 2, celx * 8 + 2, cely * 8 + 2)
        --rect(player.x - 3, player.y - 3, player.x + 3, player.y + 3)
        if #(v(celx * 8, cely * 8) - v(player.x, player.y)) < critical_distance then
            --printh('\n new key found', 'log.txt')
            --printh('\n new key found'..num_keys_get, 'log.txt')
            local hash = get_hash(celx, cely)
            if "key" == cursed_keys_last_frame[hash] then
                ui_key_timer = 75
                num_keys_get += 1
                num_cursed_keys -= 1
                cursed_keys_last_frame[hash] = "inside_empty"
                sfx(3)
                sfx_timer = 5
            end
        end
    end
end
function get_boost_or_crystal()
    local total = num_boost + num_crystal
    if 0 == total then return end 
    no = flr(rnd(total) + 1)
    if no > num_boost and num_opened_chests >= num_opened_chests_required then -- get_crystal
        num_crystal_get += 1
        sfx(1)
        num_crystal -= 1
        if num_crystal_get >= num_crystal_required then
            sfx(4)
            sfx_timer = 15
            -- teleportation 
            player.teleporting = true
            tele_timer = 50
        end
    else -- get_boost
        num_boost -= 1
        sfx_timer = 5
        sfx(2)
        bubble_time = min(max_bubble_per * max_bubble_time, bubble_time + boost_time)
    end
end
function get_cursed_chests()
    local celx, cely = (player.x + player.w / 2) \ 8, (player.y + player.h / 2) \ 8
    --if fget(mget(celx, cely), 6) then 
    if 134 == mget(celx, cely) then 
    if #(v(celx * 8, cely * 8) - v(player.x, player.y)) < critical_distance then
        --printh('\n new chest found', 'log.txt')
        local hash = get_hash(celx, cely)
        if "chest" == cursed_chests_last_frame[hash] and num_keys_get > 0 then
            num_cursed_chests -= 1
            cursed_chests_last_frame[hash] = "open"
            num_opened_chests += 1
            num_keys_get -= 1
            sfx_timer = 5
            ui_chest_timer = 60
            get_boost_or_crystal()
        end
    end
    end
end

function render_ui_keys()
    clip()
    --[[if 0 == ui_key_timer then
        for i = 0, num_keys_get - 1, 1 do
            spr(152, cam_x + i * 10 + 3, cam_y + 2, 1, 1)
        end
    else
        ui_key_timer -= 1
        for i = 0, num_keys_get - 1 - flr(ui_key_timer / 15) % 2, 1 do
            spr(152, cam_x + i * 10 + 3, cam_y + 2, 1, 1)
        end
    end]]--
    if 0 ~= ui_key_timer then 
        ui_key_timer -= 1
    end
    for i = 0, num_keys_get - 1 - flr(ui_key_timer / 15) % 2, 1 do
        spr(152, cam_x + i * 10 + 3, cam_y + 2, 1, 1)
    end
    clip(xl,yt,xr-xl+1,yb-yt+1)
end

ui_chest_timer, ui_key_timer = 0, 0
function render_ui_chests()
    clip()
    if ui_chest_timer <= 0 then
        return 
    end
    ui_chest_timer -= 1
    for i = 0, num_cursed_chests - 1 + flr(ui_chest_timer / 10) % 2, 1 do
        spr(153, cam_x + i * 10 + 3, cam_y + 12, 1, 1)
    end
    for i = num_cursed_chests + flr(ui_chest_timer / 10) % 2, num_cursed_chests + num_opened_chests - 1, 1 do
        spr(154, cam_x + i * 10 + 3, cam_y + 12, 1, 1)
    end
    clip(xl,yt,xr-xl+1,yb-yt+1)
end
function render_cursed_keys(pass)
    local cursed_keys_current_frame = {}

    local x1, x2, y1, y2 = cam_x, cam_x + 136, cam_y, cam_y + 136

    for i = x1, x2 - 1, 8 do
        for j = y1, y2 - 1, 8 do
            --local celx = flr((i ) / 8)
            --local cely = flr((j ) / 8) 
            local celx, cely = i \ 8, j \ 8 
            --if fget(mget(celx, cely), 7) then 
            if 133 == mget(celx, cely) then 
                local r = sqrt(player.bubble_size) + bubble_delta 
                local hash = get_hash(celx, cely)
                cursed_keys_current_frame[hash] = #(v(celx * 8, cely * 8) - v(flr(player.x), flr(player.y))) < r * r 
                and "inside" or "outside"
            end
        end
    end
    local allocated_keys, potential_keys = 0, #cursed_keys_current_frame
    for k, va in pairs(cursed_keys_last_frame) do
        if "inside" == cursed_keys_current_frame[k] and "key" == va then 
            allocated_keys += 1
            cursed_keys_current_frame[k] = "key"
            potential_keys -= 1
        elseif "inside" == cursed_keys_current_frame[k] and "inside_empty" == va then
            --printh("cursed...", "log.txt")
            cursed_keys_current_frame[k] = "inside_empty"
            potential_keys -= 1
        end
    end
    --printh("pass w al".. pass .. " " .. weirdness_key .. allocated_keys, "log.txt")
    for k, va in pairs(cursed_keys_current_frame) do
        if "inside" == va then
            --printh("alk "..allocated_keys, "log.txt" )
        if allocated_keys < num_cursed_keys and rnd(1) < weirdness_key then -- this number controls how cursed it is, 0 means devil, 1 means normal
            cursed_keys_current_frame[k] = "key"
            allocated_keys += 1
        end
    end
    end
    for k, va in pairs(cursed_keys_current_frame) do
        if "inside" == va then
            cursed_keys_current_frame[k] = "inside_empty"
        elseif "outside" == va then
            cursed_keys_current_frame[k] = "outside_empty"
        end
    end
    for k, va in pairs(cursed_keys_current_frame) do
        local hashx, hashy = get_hashx(k), get_hashy(k)
        if "key" == va and 1 == pass then
            spr(128, hashx, hashy, 1, 1) -- cursed_key
        elseif "inside_empty" == va and 2 == pass and num_cursed_keys > 0 and hint then
            clip()
            spr(165, hashx, hashy, 1, 1) -- cursed_key_missing
            clip(xl,yt,xr-xl+1,yb-yt+1)
        elseif "key" != va and 2 == pass and "inside_empty" != va and "empty" != va and num_cursed_keys > 0 then
            if nil == cursed_keys_current_anime[k] or 0 == frame_timer % 1 then
                if rnd(1) < weirdness_key then
                    cursed_keys_current_anime[k] = 168
                else
                    cursed_keys_current_anime[k] = rnd(1) < 0.5 and 155 or 171
                end
            end 
            if nil != cursed_keys_current_anime[k] and -1 != cursed_keys_current_anime[k] and hint then 
                clip()
                spr(cursed_keys_current_anime[k], hashx, hashy, 1, 1) --cursed_key_unknown
                clip(xl,yt,xr-xl+1,yb-yt+1) 
            end
        end
    end
    cursed_keys_last_frame = {}
    for k, va in pairs(cursed_keys_current_frame) do
        cursed_keys_last_frame[k] = va
    end 
    --cursed_keys_last_frame = cursed_keys_current_frame -- this doesn't work cause table copies by reference, not value
end

function render_cursed_chests(pass)
    local cursed_chests_current_frame = {}
    local x1, x2, y1, y2 = cam_x, cam_x + 136, cam_y, cam_y + 136

    for i = x1, x2 - 1, 8 do
        for j = y1, y2 - 1, 8 do
            local celx, cely = i \ 8, j \ 8
            --if fget(mget(celx, cely), 6) then 
            if 134 == mget(celx, cely) then 
                local r = sqrt(player.bubble_size) + bubble_delta 
                local hash = get_hash(celx, cely)
                cursed_chests_current_frame[hash] = #(v(celx * 8, cely * 8) - v(player.x, player.y)) < r * r 
                and "inside" or "outside"
            end
        end
    end
    allocated_chests, potential_chests = 0, #cursed_chests_current_frame
    for k, va in pairs(cursed_chests_last_frame) do
        if "inside" == cursed_chests_current_frame[k] and "chest" == va then 
            allocated_chests += 1
            cursed_chests_current_frame[k] = "chest"
            potential_chests -= 1
        elseif "inside" == cursed_chests_current_frame[k] and "inside_empty" == va then
            cursed_chests_current_frame[k] = "inside_empty"
            potential_chests -= 1
        
        elseif "inside" == cursed_chests_current_frame[k] and "open" == va then
            cursed_chests_current_frame[k] = "open"
            potential_chests -= 1
        end
    end
    num_allocated_opened_chests = 0
    for k, va in pairs(cursed_chests_current_frame) do
        if "open" == va then
            num_allocated_opened_chests += 1
        end
    end
    for k, va in pairs(cursed_chests_current_frame) do
        if "inside" == va then
            if allocated_chests <= num_cursed_chests and rnd(1) < weirdness_chest then -- this number controls how cursed it is, 0 means devil, 1 means normal
                if num_allocated_opened_chests < num_opened_chests and rnd(1) < 0.5 then 
                    cursed_chests_current_frame[k] = "open"
                    num_allocated_opened_chests += 1
                elseif allocated_chests < num_cursed_chests then
                    cursed_chests_current_frame[k] = "chest"
                end
                allocated_chests += 1
            end
        end
    end
    for k, va in pairs(cursed_chests_current_frame) do
        if "inside" == va then
            cursed_chests_current_frame[k] = "inside_empty"
        elseif "outside" == va then
            cursed_chests_current_frame[k] = "outside_empty"
        end
    end
    for k, va in pairs(cursed_chests_current_frame) do
        local hashx, hashy = get_hashx(k), get_hashy(k)
        if "chest" == va and 1 == pass then
            spr(131, hashx, hashy, 1, 1) -- cursed_chest
        elseif "inside_empty" == va and 2 == pass and num_cursed_chests > 0 and hint then
            clip()
            spr(166, hashx, hashy, 1, 1) -- cursed_chest_missing
            clip(xl,yt,xr-xl+1,yb-yt+1)
        elseif "open" == va and 1 == pass then
            if hint then 
                spr(147, hashx, hashy, 1, 1) -- opened_chest
            else
                spr(163, hashx, hashy, 1, 1) -- opened_chest
            end
        elseif "chest" != va and "open" != va and 2 == pass and "inside_empty" != va and "empty" != va and num_cursed_chests > 0 and hint then
            if nil == cursed_chests_current_anime[k] or 0 == frame_timer % 1 then
                if rnd(1) < weirdness_chest then
                    --local r = rnd(1)
                    if num_opened_chests > 0 then
                        cursed_chests_current_anime[k] = rnd(1) < 0.5 and 169 or 170
                    else
                        cursed_chests_current_anime[k] = 169
                    end
                else
                    local r = rnd(1)
                    if num_opened_chests > 0 then 
                        if r < 0.25 then 
                            cursed_chests_current_anime[k] = 156
                        elseif r < 0.5 then
                            cursed_chests_current_anime[k] = 172
                        elseif r < 0.75 then 
                            cursed_chests_current_anime[k] = 157
                        elseif r < 1 then 
                            cursed_chests_current_anime[k] = 173
                        end
                    else
                        cursed_chests_current_anime[k] = r < 0.5 and 156 or 172
                    end
                end
            end 
            if nil != cursed_chests_current_anime[k] and -1 != cursed_chests_current_anime[k] then 
                clip()
                spr(cursed_chests_current_anime[k], hashx, hashy, 1, 1) --cursed_chest_unknown
                clip(xl,yt,xr-xl+1,yb-yt+1) 
            end
        end
    end
    cursed_chests_last_frame = {}
    for k, va in pairs(cursed_chests_current_frame) do
        cursed_chests_last_frame[k] = va
    end 
end