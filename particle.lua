particles = {}
function init_particles(num)
    --
    for i = 0, num - count(particles), 1 do
        add(particles, {
            x = rnd(max_x - min_x + tshift_x),
            y = rnd(max_y - min_y + tshift_y),
            s = 0 + flr(rnd(5)/4),
            spd = 0.25 + rnd(0.25),
            off = rnd(0.25),
            c = 6 + flr(0.5 + rnd(1)),
            t = 0
        })
    end
    
end

function render_particles()
    -- particles
    foreach(particles, function(p)
        p.t += 1
        if p.t >= 1200 or p.x < min_x or p.x > max_x or p.y < min_y or p.y > max_y then
            del(foam, p)
        end
        p.y -= p.spd
        p.x += 0.25 * sin(p.off)
        p.y += shift_y
        p.x += shift_x 
        p.off += min(0.05, p.spd / 32)
        rectfill(p.x, p.y, p.x + p.s, p.y + p.s, p.c)
        if p.y < -4 then 
            p.y = max_y - min_y
            p.x = rnd(max_x - min_x)
        end
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
        if f.t >= 300 or f.y < min_y then
            del(foam, f)
        end
        f.y -= f.spdy 
        f.x += 0.25 * sin(f.off) + f.spdx

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
