---
-- @classmod Iterable

local types = require("luaplot.types")
local iterators = require("luaplot.iterators")

local Iterable = {}

---
-- It is used for iterating over plot points in Lua 5.2.
-- @treturn iterators.inext iterator function
-- @treturn Iterable self
-- @treturn number always zero
function Iterable:__ipairs()
  assert(types.is_indexable(self))

  return iterators.inext, self, 0
end

return Iterable
