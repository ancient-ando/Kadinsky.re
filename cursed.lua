cursed_keys_current_frame = {}
cursed_keys_last_frame = {}

cursed_chests_current_frame = {}
cursed_chests_last_frame = {}

srand(1)
num_cursed_keys = 3
num_keys_get = 0

num_cursed_chests = 1
num_opened_chests = 0

function get_hash(celx, cely)
    return 100 * celx + cely
end
function get_hashx(h)
    return flr(h / 100) * 8
end
function get_hashy(h)
    return h % 100 * 8
end
critical_distance = 20
function get_cursed_keys()
    celx = flr(player.x / 8)
    cely = flr(player.y / 8)
    if fget(mget(celx, cely), 7) then 
    if #(v(celx * 8, cely * 8)-v(player.x, player.y)) < critical_distance then
        printh('\n new key found', 'log.txt')
        printh('\n new key found'..num_keys_get, 'log.txt')
        if "key" == cursed_keys_last_frame[get_hash(celx, cely)] then
            num_keys_get += 1
            num_cursed_keys -= 1
            cursed_keys_last_frame[get_hash(celx, cely)] = "inside_empty"
        end
    end
    end
end
function get_cursed_chests()
    celx = flr(player.x / 8)
    cely = flr(player.y / 8)
    if fget(mget(celx, cely), 6) then 
    if #(v(celx * 8, cely * 8)-v(player.x, player.y)) < critical_distance then
        printh('\n new chest found', 'log.txt')
        
        if "chest" == cursed_chests_last_frame[get_hash(celx, cely)] and num_keys_get > 0 then
            num_cursed_chests -= 1
            cursed_chests_last_frame[get_hash(celx, cely)] = "open"
            num_opened_chests += 1
            num_keys_get -= 1
            if num_opened_chests >= num_cursed_chests then
                load_next_level()
            end
        end
    end
    end
end

