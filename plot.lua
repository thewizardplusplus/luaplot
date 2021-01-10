---
-- @classmod Plot

local middleclass = require("middleclass")
local types = require("luaplot.types")
local maths = require("luaplot.maths")
local Iterable = require("luaplot.iterable")

---
-- @table instance
-- @tfield {number,...} _points
-- @tfield number _default
-- @tfield number _minimum
-- @tfield number _maximum

local Plot = middleclass("Plot")
Plot:include(Iterable)

---
-- @function new
-- @tparam number length [0, ∞)
-- @tparam[opt=minimum] number default
-- @tparam[opt=0] number minimum
-- @tparam[opt=1] number maximum [minimum, ∞)
-- @treturn Plot
function Plot:initialize(length, default, minimum, maximum)
  minimum = minimum or 0
  maximum = maximum or 1
  default = default or minimum

  assert(types.is_number_with_limits(length, 0))
  assert(types.is_number_with_limits(minimum))
  assert(types.is_number_with_limits(maximum, minimum))
  assert(types.is_number_with_limits(default, minimum, maximum))

  self._points = {}
  for _ = 1, length do
    table.insert(self._points, default)
  end
  self._default = default
  self._minimum = minimum
  self._maximum = maximum
end

---
-- It is used for iterating over plot points in Lua 5.3+.
-- @tparam number index [1, ∞)
-- @treturn number
function Plot:__index(index)
  assert(types.is_number_with_limits(index, 1))

  local left_point_index = math.floor(index)
  local left_point = self._points[left_point_index]

  local progress = index - left_point_index
  if progress == 0 then
    return left_point
  end

  local right_point_index = math.floor(index + 1)
  local right_point = self._points[right_point_index]
  if not right_point then
    return nil
  end

  if right_point < left_point then
    left_point, right_point = right_point, left_point
    progress = 1 - progress
  end

  return maths.lerp(left_point, right_point, progress)
end

---
-- It is used for iterating over plot points in Lua 5.2.
-- @function __ipairs
-- @treturn iterators.inext iterator function
-- @treturn Plot self
-- @treturn number always zero

---
-- @tparam number point
function Plot:push(point)
  assert(types.is_number_with_limits(point))

  point = maths.clamp(point, self._minimum, self._maximum)
  table.insert(self._points, point)
end

---
-- @tparam number factor
function Plot:push_with_factor(factor)
  assert(types.is_number_with_limits(factor))

  local last_point
  if #self._points ~= 0 then
    last_point = self._points[#self._points]
  else
    last_point = self._default
  end

  local delta_x = 1 -- because it's the next point
  local next_point = factor * delta_x + last_point
  self:push(next_point)
end

---
-- @tparam number factor_limit
function Plot:push_with_random_factor(factor_limit)
  assert(types.is_number_with_limits(factor_limit))

  local factor = maths.random_in_range(-factor_limit, factor_limit)
  self:push_with_factor(factor)
end

---
-- @treturn number
function Plot:shift()
  local first_point = table.remove(self._points, 1)
  return first_point or self._default
end

return Plot
