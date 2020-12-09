---
-- @classmod Plot

local middleclass = require("middleclass")

---
-- @table instance
-- @tfield {number,...} _points
-- @tfield number _minimum
-- @tfield number _maximum

local Plot = middleclass("Plot")

---
-- @function new
-- @tparam number length [0, ∞)
-- @tparam[opt=0] number minimum
-- @tparam[opt=1] number maximum [minimum, ∞)
-- @treturn Plot
function Plot:initialize(length, minimum, maximum)
  minimum = minimum or 0
  maximum = maximum or 1

  assert(type(length) == "number" and length >= 0)
  assert(type(minimum) == "number")
  assert(type(maximum) == "number" and maximum >= minimum)

  self._points = {}
  for _ = 1, length do
    table.insert(self._points, minimum)
  end
  self._minimum = minimum
  self._maximum = maximum
end

return Plot
