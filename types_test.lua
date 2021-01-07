local luaunit = require("luaunit")
local middleclass = require("middleclass")
local types = require("luaplot.types")

-- luacheck: globals TestTypes
TestTypes = {}

function TestTypes.test_is_number_with_limits_false_not_number()
  local result = types.is_number_with_limits(nil)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_number_with_limits_false_minimum()
  local result = types.is_number_with_limits(22, 23)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_number_with_limits_false_maximum()
  local result = types.is_number_with_limits(43, 23, 42)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_number_with_limits_true_number()
  local result = types.is_number_with_limits(23)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_number_with_limits_true_minimum_default()
  local result = types.is_number_with_limits(-math.huge)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_number_with_limits_true_minimum_not_default()
  local result = types.is_number_with_limits(23, 23)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_number_with_limits_true_maximum_default()
  local result = types.is_number_with_limits(math.huge)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_number_with_limits_true_maximum_not_default()
  local result = types.is_number_with_limits(42, 23, 42)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_instance_false_not_table()
  local MockClass = middleclass("MockClass")
  local result = types.is_instance(nil, MockClass)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_instance_false_missed_method()
  local MockClass = middleclass("MockClass")
  local result = types.is_instance({}, MockClass)

  luaunit.assert_is_nil(result)
end

function TestTypes.test_is_instance_false_incorrect_method()
  local MockClass = middleclass("MockClass")
  local result = types.is_instance({isInstanceOf = 23}, MockClass)

  luaunit.assert_is_nil(result)
end

function TestTypes.test_is_instance_false_by_check()
  local MockClass = middleclass("MockClass")
  local result = types.is_instance(
    {
      isInstanceOf = function()
        return false
      end,
    },
    MockClass
  )

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_instance_true_by_check()
  local MockClass = middleclass("MockClass")
  local result = types.is_instance(
    {
      isInstanceOf = function()
        return true
      end,
    },
    MockClass
  )

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_instance_true_real_class()
  local MockClass = middleclass("MockClass")
  local mock = MockClass:new()
  local result = types.is_instance(mock, MockClass)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_callable_false_missed_metatable()
  local result = types.is_callable({})

  luaunit.assert_is_nil(result)
end

function TestTypes.test_is_callable_false_missed_metamethod()
  local value = {}
  setmetatable(value, {})

  local result = types.is_callable(value)

  luaunit.assert_is_nil(result)
end

function TestTypes.test_is_callable_false_incorrect_metamethod()
  local value = {}
  setmetatable(value, {__call = 23})

  local result = types.is_callable(value)

  luaunit.assert_is_nil(result)
end

function TestTypes.test_is_callable_true_function()
  local value = function()
  end

  local result = types.is_callable(value)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_callable_true_metatable()
  local value = {}
  setmetatable(value, {
    __call = function()
    end,
  })

  local result = types.is_callable(value)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_indexable_false_not_table()
  local result = types.is_indexable(nil)

  luaunit.assert_is_nil(result)
end

function TestTypes.test_is_indexable_false_missed_metamethod()
  local result = types.is_indexable({})

  luaunit.assert_is_nil(result)
end

function TestTypes.test_is_indexable_true()
  local value = {}
  setmetatable(value, {
    __index = function()
    end,
  })

  local result = types.is_indexable(value)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_has_metamethod_false_missed_metatable()
  local result = types.has_metamethod({}, "__test")

  luaunit.assert_is_nil(result)
end

function TestTypes.test_has_metamethod_false_missed_metamethod()
  local value = {}
  setmetatable(value, {})

  local result = types.has_metamethod(value, "__test")

  luaunit.assert_is_nil(result)
end

function TestTypes.test_has_metamethod_false_incorrect_metamethod()
  local value = {}
  setmetatable(value, {__test = 23})

  local result = types.has_metamethod(value, "__test")

  luaunit.assert_is_nil(result)
end

function TestTypes.test_has_metamethod_true()
  local value = {}
  setmetatable(value, {
    __test = function()
    end,
  })

  local result = types.has_metamethod(value, "__test")

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end
