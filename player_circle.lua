
radius = 6
max_r = 6
min_r = 2
range = max_r-min_r
radius_percent = (radius-min_r)*100/range
bubble_time = 120
max_bubble_time = 120

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
					print("0",round_to_eight(i*8), round_to_eight(j*8),8)
					--print("0",i, i,5)
				end
			end
		end
	end
end


level_index = 0
--Currently called by the dream.lua's _update function so that it can print things
function update_bubble(x, y)
    if bubble_time > 0 then
       --bubble_time -= 0.25
	   radius = min_r+(range*(bubble_time/max_bubble_time))
       if bubble_time <= 0 then
           --reset()
		   level_index+= 1
		   if(level_index > 3) then
			level_index = 0
		   end
		   load_level(0, level_index*16*8)
		   
       end
    end

	radius_percent = (radius-min_r)*100/range

    --[[
    for each of the points within radius, if the sprite there has the collider flag (1), print a zero there
    ]]--    

    sweep_circle(x/8, y/8, radius)
	
	print(".",x,y,8)
end

function get_brightness(min_b, max_b)
	return (radius_percent * (max_b-min_b) / 100) + min_b
end