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