---
-- @module iterators

local types = require("luaplot.types")

local iterators = {}

---
-- It is an analog of the 'next' function but for the 'ipairs' one.
-- It is used for iterating in Lua 5.2.
-- @tparam {any,...} items
-- @tparam number index [0, ∞)
-- @treturn[1] number next index
-- @treturn[1] any next item
-- @treturn[2] nil when the next index out of range
function iterators.inext(items, index)
  assert(type(items) == "table")
  assert(types.is_number_with_limits(index, 0))

  local next_index = index + 1
  local next_item = items[next_index]
  if next_item == nil then
    return
  end

  return next_index, next_item
end

return iterators
