local luaunit = require("luaunit")
local maths = require("luaplot.maths")
local checks = require("luatypechecks.checks")

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

function TestMaths.test_lerp_middle()
  local result = maths.lerp(23, 42, 0.2)

  luaunit.assert_is_number(result)
  luaunit.assert_equals(result, 26.8)
end

function TestMaths.test_lerp_minimum()
  local result = maths.lerp(23, 42, 0)

  luaunit.assert_is_number(result)
  luaunit.assert_equals(result, 23)
end

function TestMaths.test_lerp_maximum()
  local result = maths.lerp(23, 42, 1)

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

  local wanted_results
  if _VERSION == "Lua 5.4" then
    wanted_results = {
      38.496168,
      41.744973,
      24.507284,
      32.474321,
      34.244394,
      38.845409,
      25.936408,
      28.019722,
      27.905971,
      37.831421,
    }
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    wanted_results = {
      30.493276,
      37.878885,
      38.170361,
      40.321300,
      26.753476,
      29.369232,
      37.596362,
      28.277720,
      33.525429,
      32.070544,
    }
  elseif _VERSION == "Lua 5.1" then
    if checks.is_table(jit) then -- check for LuaJIT
      wanted_results = {
        29.152401,
        23.258655,
        40.341720,
        28.675371,
        25.056512,
        25.001620,
        27.543950,
        38.933066,
        41.363617,
        29.867614,
      }
    else
      wanted_results = {
        38.963567,
        30.493276,
        37.878885,
        38.170361,
        40.321300,
        26.753476,
        29.369232,
        37.596362,
        28.277720,
        33.525429,
      }
    end
  end

  luaunit.assert_equals(#results, #wanted_results)
  for index, result in ipairs(results) do
    luaunit.assert_almost_equals(result, wanted_results[index], 1e-6)
  end
end
