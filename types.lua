---
-- @module types

local types = {}

---
-- @tparam any value
-- @tparam[opt=-math.huge] number minimum
-- @tparam[optchain=math.huge] number maximum [minimum, ∞)
-- @treturn bool
function types.is_number_with_limits(value, minimum, maximum)
  minimum = minimum or -math.huge
  maximum = maximum or math.huge

  assert(type(minimum) == "number")
  assert(type(maximum) == "number" and maximum >= minimum)

  return type(value) == "number"
    and value >= minimum
    and value <= maximum
end

---
-- @tparam any value
-- @tparam tab class class created via the middleclass library
-- @treturn bool
function types.is_instance(value, class)
  assert(type(class) == "table")

  return type(value) == "table"
    and types.is_callable(value.isInstanceOf)
    and value:isInstanceOf(class)
end

---
-- @tparam any value
-- @treturn bool
function types.is_callable(value)
  if type(value) == "function" then
    return true
  end

  return types._has_metamethod(value, "__call")
end

---
-- @tparam any value
-- @tparam string metamethod
-- @treturn bool
function types._has_metamethod(value, metamethod)
  assert(type(metamethod) == "string")

  local metatable = getmetatable(value)
  return metatable and types.is_callable(metatable[metamethod])
end

return types
