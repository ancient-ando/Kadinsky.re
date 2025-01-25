
r = 30;
r_change_rate = 1


function solid(x, y)
	-- grab the cel value
	val=mget(x, y)
	
	-- check if flag 1 is set (the
	-- orange toggle button in the 
	-- sprite editor)
	return fget(val, 2) 
end

function check_in_circle(x, y, i, j)
	if ((i-x)*(i-x) + (j-y)*(j-y) < r*r) then
		return true
	end

	return false;
end

function solid_area(x,y,h)
	for i=x-h,x+h do
		for j=y-h,y+h do
			if(check_in_circle(x, y, i, j)) then
				local i2 = i / 8
				local j2 = j / 8
				if(fget(mget(i2, j2), 1)) then
					print("0",i, j,5)
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

    solid_area(x, y, r)
	
	print(".",x,y,8)

	if btn(2) and r>10 then
		r-=r_change_rate
	end
	if btn(3) and r<30 then
		r+=r_change_rate
	end
end
