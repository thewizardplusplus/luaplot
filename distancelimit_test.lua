local luaunit = require("luaunit")
local middleclass = require("middleclass")
local types = require("luaplot.types")
local DistanceLimit = require("luaplot.distancelimit")

-- luacheck: globals TestDistanceLimit
TestDistanceLimit = {}

function TestDistanceLimit.test_new_number()
  local limit = DistanceLimit:new(23, 42)

  luaunit.assert_is_table(limit)
  luaunit.assert_true(types.is_instance(limit, DistanceLimit))

  luaunit.assert_is_number(limit.maximal_distance)
  luaunit.assert_equals(limit.maximal_distance, 23)

  luaunit.assert_is_number(limit.suitable_value)
  luaunit.assert_equals(limit.suitable_value, 42)
end

function TestDistanceLimit.test_new_string()
  local limit = DistanceLimit:new(23, "test")

  luaunit.assert_is_table(limit)
  luaunit.assert_true(types.is_instance(limit, DistanceLimit))

  luaunit.assert_is_number(limit.maximal_distance)
  luaunit.assert_equals(limit.maximal_distance, 23)

  luaunit.assert_is_string(limit.suitable_value)
  luaunit.assert_equals(limit.suitable_value, "test")
end

function TestDistanceLimit.test_new_class()
  local MockClass = middleclass("MockClass")
  local mock = MockClass:new()
  local limit = DistanceLimit:new(23, mock)

  luaunit.assert_is_table(limit)
  luaunit.assert_true(types.is_instance(limit, DistanceLimit))

  luaunit.assert_is_number(limit.maximal_distance)
  luaunit.assert_equals(limit.maximal_distance, 23)

  luaunit.assert_is_table(limit.suitable_value)
  luaunit.assert_true(types.is_instance(limit.suitable_value, MockClass))
end
