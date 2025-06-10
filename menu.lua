hint = false

menuitem(1, "hints: off", 
function(k)
    if 112 == k then 
        if hint then 
            fail_in_a_row = 0
        end
        hint = not hint
        menuitem(nil, "hints: "..(hint and "on" or "off"))
    end
    return true
end)


function menu_update()
    menuitem(1, "hints: "..(hint and "on" or "off"), 
    function(k)
        if 112 == k then 
            if hint then 
                fail_in_a_row = 0
            end
            hint = not hint
            menuitem(nil, "hints: "..(hint and "on" or "off"))
        end
        return true
    end)
end

info = false
menuitem(3, "<INFO>: off", 
function(k)
    if 112 == k then 
        info = not info
        menuitem(nil, "<INFO>: "..(info and "on" or "off"))
    end
    return true
end)


function menu_update()
    menuitem(3, "<INFO>: "..(info and "on" or "off"), 
    function(k)
        if 112 == k then 
            info = not info
            menuitem(nil, "<INFO>: "..(info and "on" or "off"))
        end
        return true
    end)
end


difficulty = 1
menuitem(4, "difficulty: ▮▮-", 
function(k)
    if 2 == k and difficulty < 2 then
        difficulty += 1
    end
    if 1 == k and difficulty > 0 then 
        difficulty -= 1
    end
    diff_display = "difficulty: "
    for i = 0, difficulty, 1 do 
        diff_display = diff_display .. ("▮")
    end 
    for i = difficulty + 1, 2, 1 do
        diff_display = diff_display .. "-"
    end
    if 2 == difficulty then
        diff_display = diff_display .. "▮"
    end
    menuitem(nil, diff_display)
    return true
end)

level = 0
menuitem(2, "level: ?", 
function(k)
    if 2 == k and 5 ~= level then
        level = next_level[level]
    end
    if 1 == k and 3 ~= level then 
        level = pre_level[level]
    end
    level_index = level
    reload_level()
    level_display = "level: " .. level
    hint = false
    menuitem(nil, level_display)
    return true
end)