pearson = {}
seed = 0
function init_pearson(s)
    pearson = {}
    srand(s)
    for i = 0, 255, 1 do 
        pearson[i] = i 
    end
    for i = 255, 1, -1 do
        local j = flr(rnd(i))
        local k = pearson[i]
        pearson[i] = pearson[j]
        pearson[j] = k
    end
end
init_pearson(1024)

--[[function hash_pearson(x, y)
    --x, y = x \ 128 * 128, y \ 128 * 128
    local data = {x % 251, y % 251}
    local h = #data
    foreach(data, function(d)
        --printh('\n data ' .. d, 'log.txt')
        h = pearson[bxor(h, d)]
    end)
    return h
end]]--

function hash_pearson(h, x)
    x %= 251 
    return pearson[bxor(h, x)]
end

function try_mset(x, y, snum)
    --printh("try_mset->init :"..x.." "..y, "log.txt")
    --printh("c ".. cmin_x.. " ".. cmax_x .. " " .. cmin_y .. " " .. cmax_y, "log.txt")
    if x <= cmin_x or x >= cmax_x or y <= cmin_y or y >= cmax_y then return false end
    --if (x - c_x) * (x - c_x) + (y - c_y) * (y - c_y) < c_r2 then return false end
    if (x - p_x) * (x - p_x) + (y - p_y) * (y - p_y) < c_r2 then return false end
    local f = fget(mget(x, y))
    --printh("f " .. f, "log.txt")
    if 0 != f and f < fget(snum) then return false end 
    --printh("try_mset->succeed :"..x.." "..y .." "..snum, "log.txt")
    local s = mget(x, y)
    if f == fget(snum) then
        if 101 == s or (s >= 112 and s <= 115) then
            snum = 116 == snum and 26 or snum
            snum = 117 == snum and 25 or snum
        end
        if s >= 96 and s <= 99 then 
            snum = 85 == snum and 41 or snum
            snum = 84 == snum and 42 or snum
        end 
        if s >= 84 and s <= 85 and 1 == bxor(s, snum) then
            snum = 85 == s and 30 or 27
        end 
        if s >= 116 and s <= 117 and 1 == bxor(s, snum) then
            snum = 28
        end 
        if 84 == snum and 116 == s then 
            snum = 43
        end 
        if 116 == snum and 84 == s then 
            snum = 29
        end 
        if 85 == snum and 117 == s then
            snum = 44
        end
        if 117 == snum and 85 == s then
            snum = 45
        end
        if s < 84 or s > 85 then 
            snum = 85 == snum and 79 or snum
            snum = 84 == snum and 95 or snum
        end 
        snum = (117 == snum and 117 != s) and 127 or snum
        snum = (116 == snum and 116 != s) and 111 or snum
        snum = 96 == snum and 10 or snum
        snum = 98 == snum and 12 or snum
        snum = 97 == snum and 11 or snum
        snum = 99 == snum and 13 or snum
    end
    mset(x, y, snum)
    return true 
end

function cloud_size(s)
    if s > 0.95 then 
        return 5 
    elseif s > 0.9 then 
        return 4
    elseif s > 0.6 then 
        return 3
    elseif s > 0.4 then
        return 2
    elseif s > 0.1 then 
        return 1
    end
    return 0
end

function dream_infinity()
    --if true then return end
    if not new_infinity then return end
    c_r = ceil(sqrt(player.bubble_size) / 8) + 0.5
    c_r2 = c_r * c_r

    for i = cmin_x + 1, cmax_x - 1 do
        for j = cmin_y + 1, cmax_y - 1 do
            if (i - p_x) * (i - p_x) + (j - p_y) * (j - p_y) >= c_r2 then
                mset(i, j, 0)
            end
        end
    end

    -------------------------
    ----Cloud Generation-----

    --(deterministic first)--
    --seed = hash_pearson(tshift_x, tshift_y)
    
    --------[Cumulus]--------
    hash_limit = 32 --(from 16 to 80, 32 recommended)
    z = abs(tshift_x) + abs(tshift_y) 
    if z > 2048 then 
        hash_limit = 64
    elseif z > 1536 then
        hash_limit = 48
    elseif z > 1024 then
        hash_limit = 32
    else
        hash_limit = 16
    end 

    ct = {96, 96, 97, 97, 98, 98, 98, 99, 99}
    cl = {97, 97, 97, 97, 97, 98, 99, 99, 99}
    cr = {99, 99, 98, 96, 96, 96, 96, 96, 96}
    cb = {101, 112, 113, 114, 115, 115, 115, 115, 114}
    cc = #ct 
    c = 0
    for b = min_y, max_y, 16 do
        c = 1 - c
        hashy = hash_pearson(42, b - tshift_y)
        for a = min_x + 8 * c, max_x, 16 do
            --seed = hash_pearson(a - tshift_x, b - tshift_y) 
            seed = hash_pearson(hashy, a - tshift_x)
            if seed <= hash_limit then 
                srand(bxor(a - tshift_x + 1023, b - tshift_y - 1023) + seed)
                local h, x, y = cloud_size(rnd(1)), a \ 8, b \ 8 
                local l, r = x, x + flr(rnd(h / 2)) + 1
                try_mset(l, y, 85)
                try_mset(r, y, 84)
                for k = l + 1, r - 1 do
                    try_mset(k, y, ct[flr(rnd(cc) + 1)])
                end
                for j = 1, h do 
                    y += 1
                    for k = l, r do 
                        try_mset(k, y, 100)
                    end
                    if rnd(2.5) < 1 then
                        l -= 1
                        try_mset(l, y, cl[flr(rnd(cc) + 1)])
                    end
                    if rnd(3) < 1 then 
                        r += 1
                        try_mset(r, y, cr[flr(rnd(cc) + 1)])
                    end 
                    l -= 1
                    r += 1
                    try_mset(l, y, 85)
                    try_mset(r, y, 84)
                end
                y += 1
                try_mset(l, y, 117)
                try_mset(r, y, 116)
                for k = l + 1, r - 1 do
                    try_mset(k, y, cb[flr(rnd(cc) + 1)])
                end
            end 
        end   
    end

    srand(frame_timer)
    -------------------------
    for i = cmin_x + 1, cmax_x - 1 do
        --local r = rnd(5)
        local r = 0
        for j = cmin_y + 1, cmax_y - 1 do
            if (i - p_x) * (i - p_x) + (j - p_y) * (j - p_y) >= c_r2 then
                --------------------------
                ----Terrain Generation----
                if (c_y - j) + tshift_y / 8 < -10 - r then 
                    mset(i, j, 82)
                else
                    --mset(i, j, 0)
                end
                --------------------------
            end
        end
    end
end