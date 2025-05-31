pearson = {}
seed = 0
function init_pearson(s)
    pearson = {}
    srand(s)
    for i = 0, 255, 1 do 
        add(pearson, i)
    end
    for i = 255, 1, -1 do
        local j = flr(rnd(i))
        local k = pearson[i]
        pearson[i] = pearson[j]
        pearson[j] = k
    end
end
init_pearson(0)

function hash_pearson(x, y)
    x, y = x \ 128 * 128, y \ 128 * 128
    local data = {x % 256, x \ 256 % 256, y % 256, y \ 256 % 256}
    local h = #data
    foreach(data, function(d)
        --printh('\n data ' .. d, 'log.txt')
        h = pearson[bxor(h, d)]
    end)
    return h
end

function try_mset(x, y, snum)
    --printh("try_mset->init :"..x.." "..y, "log.txt")
    --printh("c ".. cmin_x.. " ".. cmax_x .. " " .. cmin_y .. " " .. cmax_y, "log.txt")
    if x <= cmin_x or x >= cmax_x or y <= cmin_y or y >= cmax_y then return end
    if (x - c_x) * (x - c_x) + (y - c_y) * (y - c_y) < c_r2 then return end
    local f = fget(mget(x, y))
    --printh("f " .. f, "log.txt")
    if 0 != f and f <= fget(snum) then return end 
    printh("try_mset->succeed :"..x.." "..y, "log.txt")
    mset(x, y, snum)
end

function dream_infinity()
    if true then return end
    if not new_infinity then return end
    c_r = ceil(sqrt(player.bubble_size) / 8) + 0.5
    c_r2 = c_r * c_r
    c_x, c_y = mid_x / 8, mid_y / 8
    cmin_x, cmax_x = min_x / 8, max_x / 8
    cmin_y, cmax_y = min_y / 8, max_y / 8

    for i = cmin_x + 1, cmax_x do
        for j = cmin_y + 1, cmax_y do
            if (i - c_x) * (i - c_x) + (j - c_y) * (j - c_y) >= c_r * c_r then
                mset(i, j, 0)
            end
        end
    end

    -------------------------
    ----Cloud Generation-----

    --(deterministic first)--
    seed = hash_pearson(tshift_x, tshift_y)
    srand(seed)
    --------[Cumulus]--------
    num_cloud = rnd(5)
    for i = 0, num_cloud do 
        local h, x, y = rnd(5) + 2, rnd(24) + 4, rnd(24) + 4
        local cloud_x, cloud_y = x, y
        local l, r = x, x + flr(rnd(h / 2)) + 1
        try_mset(l - 16 + c_x, y - 16 + c_y, 85)
        try_mset(r - 16 + c_x, y - 16 + c_y, 84)
        for k = l + 1, r do
            try_mset(k - 16 + c_x, y - 16 + c_y, 98)
        end
        for j = 0, h do 
            y += 1
            for k = l, r + 1 do 
                try_mset(k - 16 + c_x, y - 16 + c_y, 100)
            end
            if rnd(2) < 1 then
                l -= 1
                try_mset(l - 16 + c_x, y - 16 + c_y, 98)
            end
            if rnd(2) < 1 then 
                r += 1
                try_mset(r - 16 + c_x, y - 16 + c_y, 98)
            end 
            l -= 1
            r += 1
            try_mset(l - 16 + c_x, y - 16 + c_y, 85)
            try_mset(r - 16 + c_x, y - 16 + c_y, 84)
        end
    end

    -------------------------
    for i = cmin_x + 1, cmax_x do
        for j = cmin_y + 1, cmax_y do
            if (i - c_x) * (i - c_x) + (j - c_y) * (j - c_y) >= c_r * c_r then
                --------------------------
                ----Terrain Generation----
                if (c_y - j) + tshift_y / 8 < -10 then 
                    mset(i, j, 82)
                else
                    mset(i, j, 0)
                end
                --------------------------
            end
        end
    end
end