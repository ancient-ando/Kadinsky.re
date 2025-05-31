
------------------------------
-- utilities
------------------------------

function round(x)
 return flr(x+0.5)
end

function set(obj,props)
 obj=obj or {}
 for k,v in pairs(props) do
  obj[k]=v
 end
 return obj
end

-- used for callbacks into
-- entities that might or
-- might not have a method
-- to handle an event
--[[function event(ob,name,...)
 local cb=ob[name]
 return type(cb)=="function"
  and cb(ob,...)
  or cb
end]]--


------------------------------
-- class system
------------------------------

-- creates a "class" object
-- with support for basic
-- inheritance/initialization
function kind(kob)
 kob=kob or {}
 setmetatable(kob,{__index=kob.extends})
 
 kob.new=function(self,ob)
  ob=set(ob,{kind=kob})
  setmetatable(ob,{__index=kob})
  if (kob.create) ob:create()
  return ob
 end
 
 return kob 
end


------------------------------
-- entity rendering
------------------------------

-- draws a filled rectangle
-- with a custom fill fn
function crect(x1,y1,x2,y2,ln)
 x1,x2=max(x1,0),min(x2,127)
 y1,y2=max(y1,0),min(y2,127)
 if (x2<x1 or y2<y1) return
 for y=y1,y2 do
  ln(x1,x2,y)
 end
end

-- draws a filled ellipse
-- with a custom fill fn
--[[function cellipse(cx,cy,rx,ry,ln)
 cy,ry=round(cy),round(ry)
 local w=0
 local ryx,rxy=ry/rx,rx/ry
 local dy=(-2*ry+1)*rxy
 local dx=ryx
 local ddx=2*ryx
 local ddy=2*rxy
 local lim=rx*ry
 local v=ry*ry*rxy
 local my=cy+ry-1
 for y=cy-ry,cy-1 do
  -- creep w up until we hit lim
  while true do
   if v+dx<=lim then
    v+=dx
    dx+=ddx
    w+=1
   else
    break
   end
  end
  -- draw line
  if w>0 then
   local l,r=
    mid(cx-w,0,127),
    mid(cx+w-1,0,127)
   if (y>=0 and y<128) ln(l,r,y)
   if (my>=0 and my<128) ln(l,r,my)
  end
  -- go down
  v+=dy
  dy+=ddy
  my-=1
 end
end
]]--
-------------------------------
-- basic fills
-------------------------------

-- a fill function is just
-- a function(x1,x2,y) that
-- draws a horizontal line

-- returns a fill function
-- that draws a solid color
function fl_color(c)
 return function(x1,x2,y)
  rectfill(x1,y,x2,y,c)
 end
end

-- used as fill function
-- for ignored areas
function fl_none()
end

-------------------------------
-- fast blend fill
-------------------------------

-- sets up everything
-- blend_line will need
function init_blending(nlevels)
 -- tabulate sqrt() for speed

 -- populate look-up tables
 -- for blending based on
 -- palettes in sprite mem
 for lv=1,nlevels do
  -- light luts are stored in
  -- memory directly, table
  -- indexing is costly
  local addr = 0x4300 + lv * 0x100
  local sx=lv-1
  for c1=0,15 do
   local nc=sget(sx + 8 * (level_index % 6),c1)
   local topl=shl(nc,4)
   for c2=0,15 do
    poke(addr,
     topl+sget(sx+ 8 * (level_index % 6),c2))
    addr+=1
   end
  end
 end 
end

_sqrt={}
for i=0,4096 do
 _sqrt[i]=sqrt(i)
end
_shl6 = {}
for i = 0, 127 do
 _shl6[i] = shl(i, 6)
end 

