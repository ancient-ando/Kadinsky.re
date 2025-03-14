
------------------------------
-- utilities
------------------------------

function round(x)
 return flr(x+0.5)
end

-- copies props to obj
-- if obj is nil, a new
-- object will be created,
-- so set(nil,{...}) copies
-- the object
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
function event(ob,name,...)
 local cb=ob[name]
 return type(cb)=="function"
  and cb(ob,...)
  or cb
end

-- returns smallest element
-- of seq, according to key
-- function 
function min_of(seq,key)
 local me,mk=nil,32767
 for e in all(seq) do
  local k=key(e)
  if k<mk then
   me,mk=e,k
  end
 end
 return me
end

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

dirs={
 v(-1,0),v(1,0),
 v(0,-1),v(0,1)
}

-------------------------------
-- boxes
-------------------------------

-- a box is just a rectangle
-- with some helper methods
box=kind()
 function box:translate(v)
  return make_box(
   self.xl+v.x,self.yt+v.y,
   self.xr+v.x,self.yb+v.y
  )
 end
 
 function box:overlaps(b)
  return 
   self.xr>=b.xl and 
   b.xr>=self.xl and
   self.yb>=b.yt and 
   b.yb>=self.yt
 end
 
 function box:contains(pt)
  return pt.x>=self.xl and
   pt.y>=self.yt and
   pt.x<=self.xr and
   pt.y<=self.yb
 end
    
 function box:sepv(b)
  local candidates={
   v(b.xl-self.xr-1,0),
   v(b.xr-self.xl+1,0),
   v(0,b.yt-self.yb-1),
   v(0,b.yb-self.yt+1)
  }
  return min_of(candidates,vec.__len)   
 end

function make_box(xl,yt,xr,yb)
 if (xl>xr) xl,xr=xr,xl
 if (yt>yb) yt,yb=yb,yt
 return box:new({
  xl=xl,yt=yt,xr=xr,yb=yb
 })
end

function vec_box(v1,v2)
 return make_box(
  v1.x,v1.y,
  v2.x,v2.y
 )
end

------------------------------
-- entity system
------------------------------

-- entity root type
entity=kind({
 t=0,state="s_default"
})

-- a big bag of all entities
entities={}

-- entities with some special
-- props are tracked separately
entities_with={}
tracked_props={
 "render","cbox",
 "walls","shadow"
}

-- used to add/remove objects
-- in the entities_with list
function update_with_table(e,fn)
 for prop in all(tracked_props) do
  if e[prop] then
   local lst=
    entities_with[prop] or {}
   fn(lst,e)
   entities_with[prop]=lst
  end
 end
end

-- all entities do common
-- stuff when created -
-- mostly register in lists
e_id=1
function entity:create()
 if not self.name then
  self.name=e_id..""
  e_id+=1
 end
 local name=self.name
 entities[name]=self
 
 update_with_table(self,add) 
end

-- this is the core of our
-- _update() method - update
-- each entity in turn
function update_entities()
 for n,e in pairs(entities) do
  local update_fn=e[e.state]  
  local result = update_fn
   and update_fn(e,e.t)
   or nil
  
  if result then
   if result==true then
    -- remove entity
    entities[n]=nil
    update_with_table(e,del)
   else
    -- set state
    set(e,{
     state=result,t=0
    })    
   end
  else
   -- bump timer in this state
   e.t+=1
  end
 end
end

------------------------------
-- entity rendering
------------------------------

