new_infinity = false

function shift_infinity()
    if not new_infinity then return end
    c_r = ceil(sqrt(player.bubble_size) / 8) + 2.5
    c_r2 = c_r * c_r 
    local s_x, s_y = sgn(cshift_x), sgn(cshift_y)
    c_x, c_y = mid_x / 8, mid_y / 8
    p_x, p_y = player.x / 8, player. y / 8
    cmin_x, cmax_x = min_x / 8, max_x / 8
    cmin_y, cmax_y = min_y / 8, max_y / 8
    for i = p_x + s_x * c_r, p_x - s_x * c_r, -s_x do 
        for j = p_y + s_y * c_r, p_y - s_y * c_r, -s_y do
            if (i - p_x) * (i - p_x) + (j - p_y) * (j - p_y) < c_r2 then
                mset(i, j, mget(i - cshift_x, j - cshift_y))
            end
        end
    end


end

function update_infinity()
    new_infinity = false
    cshift_x, cshift_y, shift_x, shift_y = 0, 0, 0, 0
    if 6 <= level_index then
        if 0 == infinite_timer or player.x < q1_x or player.x > q3_x or player.y < q1_y or player.y > q3_y then
            if player.x < q1_x or player.x > q3_x or player.y < q1_y or player.y > q3_y then
                dream_shift += 1
            else
                time_shift += 1
            end
            new_infinity = true 
            infinite_timer = frame_timer
            shift_x, shift_y = mid_x - player.x, mid_y - player.y
            cshift_x, cshift_y = flr(shift_x / 64 + 0.5) * 8, flr(shift_y / 64 + 0.5) * 8
            --cshift_x, cshift_y = flr(shift_x / 8 + 0.5), flr(shift_y / 8 + 0.5)
            shift_x, shift_y = cshift_x * 8, cshift_y * 8
            player.x += shift_x
            player.y += shift_y
            tshift_x += shift_x
            tshift_y += shift_y
        end
    end
end