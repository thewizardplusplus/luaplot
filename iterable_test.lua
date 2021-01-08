local luaunit = require("luaunit")
local middleclass = require("middleclass")
local types = require("luaplot.types")
local Iterable = require("luaplot.iterable")

-- luacheck: globals TestIterable
TestIterable = {}

function TestIterable.test_ipairs_metamethod()
  local MockClass = middleclass("MockClass")
  MockClass:include(Iterable)
  MockClass.__index = function(_, index)
    assert(types.is_number_with_limits(index, 1))

    return index <= 5 and index / 10 or nil
  end

  local mock = MockClass:new()

  local values = {}
  for index, value in mock:__ipairs() do
    table.insert(values, {index = index, value = value})
  end

  luaunit.assert_equals(values, {
    {index = 1, value = 0.1},
    {index = 2, value = 0.2},
    {index = 3, value = 0.3},
    {index = 4, value = 0.4},
    {index = 5, value = 0.5},
  })
end

function TestIterable.test_ipairs_metamethod_empty()
  local MockClass = middleclass("MockClass")
  MockClass:include(Iterable)
  MockClass.__index = function()
    return nil
  end

  local mock = MockClass:new()

  local values = {}
  for index, value in mock:__ipairs() do
    table.insert(values, {index = index, value = value})
  end

  luaunit.assert_equals(values, {})
end
