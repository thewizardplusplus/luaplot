-- luacheck: no max comment line length

---
-- @classmod Plot

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local Vector2D = require("luamath.vector2d")
local Range = require("luamath.models.range")
local mathutils = require("luamath.utils")
local Iterable = require("luaplot.iterable")

---
-- @table instance
-- @tfield {number,...} _points
-- @tfield number _default
-- @tfield Range _range

local Plot = middleclass("Plot")
Plot:include(Iterable)
Plot:include(Nameable)
Plot:include(Stringifiable)

---
-- @function new
-- @tparam number length [0, ∞)
-- @tparam[opt=range.min] number default
-- @tparam[opt=Range:new(0, 1)] Range range
-- @treturn Plot
function Plot:initialize(length, default, range)
  range = range or Range:new(0, 1)
  default = default or range.min

  assertions.is_number(length)
  assertions.is_number(default)
  assertions.is_instance(range, Range)

  self._points = {}
  for _ = 1, length do
    table.insert(self._points, default)
  end
  self._default = default
  self._range = range
end

---
-- It supports direct access to plot points and is used for iterating over them in Lua 5.3+.
-- @tparam number index [1, ∞)
-- @treturn Vector2D|nil
function Plot:__index(index)
  assertions.is_number(index)

  local left_point_index = math.floor(index)
  local left_point = self._points[left_point_index]

  local progress = index - left_point_index
  if progress == 0 then
    return left_point ~= nil and Vector2D:new(index, left_point) or nil
  end

  local right_point_index = math.floor(index + 1)
  local right_point = self._points[right_point_index]
  if not right_point then
    return nil
  end

  return Vector2D:new(index, mathutils.lerp(left_point, right_point, progress))
end

---
-- It is used for iterating over plot points in Lua 5.2.
-- @function __ipairs
-- @treturn iterators.inext iterator function
-- @treturn Plot self
-- @treturn number always zero

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function Plot:__data()
  return {
    points = self._points,
    default = self._default,
    range = self._range,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

---
-- @tparam number point
function Plot:push(point)
  assertions.is_number(point)

  point = self._range:clamp(point)
  table.insert(self._points, point)
end

---
-- @tparam number factor
function Plot:push_with_factor(factor)
  assertions.is_number(factor)

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
  assertions.is_number(factor_limit)

  local factor = mathutils.random_in_range(-factor_limit, factor_limit)
  self:push_with_factor(factor)
end

---
-- @treturn number
function Plot:shift()
  local first_point = table.remove(self._points, 1)
  return first_point or self._default
end

return Plot
