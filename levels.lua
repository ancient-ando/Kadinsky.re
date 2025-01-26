
--[[
Inspired by Celestes approach, maps will be one big grid that 
the player navigates layer by layer
When the player dies, load the current layer
When they reach the exit, load the next layer
The next layer will just be the current layer + a height offset
Loading entails moving the player and changing the bounds of the camera

]]--

--simple camera
cam_x = 0
cam_y = 0

--map limits 
map_start = 0
map_end = 640


function load_level(x, y)
	cam_y = y
	player_init(59, 59+y)
	bubble_time = max_bubble_time

end

--called in update function
function camera_update()

    --simple camera
    cam_x = player.x - 64 + player.w / 2
    if cam_x < map_start then
        cam_x = map_start
    end
    if cam_x > map_end - 128 then
        cam_x = map_end - 128
    end

end

--Called in draw function
function draw_cam()
    clip() 
   camera(cam_x, cam_y)
end