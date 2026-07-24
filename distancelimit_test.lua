local luaunit = require("luaunit")
local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local checks = require("luatypechecks.checks")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local DistanceLimit = require("luaplot.distancelimit")

local MockClass = middleclass("MockClass")

local SerializableMockClass = middleclass("SerializableMockClass")
SerializableMockClass:include(Nameable)
SerializableMockClass:include(Stringifiable)

function SerializableMockClass:initialize(id)
  assertions.is_integer(id)

  self.id = id
end

function SerializableMockClass:__data()
  return {
    field_1 = self.id + 100,
    field_2 = string.format("test-%d", self.id),
  }
end

-- luacheck: globals TestDistanceLimit
TestDistanceLimit = {}

function TestDistanceLimit.test_new_number()
  local limit = DistanceLimit:new(23, 42)

  luaunit.assert_is_table(limit)
  luaunit.assert_true(checks.is_instance(limit, DistanceLimit))

  luaunit.assert_is_number(limit.maximal_distance)
  luaunit.assert_equals(limit.maximal_distance, 23)

  luaunit.assert_is_number(limit.suitable_value)
  luaunit.assert_equals(limit.suitable_value, 42)
end

function TestDistanceLimit.test_new_string()
  local limit = DistanceLimit:new(23, "test")

  luaunit.assert_is_table(limit)
  luaunit.assert_true(checks.is_instance(limit, DistanceLimit))

  luaunit.assert_is_number(limit.maximal_distance)
  luaunit.assert_equals(limit.maximal_distance, 23)

  luaunit.assert_is_string(limit.suitable_value)
  luaunit.assert_equals(limit.suitable_value, "test")
end

function TestDistanceLimit.test_new_class()
  local mock = MockClass:new()
  local limit = DistanceLimit:new(23, mock)

  luaunit.assert_is_table(limit)
  luaunit.assert_true(checks.is_instance(limit, DistanceLimit))

  luaunit.assert_is_number(limit.maximal_distance)
  luaunit.assert_equals(limit.maximal_distance, 23)

  luaunit.assert_is_table(limit.suitable_value)
  luaunit.assert_true(checks.is_instance(limit.suitable_value, MockClass))
end

function TestDistanceLimit.test_new_negative_maximum()
  local mock = MockClass:new()
  local limit = DistanceLimit:new(-23, mock)

  luaunit.assert_is_table(limit)
  luaunit.assert_true(checks.is_instance(limit, DistanceLimit))

  luaunit.assert_is_number(limit.maximal_distance)
  luaunit.assert_equals(limit.maximal_distance, -23)

  luaunit.assert_is_table(limit.suitable_value)
  luaunit.assert_true(checks.is_instance(limit.suitable_value, MockClass))
end

function TestDistanceLimit.test_tostring_number()
  local limit = DistanceLimit:new(23, 42)
  local text = tostring(limit)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"Point\"," ..
    "maximal_distance = 23," ..
    "suitable_value = 42" ..
  "}")
end

function TestDistanceLimit.test_tostring_string()
  local limit = DistanceLimit:new(23, "test")
  local text = tostring(limit)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"Point\"," ..
    "maximal_distance = 23," ..
    "suitable_value = \"test\"" ..
  "}")
end

function TestDistanceLimit.test_tostring_class()
  local mock = MockClass:new()
  local limit = DistanceLimit:new(23, mock)
  local text = tostring(limit)

  luaunit.assert_is_string(text)
  luaunit.assert_str_contains(
    text,
    "{" ..
      "__name = \"Point\"," ..
      "maximal_distance = 23," ..
      "suitable_value = '%b{}'" ..
    "}",
    true -- is pattern
  )
end

function TestDistanceLimit.test_tostring_serializable_class()
  local mock = SerializableMockClass:new(42)
  local limit = DistanceLimit:new(23, mock)
  local text = tostring(limit)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"Point\"," ..
    "maximal_distance = 23," ..
    "suitable_value = {" ..
      "__name = \"SerializableMockClass\"," ..
      "field_1 = 142," ..
      "field_2 = \"test-42\"" ..
    "}" ..
  "}")
end