function fl_blend(l)
 local lutaddr = 0x4300 + shl(l, 8)
    return function(x1,x2,y)
     local laddr=lutaddr
     local yaddr = 0x6000 + _shl6[y]
     local saddr,eaddr=
      mid(0x6001, 0x7ffe, yaddr + ((x1 + 1) >> 1) & 0xffff), 
      mid(0x7ffe, 0x6001, yaddr + ((x2 - 1) >> 1) & 0xffff)
     
     -- full bytes
      for addr = saddr, eaddr do 
      poke(addr,
       @(
        laddr | @(addr)
       )
      )
     end
     -- odd pixel on left?
     if (x1 & 1.99995) >= 1 then 
      local a=saddr-1
      local v = @(a)
      poke(a,
      (v & 0xf) | 
      (@(laddr | v) & 0xf0)
      )
     end
     -- odd pixel on right?
     if (x2 & 1.99995) < 1 then 
      local a=eaddr+1
      local v = @(a)
      poke(a,
      (@(laddr | v) & 0x0f) |
      (v & 0xf0)
      )
     end
    end
end

-------------------------------
-- lighting
-------------------------------

-- determines how far each
-- level of light reaches
-- this is distance *squared*
-- due to the ordering here,
-- light level 1 is the
-- brightest, and 6 is the
-- darkest (pitch black)
light_rng={
 10*42,17*42,
 24*42,32*42,
 39*42,
} -- 10, 18, 26, 34, 42 
-- special "guard" value
-- to ensure nothing can be
-- light level 0 without ifs
light_rng[0]=-1000

--  this is our "light" fill
-- function.
--  it operates by dimming
-- what's already there.
--  each horizontal line
-- is drawn by multiple
-- calls to another fill
-- function handling
-- the correct light level
-- for each segment.
light_fills={
 fl_none,fl_blend(2),fl_blend(3),
 fl_blend(4),fl_blend(5),fl_color(0)
}
brkpts={}
function fl_light(lx,ly,brightness,ln)
 local brightnessf,fills=
  brightness*brightness,
  light_fills
 return function(x1,x2,y)
  -- transform coordinates
  -- into light-space
  local ox,oy,oe=x1-lx,y-ly,x2-lx
  --printh("o "..ox.." "..oy.." "..oe, "log.txt")
  -- brightness range multiplier
  -- + per line flicker effect
  local mul=
   brightnessf * 
    (rnd(0.16)+0.92)
  -- calculate light levels
  -- at left end, right end,
  local ysq=oy*oy
  local srng,erng,slv,elv=
   ysq+ox*ox,
   ysq+oe*oe
  for lv=5,0,-1 do
   local r = (light_rng[lv] * mul) & 0xffff
   if not slv and srng>=r then
    slv=lv+1
    if (elv) break
   end
   if not elv and erng>=r then
    elv=lv+1
    if (slv) break
   end
  end
  -- these will hold the
  -- lowest/highest light
  -- level within our line
  local llv,hlv=1,max(slv,elv)  
  -- calculate breakpoints
  -- (x coordinates at which
  --  light level changes,
  --  in light-space)
  -- and lowest(brightest)
  -- light level within line
  --local mind=max(x1-lx,lx-x2)
  local mind = min(x1 - lx, lx - x2)
  for lv=hlv-1,1,-1 do
   local brng = (light_rng[lv] * mul) & 0xffff
   local brp=_sqrt[brng-ysq] 
   brkpts[lv]=brp
   if not brp or brp>-mind then
    llv=lv+1
    break
   end
  end
  -- everything calculated,
  -- draw all segments now!
  local xs,xe=lx+ox
  -- from left bound to
  -- start of most-lit segment
  -- decreasing light lv
  -- (brightness increasing)
  if nil ~= slv then
    for l=slv,llv+1,-1 do
    xe=ceil(lx-brkpts[l-1])
    fills[l](xs,xe-1,y)
    xs=xe
    end
  end
  -- from most-lit zone
  -- to last break point
  -- increasing light lv
  -- (brightness decreasing)
  if nil ~= elv then 
    for l=llv,elv-1 do 
    xe=ceil(lx+brkpts[l])
    fills[l](xs,xe-1,y)
    xs=xe
    end
  end
  -- last segment from
  -- last breakpoint to the
  -- right bound
  if nil ~= elv then 
    fills[elv](xs,x2,y)
  end
 end
