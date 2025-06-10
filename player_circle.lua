
radius, max_r, min_r = 6, 6, 2
range = max_r-min_r
radius_percent = (radius-min_r)*100/range

--Currently called by the dream.lua's _update function so that it can print things
function update_bubble(x, y)
	--printh("\ndebug "..bubble_time, "log.txt")
    if bubble_time >= 0.25 and 6 > level_index and 3 ~= level_index and not player.awaking then
       bubble_time -= 0.25
	   
       if bubble_time < 0.25 and 5~= level_index and not player.teleporting then
		   --reloads
		   reload_level()
       end
    end
	radius = min_r + range * (bubble_time / max_bubble_time)
	radius_percent = player.awaking and 0.001 or (radius - min_r) * 100 / range

end

sound_time, max_sound_time = 80, 80  
last_time = time()

function update_bubble_sounds(index)
	--[[if sound_time > 0 then
       sound_time -= 1
       if sound_time <= 0 then
           sound_time = max_sound_time * (6 == index and 2 or 1)
		   if not player.awaking and 6 > level_index then
			psfx(index)
		   end
       end
    end]]--
	max_sound_time = 6 == index and 160/3 or 80/3
	current_time = time()
	if current_time - last_time > max_sound_time / 60 then 
		last_time = current_time
		if not player.awaking and 6 > level_index then
			psfx(index)
		end
	end
end

function get_brightness(min_b, max_b)
	local size = (radius_percent * (max_b-min_b) / 100) + min_b
	if size >= 0.8 then
		update_bubble_sounds(06)
	elseif size >= 0.5 then
		update_bubble_sounds(08)
	elseif bubble_time >= 27 then
		update_bubble_sounds(09)
	elseif 5!= level_index then 
		update_bubble_sounds(10)
	else
		update_bubble_sounds(-1)
	end

	return size
end