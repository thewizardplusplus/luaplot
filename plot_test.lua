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

function TestPlot.test_push_in_range()
  local plot = Plot:new(5)
  plot:push(0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0, 0, 0, 0, 0, 0.2})
end

function TestPlot.test_push_too_less()
  local plot = Plot:new(5)
  plot:push(-0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0, 0, 0, 0, 0, 0})
end

function TestPlot.test_push_too_greater()
  local plot = Plot:new(5)
  plot:push(1.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0, 0, 0, 0, 0, 1})
end

function TestPlot.test_push_empty()
  local plot = Plot:new(0)
  plot:push(0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.2})
end

function TestPlot.test_push_with_factor_in_range_positive()
  local plot = Plot:new(5)
  plot:push(0.5)
  plot:push_with_factor(0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0, 0, 0, 0, 0, 0.5, 0.7})
end

function TestPlot.test_push_with_factor_in_range_negative()
  local plot = Plot:new(5)
  plot:push(0.5)
  plot:push_with_factor(-0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0, 0, 0, 0, 0, 0.5, 0.3})
end

function TestPlot.test_push_with_factor_out_range()
  local plot = Plot:new(5)
  plot:push(0.5)
  plot:push_with_factor(0.6)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0, 0, 0, 0, 0, 0.5, 1})
end

function TestPlot.test_push_with_factor_empty()
  local plot = Plot:new(0)
  plot:push_with_factor(0.5)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.5})
end

function TestPlot.test_push_with_random_factor()
  math.randomseed(1)

  local plot = Plot:new(5)
  plot:push(0.5)
  plot:push_with_random_factor(0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(#plot._points, 7)
  luaunit.assert_almost_equals(plot._points[7], 0.457753, 1e-6)
end
