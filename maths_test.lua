local luaunit = require("luaunit")
local maths = require("luaplot.maths")

-- luacheck: globals TestMaths
TestMaths = {}

function TestMaths.test_clamp_middle()
  local result = maths.clamp(32, 23, 42)

  luaunit.assert_is_number(result)
  luaunit.assert_equals(result, 32)
end

function TestMaths.test_clamp_minimum()
  local result = maths.clamp(23, 23, 42)

  luaunit.assert_is_number(result)
  luaunit.assert_equals(result, 23)
end

function TestMaths.test_clamp_before_minimum()
  local result = maths.clamp(22, 23, 42)

  luaunit.assert_is_number(result)
  luaunit.assert_equals(result, 23)
end

function TestMaths.test_clamp_maximum()
  local result = maths.clamp(42, 23, 42)

  luaunit.assert_is_number(result)
  luaunit.assert_equals(result, 42)
end

function TestMaths.test_clamp_after_maximum()
  local result = maths.clamp(43, 23, 42)

  luaunit.assert_is_number(result)
  luaunit.assert_equals(result, 42)
end

function TestMaths.test_random_in_range()
  math.randomseed(1)

  local results = {}
  for _ = 1, 10 do
    local result = maths.random_in_range(23, 42)
    table.insert(results, result)
  end

  local wanted_results = {
    30.493275606073,
    37.878885244485,
    38.170360628981,
    40.321299792733,
    26.753476014826,
    29.369232355617,
    37.596362294629,
    28.277719502803,
    33.525429155212,
    32.070543981157,
  }
  luaunit.assert_equals(#results, #wanted_results)
  for index, result in ipairs(results) do
    luaunit.assert_almost_equals(result, wanted_results[index], 1e-6)
  end
end
