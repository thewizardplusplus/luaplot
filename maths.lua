---
-- @module maths

local assertions = require("luatypechecks.assertions")

local maths = {}

---
-- @tparam number value
-- @tparam number minimum
-- @tparam number maximum [minimum, ∞)
-- @treturn number [minimum, maximum]
function maths.clamp(value, minimum, maximum)
  assertions.is_number(value)
  assertions.is_number(minimum)
  assertions.is_number(maximum)

  if value < minimum then
    value = minimum
  elseif value > maximum then
    value = maximum
  end

  return value
end

---
-- @tparam number minimum
-- @tparam number maximum [minimum, ∞)
-- @tparam number progress [0, 1]
-- @treturn number [minimum, maximum]
function maths.lerp(minimum, maximum, progress)
  assertions.is_number(minimum)
  assertions.is_number(maximum)
  assertions.is_number(progress)

  return (maximum - minimum) * progress + minimum
end

---
-- @tparam number minimum
-- @tparam number maximum [minimum, ∞)
-- @treturn number [minimum, maximum)
function maths.random_in_range(minimum, maximum)
  assertions.is_number(minimum)
  assertions.is_number(maximum)

  return math.random() * (maximum - minimum) + minimum
end

return maths
