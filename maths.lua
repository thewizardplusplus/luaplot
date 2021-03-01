---
-- @module maths

local types = require("luaplot.types")

local maths = {}

---
-- @tparam number minimum
-- @tparam number maximum [minimum, ∞)
-- @treturn number [minimum, maximum)
function maths.random_in_range(minimum, maximum)
  assert(types.is_number_with_limits(minimum))
  assert(types.is_number_with_limits(maximum, minimum))

  return math.random() * (maximum - minimum) + minimum
end

return maths
