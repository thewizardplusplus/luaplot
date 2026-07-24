-- luacheck: no max comment line length

---
-- @classmod Oscillogram

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Plot = require("luaplot.plot")

---
-- @table instance
-- @tfield "custom"|"linear"|"random" _kind
-- @tfield {number,...} _points
-- @tfield number _default
-- @tfield number _minimum
-- @tfield number _maximum

local Oscillogram = middleclass("Oscillogram", Plot)

---
-- @function new
-- @tparam "custom"|"linear"|"random" kind
-- @tparam number length [0, ∞)
-- @tparam[opt=minimum] number default
-- @tparam[opt=0] number minimum
-- @tparam[opt=1] number maximum [minimum, ∞)
-- @treturn Oscillogram
function Oscillogram:initialize(kind, length, default, minimum, maximum)
  minimum = minimum or 0
  maximum = maximum or 1
  default = default or minimum

  assertions.is_enumeration(kind, {"custom", "linear", "random"})
  assertions.is_number(length)
  assertions.is_number(default)
  assertions.is_number(minimum)
  assertions.is_number(maximum)

  Plot.initialize(self, length, default, minimum, maximum)

  self._kind = kind
end

---
-- It is used for iterating over plot points in Lua 5.3+.
-- @function __index
-- @tparam number index [1, ∞)
-- @treturn number

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
    minimum = self._minimum,
    maximum = self._maximum,
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
