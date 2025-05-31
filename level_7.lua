pearson = {}
seed = 0
function init_pearson(seed)
    srand(seed)
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

--[[function hash_pearson(x, y)
    local data = {x % 256, flr(x / 256), y % 256, flr(y / 256)}
    local h = count(data)
    foreach(data, function(d)
        h = pearson[h ^^ d]
    end)
    return h
end]]--

function dream_infinity()
    if not new_infinity then return end
    local c_r = ceil(sqrt(player.bubble_size) / 8) + 0.5
    local c_x, c_y = mid_x / 8, mid_y / 8
    local cmin_x, cmax_x = min_x / 8, max_x / 8
    local cmin_y, cmax_y = min_y / 8, max_y / 8

    -------------------------
    ----Cloud Generation-----

    --(deterministic first)--
    --seed = hash_pearson(tshift_x, tshift_y)

    -------------------------
    for i = cmin_x + 1, cmax_x - 2, 1 do
        for j = cmin_y + 1, cmax_y - 2, 1 do
            if (i - c_x) * (i - c_x) + (j - c_y) * (j - c_y) >= c_r * c_r then
                -------------------------
                --Procedural Generation--
                if (c_y - j) + tshift_y / 8 < -10 then 
                    mset(i, j, 82)
                else
                    mset(i, j, 0)
                end
                -------------------------
            end
        end
    end
end