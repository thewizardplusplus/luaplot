---
-- @classmod Plot

local middleclass = require("middleclass")
local types = require("luaplot.types")
local maths = require("luaplot.maths")
local iterators = require("luaplot.iterators")

---
-- @table instance
-- @tfield {number,...} _points
-- @tfield number _default
-- @tfield number _minimum
-- @tfield number _maximum

local Plot = middleclass("Plot")

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

  local minimum_index = math.floor(index)
  local minimum = self._points[minimum_index]

  local progress = index - minimum_index
  if progress == 0 then
    return minimum
  end

  local maximum_index = math.floor(index + 1)
  local maximum = self._points[maximum_index]
  if not maximum then
    return nil
  end

  return maths.lerp(minimum, maximum, progress)
end

---
-- It is used for iterating over plot points in Lua 5.2.
-- @treturn iterators.inext iterator function
-- @treturn Plot self
-- @treturn number always zero
function Plot:__ipairs()
  return iterators.inext, self, 0
end

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
