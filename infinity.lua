function update_infinity()
    if 6 == level_index then
        q3_x = (min_x + 3 * max_x) / 4
        q1_x = (3 * min_x + max_x) / 4
        if player.x > q3_x then
            player.x = q1_x
        end
        q3_y = (min_y + 3 * max_y) / 4
        q1_y = (3 * min_y + max_y) / 4
        if player.y > q3_y then
            player.y = min_y
        end
    end

end