

-------------------------------
-- vectors
-------------------------------

-- for some stuff, we want
-- vector math - so we make
-- a vector type with all the
-- usual operations

vec={}
function vec.__add(v1,v2)
 return v(v1.x+v2.x,v1.y+v2.y)
end
function vec.__sub(v1,v2)
 return v(v1.x-v2.x,v1.y-v2.y)
end
function vec.__mul(v1,a)
 return v(v1.x*a,v1.y*a)
end
function vec.__mul(v1,a)
 return v(v1.x*a,v1.y*a)
end
function vec.__div(v1,a)
 return v(v1.x/a,v1.y/a)
end
-- we use the ^ operator
-- to mean dot product
function vec.__pow(v1,v2)
 return v1.x*v2.x+v1.y*v2.y
end
-- we use the ^ operator
-- to mean dot product
-- also prevents overflow
--[[function vec.__pow(v1,v2)
  hi_v1x = flr(v1.x >> 6) -->> 6
  lo_v1x = v1.x % 64 -- & 63
  hi_v2x = flr(v2.x >> 6) -->> 6
  lo_v2x = v2.x % 64 -- & 63
  hi_v1y = flr(v1.y >> 6) -->> 6
  lo_v1y = v1.y % 64 -- & 63
  hi_v2y = flr(v2.y >> 6) -->> 6
  lo_v2y = v2.y % 64 -- & 63

  lo_sum = lo_v1x * lo_v2x + lo_v1y * lo_v2y 
  mi_sum = hi_v1x * lo_v2x + lo_v1x * hi_v2x + lo_v1y * hi_v2y + hi_v1y * lo_v2y 
  hi_sum = hi_v1x * hi_v2x + hi_v1y * hi_v2y
  mi_sum += flr(lo_sum >> 6) -->> 6
  lo_sum = lo_sum % 64 -- & 63
  hi_sum += flr(mi_sum >> 6) -- >> 6
  mi_sum = mi_sum % 64 -- & 63
  printh("vector dot ("..tostr(v1.x)..", "..tostr(v1.y)..") ("..tostr(v2.x)..", "..tostr(v2.y)..") ", "log.txt")
  if (hi_sum >= 8) then 
    printh("32767", "log.txt")
    return 32767
  end
  if (hi_sum <= -8) then
    printh("-32766", "log.txt")
    return -32766
  end
  printh((hi_sum * 64 + mi_sum) * 64 + lo_sum, "log.txt")
  return (hi_sum * 64 + mi_sum) * 64 + lo_sum
 end
]]--
function vec.__unm(v1)
 return v(-v1.x,-v1.y)
end
-- this is not really the
-- length of the vector,
-- but length squared -
-- easier to calculate,
-- and can be used for most
-- of the same stuff
function vec.__len(v1)
 --local x,y=v1:split()
 --return x*x+y*y
 return v1 ^ v1 
end
-- normalized vector
function vec:norm()
 return self/sqrt(#self)
end
-- rotated 90-deg clockwise
function vec:rotcw()
 return v(-self.y,self.x)
end
-- force coordinates to
-- integers
function vec:ints()
 return v(flr(self.x),flr(self.y))
end
-- used for destructuring,
-- i.e.:  x,y=v:split()
function vec:split()
 return self.x,self.y
end
-- has to be there so
-- our metatable works
-- for both operators 
-- and methods
vec.__index = vec

-- creates a new vector
function v(x,y)
 local vector={x=x,y=y}
 setmetatable(vector,vec)
 return vector
end