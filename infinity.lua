function dream_infinity()
    if 0 == cshift_x and 0 == cshift_y then return end
    local c_r = ceil(sqrt(player.bubble_size) / 8) + 2
    local c_x = mid_x / 8
    local c_y = mid_y / 8
    local cmin_x = min_x / 8
    local cmin_y = min_y / 8
    local cmax_x = max_x / 8
    local cmax_y = max_y / 8
    for i = cmin_x + 1, cmax_x - 2, 1 do
        for j = cmin_y + 1, cmax_y - 2, 1 do
            if (i - c_x) * (i - c_x) + (j - c_y) * (j - c_y) >= c_r * c_r then
                if rnd(1) < 0.25 then
                    mset(i, j, 79)
                else
                    mset(i, j, 0)
                end
            end
        end
    end
end

function shift_infinity()
    if 0 == cshift_x and 0 == cshift_y then return end
    local c_r = ceil(sqrt(player.bubble_size) / 8) + 2
    local s_x = sgn(cshift_x)
    local s_y = sgn(cshift_y)
    local c_x = mid_x / 8
    local c_y = mid_y / 8
    for i = c_x + s_x * c_r, c_x - s_x * c_r, -s_x do 
        for j = c_y + s_y * c_r, c_y - s_y * c_r, -s_y do
            ori_x = (i - cshift_x) * 8 
            ori_y = (j - cshift_y) * 8 
            if (i - c_x) * (i - c_x) + (j - c_y) * (j - c_y) < c_r * c_r and ori_x > min_x and ori_x < max_x and ori_y > min_y and ori_y < max_y then
                mset(i, j, mget(i - cshift_x, j - cshift_y))
            end
        end
    end
end

function update_infinity()
    cshift_x = 0
    cshift_y = 0
    shift_x = 0
    shift_y = 0
    if 6 == level_index then
        if player.x < q1_x or player.x > q3_x or player.y < q1_y or player.y > q3_y then
            shift_x = mid_x - player.x
            shift_y = mid_y - player.y
            cshift_x = flr(shift_x / 8)
            cshift_y = flr(shift_y / 8)
            shift_x = cshift_x * 8
            shift_y = cshift_y * 8
            player.x += shift_x
            player.y += shift_y
            tshift_x += shift_x
            tshift_y += shift_y
        end
    end
end