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

---
-- @tparam number point
function Plot:push(point)
  assert(type(point) == "number")

  if point < self._minimum then
    point = self._minimum
  end
  if point > self._maximum then
    point = self._maximum
  end
  table.insert(self._points, point)
end

---
-- @tparam number factor
function Plot:push_with_factor(factor)
  assert(type(factor) == "number")

  local last_point
  if #self._points ~= 0 then
    last_point = self._points[#self._points]
  else
    last_point = self._minimum
  end

  local delta_x = 1 -- because it's the next point
  local next_point = factor * delta_x + last_point
  self:push(next_point)
end

return Plot
