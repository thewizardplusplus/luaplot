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
