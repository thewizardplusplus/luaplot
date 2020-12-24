---
-- @module maths

local types = require("luaplot.types")

local maths = {}

---
-- @tparam number value
-- @tparam number minimum
-- @tparam number maximum [minimum, ∞)
-- @treturn number [minimum, maximum]
function maths.clamp(value, minimum, maximum)
  assert(types.is_number_with_limits(value))
  assert(types.is_number_with_limits(minimum))
  assert(types.is_number_with_limits(maximum, minimum))

  if value < minimum then
    value = minimum
  elseif value > maximum then
    value = maximum
  end

  return value
end

return maths
