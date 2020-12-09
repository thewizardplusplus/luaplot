local luaunit = require("luaunit")
local Plot = require("luaplot.plot")

-- luacheck: globals TestPlot
TestPlot = {}

function TestPlot.test_new_full()
  local plot = Plot:new(5, 12, 23)

  luaunit.assert_is_table(plot)
  luaunit.assert_is_function(plot.isInstanceOf)
  luaunit.assert_true(type(plot) == "table"
    and type(plot.isInstanceOf) == "function"
    and plot:isInstanceOf(Plot))

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {12, 12, 12, 12, 12})

  luaunit.assert_is_number(plot._minimum)
  luaunit.assert_equals(plot._minimum, 12)

  luaunit.assert_is_number(plot._maximum)
  luaunit.assert_equals(plot._maximum, 23)
end

function TestPlot.test_new_partial()
  local plot = Plot:new(5)

  luaunit.assert_is_table(plot)
  luaunit.assert_is_function(plot.isInstanceOf)
  luaunit.assert_true(type(plot) == "table"
    and type(plot.isInstanceOf) == "function"
    and plot:isInstanceOf(Plot))

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0, 0, 0, 0, 0})

  luaunit.assert_is_number(plot._minimum)
  luaunit.assert_equals(plot._minimum, 0)

  luaunit.assert_is_number(plot._maximum)
  luaunit.assert_equals(plot._maximum, 1)
end
