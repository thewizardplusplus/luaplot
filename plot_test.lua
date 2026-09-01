local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Range = require("luamath.models.range")
local Plot = require("luaplot.plot")

-- luacheck: globals TestPlot
TestPlot = {}

function TestPlot.test_from_json_success()
  local plot, err = json.from_json(
    [=[{
      "__name": "Plot",
      "points": [0.1, 0.2, 0.3],
      "default": 0.5,
      "range": {"__name": "Range", "min": 0, "max": 1}
    }]=],
    Plot.schema(),
    { Range = Range.from_options, Plot = Plot.from_options }
  )

  luaunit.assert_is_table(plot)
  luaunit.assert_true(checks.is_instance(plot, Plot))

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.1, 0.2, 0.3})

  luaunit.assert_is_number(plot._default)
  luaunit.assert_equals(plot._default, 0.5)

  luaunit.assert_is_table(plot._range)
  luaunit.assert_true(checks.is_instance(plot._range, Range))
  luaunit.assert_equals(plot._range, Range:new(0, 1))

  luaunit.assert_nil(err)
end

function TestPlot.test_from_json_error()
  local plot, err = json.from_json(
    [=[{
      "__name": "Plot",
      "points": [0.1, "invalid", 0.3],
      "default": 0.5,
      "range": {"__name": "Range", "min": 0, "max": 1}
    }]=],
    Plot.schema(),
    { Range = Range.from_options, Plot = Plot.from_options }
  )

  luaunit.assert_nil(plot)

  luaunit.assert_is_string(err)
  luaunit.assert_str_matches(
    err,
    "^invalid data: " ..
      [[property "points" validation failed: ]] ..
      "failed to validate item 2: " ..
      "wrong type: " ..
      "expected number, got string$"
  )
end

function TestPlot.test_new_full()
  local range = Range:new(23, 42)
  local plot = Plot:new(5, 32, range)

  luaunit.assert_is_table(plot)
  luaunit.assert_true(checks.is_instance(plot, Plot))

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {32, 32, 32, 32, 32})

  luaunit.assert_is_number(plot._default)
  luaunit.assert_equals(plot._default, 32)

  luaunit.assert_is_table(plot._range)
  luaunit.assert_true(checks.is_instance(plot._range, Range))
  luaunit.assert_equals(plot._range, range)
end

function TestPlot.test_new_partial()
  local plot = Plot:new(5)

  luaunit.assert_is_table(plot)
  luaunit.assert_true(checks.is_instance(plot, Plot))

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0, 0, 0, 0, 0})

  luaunit.assert_is_number(plot._default)
  luaunit.assert_equals(plot._default, 0)

  luaunit.assert_is_table(plot._range)
  luaunit.assert_true(checks.is_instance(plot._range, Range))
  luaunit.assert_equals(plot._range, Range:new(0, 1))
end

function TestPlot.test_index_middle()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local point = plot[3]

  luaunit.assert_is_table(point)
  luaunit.assert_true(checks.is_instance(point, Vector2D))
  luaunit.assert_equals(point, Vector2D:new(3, 0.3))
end

function TestPlot.test_index_middle_fractional_increase()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local point = plot[3.2]

  luaunit.assert_is_table(point)
  luaunit.assert_true(checks.is_instance(point, Vector2D))
  luaunit.assert_equals(point, Vector2D:new(3.2, 0.32))
end

function TestPlot.test_index_middle_fractional_decrease()
  local plot = Plot:new(0, -0.5, Range:new(-1, 0))
  for i = 1, 5 do
    plot:push(-i / 10)
  end

  local point = plot[3.2]

  luaunit.assert_is_table(point)
  luaunit.assert_true(checks.is_instance(point, Vector2D))
  luaunit.assert_equals(point, Vector2D:new(3.2, -0.32))
end

function TestPlot.test_index_start()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local point = plot[1]

  luaunit.assert_is_table(point)
  luaunit.assert_true(checks.is_instance(point, Vector2D))
  luaunit.assert_equals(point, Vector2D:new(1, 0.1))
end

function TestPlot.test_index_end()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local point = plot[5]

  luaunit.assert_is_table(point)
  luaunit.assert_true(checks.is_instance(point, Vector2D))
  luaunit.assert_equals(point, Vector2D:new(5, 0.5))
end

function TestPlot.test_index_after_end()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local result = plot[6]

  luaunit.assert_is_nil(result)
end

function TestPlot.test_index_after_end_fractional_increase()
  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local result = plot[5.2]

  luaunit.assert_is_nil(result)
end

function TestPlot.test_index_after_end_fractional_decrease()
  local plot = Plot:new(0, -0.5, Range:new(-1, 0))
  for i = 1, 5 do
    plot:push(-i / 10)
  end

  local result = plot[5.2]

  luaunit.assert_is_nil(result)
end

function TestPlot.test_ipairs_function()
  if _VERSION == "Lua 5.1" then
    local message =
      "Lua 5.1 doesn't support for customizing the `ipairs()` function"
    luaunit.skip(message)
  end

  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local points = {}
  for index, point in ipairs(plot) do
    table.insert(points, {index = index, point = point})
  end

  luaunit.assert_equals(points, {
    {index = 1, point = Vector2D:new(1, 0.1)},
    {index = 2, point = Vector2D:new(2, 0.2)},
    {index = 3, point = Vector2D:new(3, 0.3)},
    {index = 4, point = Vector2D:new(4, 0.4)},
    {index = 5, point = Vector2D:new(5, 0.5)},
  })
end

function TestPlot.test_ipairs_function_empty()
  if _VERSION == "Lua 5.1" then
    local message =
      "Lua 5.1 doesn't support for customizing the `ipairs()` function"
    luaunit.skip(message)
  end

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
    {index = 1, point = Vector2D:new(1, 0.1)},
    {index = 2, point = Vector2D:new(2, 0.2)},
    {index = 3, point = Vector2D:new(3, 0.3)},
    {index = 4, point = Vector2D:new(4, 0.4)},
    {index = 5, point = Vector2D:new(5, 0.5)},
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

function TestPlot.test_tostring()
  local plot = Plot:new(5, 32, Range:new(23, 42))
  local text = tostring(plot)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"Plot\"," ..
    "default = 32," ..
    "points = { 32, 32, 32, 32, 32 }," ..
    "range = {" ..
      "__name = \"Range\"," ..
      "max = 42," ..
      "min = 23" ..
    "}" ..
  "}")
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

  local last_point
  if _VERSION == "Lua 5.5" or _VERSION == "Lua 5.4" then
    last_point = 0.626235
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    last_point = 0.457753
  elseif _VERSION == "Lua 5.1" then
    if checks.is_table(jit) then -- check for LuaJIT
      last_point = 0.429524
    else
      last_point = 0.636075
    end
  end

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(#plot._points, 6)
  luaunit.assert_almost_equals(plot._points[6], last_point, 1e-6)
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
