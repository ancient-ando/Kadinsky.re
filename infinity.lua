new_infinity = false
function dream_infinity()
    if not new_infinity then return end
    local c_r = ceil(sqrt(player.bubble_size) / 8) + 1.5
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
                if rnd(1) < min(0.5, (dream_shift + 1) / (dream_shift + time_shift + 2)) then
                    local s = rnd(1)
                    if s < 0.6 then
                        mset(i, j, 121)
                    elseif s < 0.8 then
                        mset(i, j, 120)
                    elseif s < 0.9 then 
                        mset(i, j, 119)
                    elseif s < 0.95 then
                        mset(i, j, 118)
                    else
                        if abs(target_x - tshift_x) < 64 and abs(target_y - tshift_y) < 64 then
                            mset(i, j, 133)
                        elseif rnd(1) < 0.5 then 

                            if target_x < tshift_x then 
                                if (target_x - tshift_x) / target_x < 0.5 then  
                                    mset(i, j, 36)
                                else 
                                    mset(i, j, 40)
                                end
                            else 
                                if (target_x - tshift_x) / target_x < 0.5 then
                                    mset(i, j, 35)
                                else
                                    mset(i, j, 39)
                                end
                            end
                        else 
                            
                            if target_y < tshift_y then
                                if (target_y - tshift_y) / target_y < 0.5 then
                                    mset(i, j, 38)
                                else
                                    mset(i, j, 42)
                                end
                            else
                                if (target_y - tshift_y) / target_y < 0.5 then
                                    mset(i, j, 37)
                                else 
                                    mset(i, j, 41)
                                end
                            end
                        end 
                    end
                else
                    mset(i, j, 0)
                end
                -------------------------
            end
        end
    end

end

function shift_infinity()
    if not new_infinity then return end
    local c_r = ceil(sqrt(player.bubble_size) / 8) + 1.5
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
    new_infinity = false
    cshift_x = 0
    cshift_y = 0
    shift_x = 0
    shift_y = 0
    if 6 == level_index then
        if frame_timer - infinite_timer > 200 or player.x < q1_x or player.x > q3_x or player.y < q1_y or player.y > q3_y then
            if player.x < q1_x or player.x > q3_x or player.y < q1_y or player.y > q3_y then
                dream_shift += 1
            else
                time_shift += 1
            end
            
            new_infinity = true 
            infinite_timer = frame_timer
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