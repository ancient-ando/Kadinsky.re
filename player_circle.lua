
radius = 6
max_r = 6
min_r = 2
range = max_r-min_r
radius_percent = (radius-min_r)*100/range


function check_in_circle(x, y, i, j, h)
	if ((i-x)*(i-x) + (j-y)*(j-y) < h*h) then
		return true
	end

	return false;
end

function round_to_eight(n)
	return 8*(flr(n/8));
end

function sweep_circle(x,y,h)
	for i=x-h,x+h do
		for j=y-h,y+h do
			if(check_in_circle(x, y, i, j, h)) then
				if(fget(mget(i, j), 1)) then
					--print("0",round_to_eight(i*8), round_to_eight(j*8),8)
					--print("0",i, i,5)
				end
			end
		end
	end
end


--Currently called by the dream.lua's _update function so that it can print things
function update_bubble(x, y)
	--printh("\ndebug "..bubble_time, "log.txt")
    if bubble_time >= 0.25 and 3 ~= level_index and not player.awaking then
       bubble_time -= 0.25
	   radius = min_r+(range*(bubble_time/max_bubble_time))
       if bubble_time < 0.25 and 5~= level_index and not player.teleporting then
		   --reloads
		   reload_level()
       end
    end

	radius_percent = (radius-min_r)*100/range

    --[[
    for each of the points within radius, if the sprite there has the collider flag (1), print a zero there
    ]]--    

    --sweep_circle(x/8, y/8, radius)
	
	--print(".",x,y,0)
end

sound_time = 80
max_sound_time = 80
--[[current_index = -1 
sound_in_a_row = 0
max_sound_in_a_row = 10]]--
function update_bubble_sounds(index)
	 if sound_time > 0 then
       sound_time -= 1
       if sound_time <= 0 then
           sound_time = max_sound_time
		   if not player.awaking then
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