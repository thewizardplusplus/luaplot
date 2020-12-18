---
-- @module types

local types = {}

---
-- @tparam any value
-- @tparam[opt=math.huge] number limit [0, ∞)
-- @treturn bool
function types.is_positive_number(value, limit)
  limit = limit or math.huge

  assert(type(limit) == "number" and limit >= 0)

  return type(value) == "number" and value >= 0 and value <= limit
end

---
-- @tparam any value
-- @tparam tab class class created via the middleclass library
-- @treturn bool
function types.is_instance(value, class)
  assert(type(class) == "table")

  return type(value) == "table"
    and types._is_callable(value.isInstanceOf)
    and value:isInstanceOf(class)
end

---
-- @tparam any value
-- @treturn bool
function types._is_callable(value)
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
  return metatable and types._is_callable(metatable[metamethod])
end

return types
