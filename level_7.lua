function dream_infinity()
    if not new_infinity then return end
    local c_r = ceil(sqrt(player.bubble_size) / 8) + 0.5
    local c_x = mid_x / 8
    local c_y = mid_y / 8
    local cmin_x = min_x / 8
    local cmin_y = min_y / 8
    local cmax_x = max_x / 8
    local cmax_y = max_y / 8
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