-- renders entities, sorted by
-- y to get proper occlusion
--[[function render_entities()
 ysorted={}
 
 for d in all(entities_with.render) do
  local y=d.pos and flr(d.pos.y) or 139
  ysorted[y]=ysorted[y] or {}
  add(ysorted[y],d)
 end
 for y=clipbox.yt,clipbox.yb do
  for d in all(ysorted[y]) do
   reset_palette()
   d:render(d.t)
  end
  reset_palette()
 end
end]]--



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
function cellipse(cx,cy,rx,ry,ln)
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
  local addr=0x4300+lv*0x100
  local sx=lv-1
  for c1=0,15 do
   local nc=sget(sx + 16 * (level_index % 6),c1)
   local topl=shl(nc,4)
   for c2=0,15 do
    poke(addr,
     topl+sget(sx+ 16 * (level_index % 6),c2))
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
 local lutaddr=0x4300+shl(l,8)
 --local lutaddr = 0x4300 + _shl8[l]
    return function(x1,x2,y)
      --printh(x1.." "..x2.." "..y, "log.txt")
      if true then 
     local laddr=lutaddr
     --printh(laddr.."laddr", "log.txt")
     --local yaddr=0x6000+shl(y,6)
     local yaddr = 0x6000 + _shl6[y]
     local saddr,eaddr=
      --yaddr+band(shr(x1+1,1),0xffff),
      --yaddr + shr(x1 + 1, 1) & 0xffff,
      max(0x6001, yaddr + ((x1 + 1) >> 1) & 0xffff), 
      --yaddr + band(shr(x2-1,1),0xffff)
      --yaddr + shr(x2 - 1, 1) & 0xffff
      min(0x7ffe, yaddr + ((x2 - 1) >> 1) & 0xffff)
     -- odd pixel on left?
     --if 0x6001 <= saddr and band(x1,1.99995)>=1 then -- 10% CPu
     if (x1 & 1.99995) >= 1 then --and 0x6001 <= saddr then 
      local a=saddr-1
      local v=peek(a)
      poke(a,
      --band(v,0xf) +
      (v & 0xf) | 
      --band(peek(bor(laddr,v)),0xf0)
      --band(peek(laddr | v), 0xf0)
      (peek(laddr | v) & 0xf0)
      )
     end
     -- full bytes
     --for addr=max(saddr, 0x6000), min(eaddr,0x7fff) do -- 30% CPu 
      for addr = saddr, eaddr do 
      --if addr >= 0x6000 and addr <=0x7fff then 
      poke(addr,
       peek(
        --bor(laddr,peek(addr))
        laddr | peek(addr)
       )
      )
      --end
     end
     -- odd pixel on right?
     --if 0x7ffe >= eaddr and band(x2,1.99995)<1 then -- 10% CPu
     if (x2 & 1.99995) < 1 then --and 0x7ffe >= eaddr then 
      local a=eaddr+1
      local v=peek(a)
      poke(a,
      --band(peek(bor(laddr,v)),0xf) |
      (peek(laddr | v) & 0x0f) |
      --band(v,0xf0)
      (v & 0xf0)
      )
     end
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
   --local r=band(light_rng[lv]*mul,0xffff)
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
  --printh("mind ".. mind, "log.txt")
  for lv=hlv-1,1,-1 do
   --local brng=band(light_rng[lv]*mul,0xffff)
   local brng = (light_rng[lv] * mul) & 0xffff
   local brp=_sqrt[brng-ysq]
   --if brp then printh("brp ".. brp, "log.txt") end 
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
    --printh("xe slv"..xe, "log.txt")
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
    --printh("xe elv"..xe, "log.txt")
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

--[[function reset_palette()
 pal()
 palt(3,true)
 palt(0,false)
end]]--

--[[function set_palette(no)
 for c,nc in pairs(pals[no]) do
  pal(c,nc)
 end
end]]--



-------------------------------
-- light object
-------------------------------

light=kind({
 extends=entity,
 off=v(0,0),
 cbox=make_box(-1,-1,1,1)
})
light_offsets={
 v(-7,-2),v(7,-2),
 v(0,-9),v(0,6)
}

 function light:s_default()
  --anchor to avatar
  --self.pos=ply.pos
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
 -- pos=v(64,120),bri=1
    pos=v(59, 59), bri = 1
 }) 

end




-------------------------------
-- main loop
-------------------------------

function update_light()
    
 -- let all objects update
 update_entities()
 -- check for collisions
 -- collision callbacks happen
 -- here
 --do_collisions()
end


function draw_light()
 cls()
 --camera(cam_x, 0)
 palt()
 palt(0, true)
 
 
 -- clip to lit rectangle
 xl,yt,xr,yb=
  lgt:extents()

 clip(xl,yt,xr-xl+1,yb-yt+1) --clip code 
 -- printh("clip "..xl.." "..yt.." "..(xr-xl+1).." "..(yb-yt+1), "log.txt")
 -- store clipping coords
 -- globally to let us
 -- not draw certain objects
 clipbox=make_box(
  xl-8,yt,xr+8,yb+24
 )


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
 map(i_x, i_y, 0, 0, 16, 16, 8)

 d_x = cam_x
 d_y = cam_y
 i_x = flr(d_x / 8)
 i_y = flr(d_y / 8)
 d_x = d_x % 8
 d_y = d_y % 8
 --camera(cam_x, cam_y)
 --map(0, 0, 0, 0, 128, 128, 7) -- draw objects with flag 0, 1 & 2
 camera(d_x, d_y)
 map(i_x, i_y, 0, 0, 16, 16, 7)

 camera(cam_x, cam_y)
 render_cursed_keys(1)
 get_cursed_keys()
 render_cursed_chests(1)
 get_cursed_chests()  
 
 
 --camera()
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

function show_performance()
 clip()
 local cpu=flr(stat(1)*100)
 local fps=-60/flr(-stat(1))
 local perf=
  cpu .. "% cpu @ " ..
  fps ..  " fps"
 print(perf,0,122,0)
 print(perf,0,121,fps==60 and 7 or 8)
end