function render_cursed_keys()
    --[[for k, va in pairs(cursed_keys_current_frame) do
        cursed_keys_current_frame[k] = "none"
    end
    while #cursed_keys_current_frame > 0 do
        del(cursed_keys_current_frame)
    end]]--
    --printh('\n new', 'log.txt')
    for k, va in pairs(cursed_keys_last_frame) do
        --printh('\ndebug: k va='..k.x..k.y..va,'log.txt')
    end
    --printh('\ndebug: x ='..player.x,'log.txt')
    cursed_keys_current_frame = {}
    


    local x1 = cam_x 
    local x2 = cam_x + 128
    local y1 = cam_y
    local y2 = cam_y + 128

    for i = x1 + 1, x2 - 1, 8 do
        for j = y1 + 1, y2 - 1, 8 do
            celx = flr((i ) / 8)
            cely = flr((j ) / 8)
            if fget(mget(celx, cely), 7) then 
                if #(v(celx * 8, cely * 8)-v(player.x, player.y)) < player.bubble_size then
                cursed_keys_current_frame[get_hash(celx, cely)] = "inside"
                --printh('\ndebug: current='..cursed_keys_current_frame[get_hash(celx, cely)]..'inside','log.txt')
                --spr(102, flr(celx) * 8, flr(cely) * 8, 1, 1)
                --printh('\ndebug: celx cely='..celx..cely..'inside','log.txt')
                --printh('\ndebug: map='..celx..cely..'inside','log.txt')
                rect(celx * 8, cely * 8, celx * 8 + 8, cely * 8 + 8, 7)
                else  
                cursed_keys_current_frame[get_hash(celx, cely)] = "outside"
                end
            end
        end
    end
    allocated_keys = 0
    potential_keys = #cursed_keys_current_frame
    for k, va in pairs(cursed_keys_last_frame) do
        --printh('\ndebug: k va 2='..k..va,'log.txt')
        --printh('\ndebug: current 2='..cursed_keys_current_frame[k]..'inside','log.txt')
        --if nil~= cursed_keys_current_frame[k] then printh('\ndebug: impo ='..cursed_keys_current_frame[k],'log.txt')
        --end
        if "inside" == cursed_keys_current_frame[k] and "key" == va then 
            allocated_keys += 1
            cursed_keys_current_frame[k] = "key"
            potential_keys -= 1
        elseif "inside" == cursed_keys_current_frame[k] and "inside_empty" == va then
            cursed_keys_current_frame[k] = "inside_empty"
            potential_keys -= 1
        end
    end

    for k, va in pairs(cursed_keys_current_frame) do
        if "inside" == va then
        if allocated_keys < num_cursed_keys and rnd(1) < 1 then -- this number controls how cursed it is, 0 means devil, 1 means normal
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
    --n = 0
    --while n < 100 do
    --[[while allocated_keys < num_cursed_keys and 0 ~= potential_keys  do
        no = flr(rnd(#cursed_keys_current_frame)) + 1
        rect(60, 60, 60 + potential_keys * 10, 70, 7)
        n += 1
        i = 0
        for k, va in pairs(cursed_keys_current_frame) do
            i += 1
            if i == no then 
                
                if "inside" == va then
                    rect(10, 10, 20, 20, 7)
                    cursed_keys_current_frame[k] = "key"
                    allocated_keys += 1 
                    potential_keys -= 1
                
                elseif "outside" == va then
                    --cursed_keys_current_frame[k] = "outside-key"
                    allocated_keys += 1
                    potential_keys -= 1
                end 
            end
        end 
    end]]--
    for k, va in pairs(cursed_keys_current_frame) do
        if "key" == va then
            spr(128, get_hashx(k), get_hashy(k), 1, 1) -- cursed_key
        elseif "inside_empty" == va or "outside_empty" == va or "empty" == va then
            --spr(117, get_hashx(k), get_hashy(k), 1, 1) -- empty_key
            --cursed_keys_current_frame[k] = nil
        end
    end
    --[[for k, va in pairs(cursed_keys_last_frame) do
        cursed_keys_last_frame[k] = "none"
    end ]]--
    cursed_keys_last_frame = {}
    for k, va in pairs(cursed_keys_current_frame) do
        cursed_keys_last_frame[k] = va
        --printh('\ndebug: k va='..k.x,'log.txt')
    end 
    
    --cursed_keys_last_frame = cursed_keys_current_frame
end

function render_cursed_chests()
    cursed_chests_current_frame = {}
    

    local x1 = cam_x 
    local x2 = cam_x + 128
    local y1 = cam_y
    local y2 = cam_y + 128

    for i = x1 + 1, x2 - 1, 8 do
        for j = y1 + 1, y2 - 1, 8 do
            celx = flr((i ) / 8)
            cely = flr((j ) / 8)
            if fget(mget(celx, cely), 6) then 
                if #(v(celx * 8, cely * 8)-v(player.x, player.y)) < player.bubble_size then
                cursed_chests_current_frame[get_hash(celx, cely)] = "inside"
                --printh('\ndebug: current='..cursed_keys_current_frame[get_hash(celx, cely)]..'inside','log.txt')
                --spr(102, flr(celx) * 8, flr(cely) * 8, 1, 1)
                --printh('\ndebug: celx cely='..celx..cely..'inside','log.txt')
                --printh('\ndebug: map='..celx..cely..'inside','log.txt')
                rect(celx * 8, cely * 8, celx * 8 + 8, cely * 8 + 8, 6)
                else  
                cursed_chests_current_frame[get_hash(celx, cely)] = "outside"
                end
            end
        end
    end
    allocated_chests = 0
    potential_chests = #cursed_chests_current_frame
    for k, va in pairs(cursed_chests_last_frame) do
        --printh('\ndebug: k va 2='..k..va,'log.txt')
        --printh('\ndebug: current 2='..cursed_keys_current_frame[k]..'inside','log.txt')
        --if nil~= cursed_keys_current_frame[k] then printh('\ndebug: impo ='..cursed_keys_current_frame[k],'log.txt')
        --end
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
        if allocated_chests <= num_cursed_chests and rnd(1) < 0.5 then -- this number controls how cursed it is, 0 means devil, 1 means normal
            if num_allocated_opened_chests < num_opened_chests then 
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
    --n = 0
    --while n < 100 do
    --[[while allocated_keys < num_cursed_keys and 0 ~= potential_keys  do
        no = flr(rnd(#cursed_keys_current_frame)) + 1
        rect(60, 60, 60 + potential_keys * 10, 70, 7)
        n += 1
        i = 0
        for k, va in pairs(cursed_keys_current_frame) do
            i += 1
            if i == no then 
                
                if "inside" == va then
                    rect(10, 10, 20, 20, 7)
                    cursed_keys_current_frame[k] = "key"
                    allocated_keys += 1 
                    potential_keys -= 1
                
                elseif "outside" == va then
                    --cursed_keys_current_frame[k] = "outside-key"
                    allocated_keys += 1
                    potential_keys -= 1
                end 
            end
        end 
    end]]--
    for k, va in pairs(cursed_chests_current_frame) do
        if "chest" == va then
            spr(131, get_hashx(k), get_hashy(k), 1, 1) -- cursed_chest
        elseif "inside_empty" == va or "outside_empty" == va or "empty" == va then
            --spr(117, get_hashx(k), get_hashy(k), 1, 1) -- empty_chest
            --cursed_keys_current_frame[k] = nil
        elseif "open" == va then
            spr(147, get_hashx(k), get_hashy(k), 1, 1) -- opened_chest
        end
    end
    --[[for k, va in pairs(cursed_keys_last_frame) do
        cursed_keys_last_frame[k] = "none"
    end ]]--
    cursed_chests_last_frame = {}
    for k, va in pairs(cursed_chests_current_frame) do
        cursed_chests_last_frame[k] = va
        --printh('\ndebug: k va='..k.x,'log.txt')
    end 
    
    --cursed_keys_last_frame = cursed_keys_current_frame
end