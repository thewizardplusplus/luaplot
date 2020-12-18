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
-- It is used for iterating over plot points in Lua 5.3+.
-- @tparam number index
-- @treturn number
function Plot:__index(index)
  assert(type(index) == "number")

  return self._points[index]
end

---
-- It is used for iterating over plot points in Lua 5.2.
-- @treturn func func(points: {number,...}, index: number):
--   nil|(number, number); iterator function
-- @treturn {number,...} points
-- @treturn number always zero
function Plot:__ipairs()
  local function iterator(points, index)
    assert(type(points) == "table")
    assert(type(index) == "number" and index >= 0)

    local next_index = index + 1
    local next_item = points[next_index]
    if next_item == nil then
      return
    end

    return next_index, next_item
  end

  return iterator, self._points, 0
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

---
-- @tparam number factor_limit
function Plot:push_with_random_factor(factor_limit)
  assert(type(factor_limit) == "number")

  local factor = 2 * factor_limit * math.random() - factor_limit
  self:push_with_factor(factor)
end

---
-- @treturn number
function Plot:shift()
  local first_point = table.remove(self._points, 1)
  return first_point or self._minimum
end

return Plot
