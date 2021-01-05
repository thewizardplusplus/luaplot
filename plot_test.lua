local luaunit = require("luaunit")
local types = require("luaplot.types")
local Plot = require("luaplot.plot")

-- luacheck: globals TestPlot
TestPlot = {}

function TestPlot.test_new_full()
  local plot = Plot:new(5, 32, 23, 42)

  luaunit.assert_is_table(plot)
  luaunit.assert_true(types.is_instance(plot, Plot))

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {32, 32, 32, 32, 32})

  luaunit.assert_is_number(plot._default)
  luaunit.assert_equals(plot._default, 32)

  luaunit.assert_is_number(plot._minimum)
  luaunit.assert_equals(plot._minimum, 23)

  luaunit.assert_is_number(plot._maximum)
  luaunit.assert_equals(plot._maximum, 42)
end

function TestPlot.test_new_partial()
  local plot = Plot:new(5)

  luaunit.assert_is_table(plot)
  luaunit.assert_true(types.is_instance(plot, Plot))

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0, 0, 0, 0, 0})

  luaunit.assert_is_number(plot._default)
  luaunit.assert_equals(plot._default, 0)

  luaunit.assert_is_number(plot._minimum)
  luaunit.assert_equals(plot._minimum, 0)

  luaunit.assert_is_number(plot._maximum)
  luaunit.assert_equals(plot._maximum, 1)
end

function TestPlot.test_index_middle()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local point = plot[3]

  luaunit.assert_is_number(point)
  luaunit.assert_equals(point, 0.3)
end

function TestPlot.test_index_middle_fractional()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local point = plot[3.2]

  luaunit.assert_is_number(point)
  luaunit.assert_equals(point, 0.32)
end

function TestPlot.test_index_start()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local point = plot[1]

  luaunit.assert_is_number(point)
  luaunit.assert_equals(point, 0.1)
end

function TestPlot.test_index_end()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local point = plot[5]

  luaunit.assert_is_number(point)
  luaunit.assert_equals(point, 0.5)
end

function TestPlot.test_index_after_end()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local result = plot[6]

  luaunit.assert_is_nil(result)
end

function TestPlot.test_index_after_end_fractional()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local result = plot[5.2]

  luaunit.assert_is_nil(result)
end

function TestPlot.test_ipairs_function()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local points = {}
  for index, point in ipairs(plot) do
    table.insert(points, {index = index, point = point})
  end

  luaunit.assert_equals(points, {
    {index = 1, point = 0.1},
    {index = 2, point = 0.2},
    {index = 3, point = 0.3},
    {index = 4, point = 0.4},
    {index = 5, point = 0.5},
  })
end

function TestPlot.test_ipairs_function_empty()
  local plot = Plot:new(0, 0.5)

  local points = {}
  for index, point in ipairs(plot) do
    table.insert(points, {index = index, point = point})
  end

  luaunit.assert_equals(points, {})
end

function TestPlot.test_ipairs_metamethod()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local points = {}
  for index, point in plot:__ipairs() do
    table.insert(points, {index = index, point = point})
  end

  luaunit.assert_equals(points, {
    {index = 1, point = 0.1},
    {index = 2, point = 0.2},
    {index = 3, point = 0.3},
    {index = 4, point = 0.4},
    {index = 5, point = 0.5},
  })
end

function TestPlot.test_ipairs_metamethod_empty()
  local plot = Plot:new(0, 0.5)

  local points = {}
  for index, point in plot:__ipairs() do
    table.insert(points, {index = index, point = point})
  end

  luaunit.assert_equals(points, {})
end

function TestPlot.test_push_in_range()
  local plot = Plot:new(5, 0.5)
  plot:push(0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.5, 0.5, 0.5, 0.5, 0.5, 0.2})
end

function TestPlot.test_push_too_less()
  local plot = Plot:new(5, 0.5)
  plot:push(-0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.5, 0.5, 0.5, 0.5, 0.5, 0})
end

function TestPlot.test_push_too_greater()
  local plot = Plot:new(5, 0.5)
  plot:push(1.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.5, 0.5, 0.5, 0.5, 0.5, 1})
end

function TestPlot.test_push_empty()
  local plot = Plot:new(0, 0.5)
  plot:push(0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.2})
end

function TestPlot.test_push_with_factor_in_range_positive()
  local plot = Plot:new(5, 0.5)
  plot:push_with_factor(0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.5, 0.5, 0.5, 0.5, 0.5, 0.7})
end

function TestPlot.test_push_with_factor_in_range_negative()
  local plot = Plot:new(5, 0.5)
  plot:push_with_factor(-0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.5, 0.5, 0.5, 0.5, 0.5, 0.3})
end

function TestPlot.test_push_with_factor_out_range()
  local plot = Plot:new(5, 0.5)
  plot:push_with_factor(0.6)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.5, 0.5, 0.5, 0.5, 0.5, 1})
end

function TestPlot.test_push_with_factor_empty()
  local plot = Plot:new(0, 0.5)
  plot:push_with_factor(0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.7})
end

function TestPlot.test_push_with_random_factor()
  math.randomseed(1)

  local plot = Plot:new(5, 0.5)
  plot:push_with_random_factor(0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(#plot._points, 6)
  luaunit.assert_almost_equals(plot._points[6], 0.457753, 1e-6)
end

function TestPlot.test_shift()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local first_point = plot:shift()

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.2, 0.3, 0.4, 0.5})

  luaunit.assert_is_number(first_point)
  luaunit.assert_equals(first_point, 0.1)
end

function TestPlot.test_shift_empty()
  local plot = Plot:new(0, 0.5)
  local first_point = plot:shift()

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {})

  luaunit.assert_is_number(first_point)
  luaunit.assert_equals(first_point, 0.5)
end
