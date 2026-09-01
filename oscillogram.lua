-- luacheck: no max comment line length

---
-- @classmod Oscillogram

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Range = require("luamath.models.range")
local Plot = require("luaplot.plot")

---
-- @table instance
-- @tfield "custom"|"linear"|"random" _kind
-- @tfield {number,...} _points
-- @tfield number _default
-- @tfield Range _range

local Oscillogram = middleclass("Oscillogram", Plot)

---
-- @function schema
-- @static
-- @treturn tab JSON Schema for this class
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function Oscillogram.static.schema()
  local schema = Plot.schema()
  table.insert(schema.required, 1, "kind")
  schema.properties.kind = {
    type = "string",
    enum = {"custom", "linear", "random"},
  }

  return schema
end

---
-- @function from_options
-- @static
-- @tparam tab options constructor options conforming to the JSON Schema
--   returned by @{Oscillogram.schema|Oscillogram.schema()}
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
-- @treturn Oscillogram
function Oscillogram.static.from_options(options)
  assertions.is_table(options)

  local plot = Oscillogram:new(
    options.kind,
    #options.points,
    options.default,
    options.range
  )
  for index, point in ipairs(options.points) do
    plot._points[index] = point
  end

  return plot
end

---
-- @function new
-- @tparam "custom"|"linear"|"random" kind
-- @tparam number length [0, ∞)
-- @tparam[opt=range.min] number default
-- @tparam[opt=Range:new(0, 1)] Range range
-- @treturn Oscillogram
function Oscillogram:initialize(kind, length, default, range)
  range = range or Range:new(0, 1)
  default = default or range.min

  assertions.is_enumeration(kind, {"custom", "linear", "random"})
  assertions.is_number(length)
  assertions.is_number(default)
  assertions.is_instance(range, Range)

  Plot.initialize(self, length, default, range)

  self._kind = kind
end

---
-- It supports direct access to plot points and is used for iterating over them in Lua 5.3+.
-- @function __index
-- @tparam number index [1, ∞)
-- @treturn Vector2D|nil

---
-- It is used for iterating over plot points in Lua 5.2.
-- @function __ipairs
-- @treturn iterators.inext iterator function
-- @treturn Oscillogram self
-- @treturn number always zero

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function Oscillogram:__data()
  return {
    kind = self._kind,
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
-- @function push
-- @tparam number point

---
-- @function push_with_factor
-- @tparam number factor

---
-- @function push_with_random_factor
-- @tparam number factor_limit

---
-- @function shift
-- @treturn number

---
-- @tparam number value
-- @treturn number
function Oscillogram:update(value)
  assertions.is_number(value)

  if self._kind == "custom" then
    self:push(value)
  elseif self._kind == "linear" then
    self:push_with_factor(value)
  elseif self._kind == "random" then
    self:push_with_random_factor(value)
  end

  local first_point = self:shift()
  return first_point
end

return Oscillogram
