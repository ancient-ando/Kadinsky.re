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