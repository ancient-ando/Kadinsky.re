sfx_timer = 0
function psfx(sfx_index)
    if sfx_timer <= 0 then
        sfx(sfx_index)
    end
end

function update_sfx()
    if sfx_timer > 0 then
        sfx_timer -= 1
    end
end


-- Dangerous functions follow 
function set_sfx_speed(sfx, speed)
  poke(0x3200 + 68*sfx + 65, speed)
end