end

-------------------------------
-- palette effects
-------------------------------

function init_palettes(n)
 pals={}
 for p=1,n do
  pals[p]={}
  for c=0,15 do
   pals[p][c]=sget(p,c)
  end
 end
end

-------------------------------
-- light object
-------------------------------

light=kind({
})

 function light:s_default()
  --anchor to avatar
  self.pos = v(ceil(player.x - cam_x) + player.w / 2, flr(player.y) - ceil(cam_y) + player.h / 2)
 end
 
 function light:range()
  return flr(42*self.bri*get_brightness(0.22, 63/44))
 end
 
 function light:extents()
  local p,r=self.pos:ints(),
   self:range()
  return
   p.x-r,p.y-r,
   p.x+r,p.y+r
 end
 
 function light:apply()
  local p=self.pos:ints()
  local light_fill=fl_light(
   p.x,p.y,self.bri*get_brightness(0.22, 63/44),
   blend_line
  )
  local xl,yt,xr,yb=
   self:extents()
  crect(xl,yt,xr,yb,
   light_fill)
 end
 

-------------------------------
-- initialization
-------------------------------

function init_light()
 init_blending(6)
 init_palettes(16)
 lgt=light:new({
    pos=v(59, 59), bri = 1
 }) 
end




-------------------------------
-- main loop
-------------------------------

function update_light()
  lgt:s_default()
end


function draw_light()
 cls()
 palt()
 palt(0, true)
 -- clip to lit rectangle
 xl,yt,xr,yb=
  lgt:extents()

 clip(xl,yt,xr-xl+1,yb-yt+1) --clip code 
 -- store clipping coords
 -- globally to let us
 -- not draw certain objects
 --clipbox=make_box(xl-8,yt,xr+8,yb+24)
 smooth = 4
 step = 4
 offset_x += (flr(player.x) - last_x) / step / smooth
 offset_y += (flr(player.y) - last_y) / step / smooth
 last_x += (flr(player.x)- last_x) / smooth
 last_y += (flr(player.y) - last_y) / smooth
 d_x = cam_x - offset_x 
 d_y = cam_y - offset_y
 i_x = flr(d_x / 8)
 i_y = flr(d_y / 8)
 d_x = d_x % 8
 d_y = d_y % 8
 --camera(cam_x - offset_x, cam_y - offset_y)
 --map(0, 0, 0, 0, 128, 128, 8)
 camera(d_x, d_y)
 map(i_x, i_y, 0, 0, 16, 16, 128)
 

 d_x = cam_x
 d_y = cam_y
 i_x = flr(d_x / 8)
 i_y = flr(d_y / 8)
 d_x = d_x % 8
 d_y = d_y % 8
 --camera(cam_x, cam_y)
 --map(0, 0, 0, 0, 128, 128, 7) -- draw objects with flag 0, 1 & 2
 camera(d_x, d_y)
 map(i_x, i_y, 0, 0, 16, 16, 64)
 map(i_x, i_y, 0, 0, 16, 16, 7)

 camera(cam_x, cam_y)
 render_cursed_keys(1)
 get_cursed_keys()
 render_cursed_chests(1)
 get_cursed_chests()  
 
 camera(cam_x - min_x, cam_y - min_y)
 render_particles()

 camera()
 lgt:apply() 
 
 camera(cam_x, cam_y)
 render_cursed_keys(2)
 render_cursed_chests(2)
 spr(player.sp, flr(player.x), flr(player.y), 1, 1, player.flip)

 camera(cam_x, cam_y)
 render_smoke()
 render_foam()

 render_ui_keys()
 render_ui_chests()

end

