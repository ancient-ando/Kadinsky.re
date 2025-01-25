
r = 8;
r_change_rate = 0.125


function solid(x, y)
	-- grab the cel value
	val=mget(x, y)
	
	-- check if flag 1 is set (the
	-- orange toggle button in the 
	-- sprite editor)
	return fget(val, 1)
end

function check_in_circle(x, y, i, j, h)
	if ((i-x)*(i-x) + (j-y)*(j-y) < h*h) then
		return true
	end

	return false;
end

function round_to_eight(n)
	return 8*(flr(n/8));
end

function solid_area(x,y,h)
	for i=x-h,x+h do
		for j=y-h,y+h do
			if(check_in_circle(x, y, i, j, h)) then
				if(fget(mget(i, j), 1)) then
					print("0",round_to_eight(i*8), round_to_eight(j*8),5)
				end
			end
		end
	end
end



--Currently called by the dream.lua's _update function so that it can print things
function check_circle(x, y)
    clip()

    --[[
    for each of the points within radius, if the sprite there has the collider flag (1), print a zero there
    ]]--    

    solid_area(x/8, y/8, r)
	
	print(".",x,y,8)

	if btn(2) and r>2 then
		r-=r_change_rate
	end
	if btn(3) and r<8 then
		r+=r_change_rate
	end
end
