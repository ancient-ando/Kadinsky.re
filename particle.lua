particles = {}

function bool2num(b)
    if (b) then return 1
    else return 0 end
end
function init_particles(num)
    --
    if #particles >= num then return end
    if 0 ~= shift_x or 0 ~= shift_y then 
        for i = 0, num - #particles, 1 do
            a_y = abs(shift_y)
            a_x = abs(shift_x)
            area_y = a_y * (max_x - min_x)
            area_x = a_x * (max_y - min_y - a_y)

            local r = rnd(1)
            local e = 0.001
            local p_x = r < area_y / (area_y + area_x) and rnd(max_x - min_x) + e or rnd(a_x) + (max_x - min_x - a_x) * bool2num(shift_x < 0)
            local p_y = r < area_y / (area_y + area_x) and rnd(a_y) + (max_y - min_y - a_y) * bool2num(shift_y < 0) or a_y * bool2num(shift_y > 0) + rnd(max_y - min_y - a_y) + e
            
            add(particles, {
                x = p_x,
                y = p_y,
                s = 0 + flr(rnd(5)/4),
                spd = 0.25 + rnd(0.25),
                off = rnd(0.25),
                c = 6 + flr(0.5 + rnd(1)),
                t = 0
                })
            
            --[[if rnd(1) < area_y / (area_y + area_x) then
                add(particles, {
                x = rnd(max_x - min_x),
                --y = rnd(max_y - min_y),
                y = rnd(a_y) + (max_y - min_y - a_y) * bool2num(shift_y < 0),
                s = 0 + flr(rnd(5)/4),
                spd = 0.25 + rnd(0.25),
                off = rnd(0.25),
                c = 6 + flr(0.5 + rnd(1)),
                t = 0
                })
            else
                add(particles, {
                x = rnd(a_x) + (max_x - min_x - a_x) * bool2num(shift_x < 0), 
                y = a_y * bool2num(shift_y > 0) + rnd(max_y - min_y - a_y),
                s = 0 + flr(rnd(5)/4),
                spd = 0.25 + rnd(0.25),
                off = rnd(0.25),
                c = 6 + flr(0.5 + rnd(1)),
                t = 0
                })
            end]]--
            
        end
    else
        for i = 0, num - #particles, 1 do
            add(particles, {
                x = rnd(max_x - min_x),
                y = rnd(max_y - min_y),
                s = 0 + flr(rnd(5)/4),
                spd = 0.25 + rnd(0.25),
                off = rnd(0.25),
                c = 6 + flr(0.5 + rnd(1)),
                t = 0
            })
        end
    end 
end


function update_particles()
    foreach(particles, function(p)
        p.t += 1
        local mul = level_index < 6 and 1 or 3 

        p.y -= p.spd / mul
        p.x += 0.25 * sin(p.off) / mul
        p.y += shift_y
        p.x += shift_x 
        p.off += min(0.05, p.spd / 32)

        if p.y < -4 then 
            p.y = max_y - min_y
            p.x = rnd(max_x - min_x)
        end
        if p.t >= 1200 or p.x < 0 or p.x > max_x - min_x or p.y < 0 or p.y > max_y - min_y then
            del(particles, p)
        end
    end)
end

function render_particles()
    -- particles
    foreach(particles, function(p)
        rectfill(p.x, p.y, p.x + p.s, p.y + p.s, p.c)
    end)
end

smoke = {}
function init_smoke(obj)
    if air then 
        add(smoke, {
            spr = 141,
            spdy = - 0.1,
            spdx = 0.1 + rnd(0.2),
            x = obj.x + -1 + rnd(2),
            y = obj.y + -1 + rnd(2) + 4,
            flipx = rnd(1) < 0.5,
            flipy = rnd(1) < 0.5
        })
    end
end
function update_smoke()
    foreach(smoke, function (s)
        if 7 == level_index then 
            s.spr += 0.02
        else
            s.spr += 0.2
        end
        s.x += s.spdx 
        s.y += s.spdy 

        s.x += shift_x
        s.y += shift_y

        if s.spr >= 144 then
            del(smoke, s)
        end
    end)
end
function render_smoke()
    foreach(smoke, function (s)
        spr(flr(s.spr), s.x, s.y, 1, 1, s.flipx, s.flipy)
    end)
end

ctable = {9, 12, 14, 15}
foam = {}
function init_foam(obj)
    if water then 
        add(foam, {
            spr = flr(158.5 + rnd(1)),
            spdx = - 0.1,
            spdy = 0.25 + rnd(0.25),
            x = obj.x + -1 + rnd(2),
            y = obj.y + -1 + rnd(2) + 4,
            off = rnd(0.25),
            c = ctable[flr(1.5 + rnd(3))],
            --c = 12,
            t = 0,
            s = 0 + flr(rnd(7)/4),
        })
    end
end
function update_foam()
    foreach(foam, function (f)
        f.t += 1
        if f.t >= 1200 or f.y < min_y then
            del(foam, f)
        end

        local mul = 7 == level_index and 3 or 1
        f.y -= f.spdy / mul
        f.x += 0.25 * sin(f.off) / mul + f.spdx
        
        f.y += shift_y
        f.x += shift_x 

        f.off += min(0.05, f.spdy / 32)
        
    end)
end
function render_foam()
    foreach(foam, function (f)
        --spr(f.spr, f.x, f.y, 1, 1, f.flipx, f.flipy)
        circ(f.x, f.y, f.s, f.c)
    end)
end
