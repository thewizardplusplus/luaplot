local luaunit = require("luaunit")
local maths = require("luaplot.maths")

-- luacheck: globals TestMaths
TestMaths = {}

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
