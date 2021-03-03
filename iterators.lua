---
-- @module iterators

local types = require("luaplot.types")
local DistanceLimit = require("luaplot.distancelimit")

local iterators = {}

---
-- It is an analog of the 'next' function but for the 'ipairs' one.
-- It is used for iterating in Lua 5.2.
-- @tparam {any,...} items
-- @tparam number index [0, ∞)
-- @treturn[1] number next index
-- @treturn[1] any next item
-- @treturn[2] nil when the next index out of range
function iterators.inext(items, index)
  assert(type(items) == "table")
  assert(types.is_number_with_limits(index, 0))

  local next_index = index + 1
  local next_item = items[next_index]
  if next_item == nil then
    return
  end

  return next_index, next_item
end

---
-- @tparam tab indexable_one
-- @tparam tab indexable_two
-- @tparam number index [1, ∞)
-- @tparam[opt=false] bool modulo
-- @treturn number
function iterators.difference(indexable_one, indexable_two, index, modulo)
  assert(types.is_indexable(indexable_one))
  assert(types.is_indexable(indexable_two))
  assert(types.is_number_with_limits(index, 1))
  assert(modulo == nil or type(modulo) == "boolean")

  local item_one = indexable_one[index]
  local item_two = indexable_two[index]
  local difference = item_one - item_two
  if modulo then
    difference = math.abs(difference)
  end

  return difference
end

---
-- @tparam tab indexable_one
-- @tparam tab indexable_two
-- @tparam number index [1, ∞)
-- @tparam[opt=false] bool modulo
-- @tparam {DistanceLimit,...} limits
-- @treturn any
function iterators.select_by_distance(
  indexable_one,
  indexable_two,
  index,
  modulo,
  limits
)
  if limits == nil then
    limits = modulo
    modulo = nil
  end

  assert(types.is_indexable(indexable_one))
  assert(types.is_indexable(indexable_two))
  assert(types.is_number_with_limits(index, 1))
  assert(modulo == nil or modulo == limits or type(modulo) == "boolean")
  assert(type(limits) == "table")

  local suitable_value
  local distance =
    iterators.difference(indexable_one, indexable_two, index, modulo)
  for _, limit in ipairs(limits) do
    assert(types.is_instance(limit, DistanceLimit))

    if distance <= limit.maximal_distance then
      suitable_value = limit.suitable_value
      break
    end
  end

  return suitable_value
end

return iterators
