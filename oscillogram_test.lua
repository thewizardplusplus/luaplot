local luaunit = require("luaunit")
local types = require("luaplot.types")
local Oscillogram = require("luaplot.oscillogram")

-- luacheck: globals TestOscillogram
TestOscillogram = {}

function TestOscillogram.test_new_full()
  local plot = Oscillogram:new("random", 5, 32, 23, 42)

  luaunit.assert_is_table(plot)
  luaunit.assert_true(types.is_instance(plot, Oscillogram))

  luaunit.assert_is_string(plot._kind)
  luaunit.assert_equals(plot._kind, "random")

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {32, 32, 32, 32, 32})

  luaunit.assert_is_number(plot._default)
  luaunit.assert_equals(plot._default, 32)

  luaunit.assert_is_number(plot._minimum)
  luaunit.assert_equals(plot._minimum, 23)

  luaunit.assert_is_number(plot._maximum)
  luaunit.assert_equals(plot._maximum, 42)
end

function TestOscillogram.test_new_partial()
  local plot = Oscillogram:new("random", 5)

  luaunit.assert_is_table(plot)
  luaunit.assert_true(types.is_instance(plot, Oscillogram))

  luaunit.assert_is_string(plot._kind)
  luaunit.assert_equals(plot._kind, "random")

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0, 0, 0, 0, 0})

  luaunit.assert_is_number(plot._default)
  luaunit.assert_equals(plot._default, 0)

  luaunit.assert_is_number(plot._minimum)
  luaunit.assert_equals(plot._minimum, 0)

  luaunit.assert_is_number(plot._maximum)
  luaunit.assert_equals(plot._maximum, 1)
end
