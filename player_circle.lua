
radius = 6
max_r = 6
min_r = 2
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
	radius_percent = (radius - min_r) * 100 / range

end

sound_time = 80
max_sound_time = 80

function update_bubble_sounds(index)
	 if sound_time > 0 then
       sound_time -= 1
       if sound_time <= 0 then
           sound_time = max_sound_time
		   if not player.awaking and 6 > level_index then
			psfx(index, 2)
		   end
       end
    end
end

function get_brightness(min_b, max_b)
	local size = (radius_percent * (max_b-min_b) / 100) + min_b
	if size >= 0.8 then
		update_bubble_sounds(07)
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