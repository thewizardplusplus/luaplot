local luaunit = require("luaunit")
local assertions = require("luatypechecks.assertions")
local checks = require("luatypechecks.checks")
local Plot = require("luaplot.plot")
local PlotIterator = require("luaplot.plotiterator")

-- luacheck: globals TestPlotIterator
TestPlotIterator = {}

function TestPlotIterator.test_new()
  local function transformer()
    assert(false, "it should not be called")
  end

  local plot = Plot:new(5, 32, 23, 42)
  local iterator = PlotIterator:new(plot, transformer)

  luaunit.assert_is_table(iterator)
  luaunit.assert_true(checks.is_instance(iterator, PlotIterator))

  luaunit.assert_is_table(iterator._plot)
  luaunit.assert_true(checks.is_instance(iterator._plot, Plot))
  luaunit.assert_equals(iterator._plot, plot)

  luaunit.assert_is_function(iterator._transformer)
  luaunit.assert_equals(iterator._transformer, transformer)
end

function TestPlotIterator.test_index_middle()
  local function transformer(index, point)
    assertions.is_number(index)
    assertions.is_number(point)

    return point * index
  end

  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local iterator = PlotIterator:new(plot, transformer)
  local point = iterator[3]

  luaunit.assert_is_number(point)
  luaunit.assert_almost_equals(point, 0.9, 1e-6)
end

function TestPlotIterator.test_index_start()
  local function transformer(index, point)
    assertions.is_number(index)
    assertions.is_number(point)

    return point * index
  end

  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local iterator = PlotIterator:new(plot, transformer)
  local point = iterator[1]

  luaunit.assert_is_number(point)
  luaunit.assert_almost_equals(point, 0.1, 1e-6)
end

function TestPlotIterator.test_index_end()
  local function transformer(index, point)
    assertions.is_number(index)
    assertions.is_number(point)

    return point * index
  end

  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local iterator = PlotIterator:new(plot, transformer)
  local point = iterator[5]

  luaunit.assert_is_number(point)
  luaunit.assert_almost_equals(point, 2.5, 1e-6)
end

function TestPlotIterator.test_index_after_end()
  local function transformer()
    assert(false, "it should not be called")
  end

  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local iterator = PlotIterator:new(plot, transformer)
  local result = iterator[6]

  luaunit.assert_is_nil(result)
end

function TestPlotIterator.test_ipairs_function()
  if _VERSION == "Lua 5.1" then
    luaunit.skip(
      "Lua 5.1 doesn't support for customizing the `ipairs()` function"
    )
  end

  local function transformer(index, point)
    assertions.is_number(index)
    assertions.is_number(point)

    return point * index
  end

  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local iterator = PlotIterator:new(plot, transformer)

  local points = {}
  for index, point in ipairs(iterator) do
    table.insert(points, {index = index, point = point})
  end

  local wanted_points = {
    {index = 1, point = 0.1},
    {index = 2, point = 0.4},
    {index = 3, point = 0.9},
    {index = 4, point = 1.6},
    {index = 5, point = 2.5},
  }
  luaunit.assert_equals(#points, #wanted_points)
  for index, point in ipairs(points) do
    local wanted_point = wanted_points[index]
    luaunit.assert_equals(point.index, wanted_point.index)
    luaunit.assert_almost_equals(point.point, wanted_point.point, 1e-6)
  end
end

function TestPlotIterator.test_ipairs_function_empty()
  if _VERSION == "Lua 5.1" then
    luaunit.skip(
      "Lua 5.1 doesn't support for customizing the `ipairs()` function"
    )
  end

  local function transformer()
    assert(false, "it should not be called")
  end

  local plot = Plot:new(0, 0.5)
  local iterator = PlotIterator:new(plot, transformer)

  local points = {}
  for index, point in ipairs(iterator) do
    table.insert(points, {index = index, point = point})
  end

  luaunit.assert_equals(points, {})
end

function TestPlotIterator.test_ipairs_metamethod()
  local function transformer(index, point)
    assertions.is_number(index)
    assertions.is_number(point)

    return point * index
  end

  local plot = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local iterator = PlotIterator:new(plot, transformer)

  local points = {}
  for index, point in iterator:__ipairs() do
    table.insert(points, {index = index, point = point})
  end

  local wanted_points = {
    {index = 1, point = 0.1},
    {index = 2, point = 0.4},
    {index = 3, point = 0.9},
    {index = 4, point = 1.6},
    {index = 5, point = 2.5},
  }
  luaunit.assert_equals(#points, #wanted_points)
  for index, point in ipairs(points) do
    local wanted_point = wanted_points[index]
    luaunit.assert_equals(point.index, wanted_point.index)
    luaunit.assert_almost_equals(point.point, wanted_point.point, 1e-6)
  end
end

function TestPlotIterator.test_ipairs_metamethod_empty()
  local function transformer()
    assert(false, "it should not be called")
  end

  local plot = Plot:new(0, 0.5)
  local iterator = PlotIterator:new(plot, transformer)

  local points = {}
  for index, point in iterator:__ipairs() do
    table.insert(points, {index = index, point = point})
  end

  luaunit.assert_equals(points, {})
end
