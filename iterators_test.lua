local luaunit = require("luaunit")
local iterators = require("luaplot.iterators")
local Plot = require("luaplot.plot")
local DistanceLimit = require("luaplot.distancelimit")

-- luacheck: globals TestIterators
TestIterators = {}

function TestIterators.test_inext_middle()
  local items = {10, 20, 30, 40, 50}
  local next_index, next_item = iterators.inext(items, 2)

  luaunit.assert_is_number(next_index)
  luaunit.assert_equals(next_index, 3)

  luaunit.assert_is_number(next_item)
  luaunit.assert_equals(next_item, 30)
end

function TestIterators.test_inext_start()
  local items = {10, 20, 30, 40, 50}
  local next_index, next_item = iterators.inext(items, 0)

  luaunit.assert_is_number(next_index)
  luaunit.assert_equals(next_index, 1)

  luaunit.assert_is_number(next_item)
  luaunit.assert_equals(next_item, 10)
end

function TestIterators.test_inext_end()
  local items = {10, 20, 30, 40, 50}
  local next_index, next_item = iterators.inext(items, 4)

  luaunit.assert_is_number(next_index)
  luaunit.assert_equals(next_index, 5)

  luaunit.assert_is_number(next_item)
  luaunit.assert_equals(next_item, 50)
end

function TestIterators.test_inext_after_end()
  local items = {10, 20, 30, 40, 50}
  local result = iterators.inext(items, 5)

  luaunit.assert_is_nil(result)
end

function TestIterators.test_difference_equal()
  local plot_one = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_one:push(i / 10)
  end

  local plot_two = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_two:push(i / 10)
  end

  local difference = iterators.difference(plot_one, plot_two, 2)

  luaunit.assert_is_number(difference)
  luaunit.assert_almost_equals(difference, 0, 1e-6)
end

function TestIterators.test_difference_equal_modulo()
  local plot_one = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_one:push(i / 10)
  end

  local plot_two = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_two:push(i / 10)
  end

  local difference = iterators.difference(plot_one, plot_two, 2, true)

  luaunit.assert_is_number(difference)
  luaunit.assert_almost_equals(difference, 0, 1e-6)
end

function TestIterators.test_difference_greater()
  local plot_one = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_one:push(i / 10 + i / 100)
  end

  local plot_two = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_two:push(i / 10)
  end

  local difference = iterators.difference(plot_one, plot_two, 2)

  luaunit.assert_is_number(difference)
  luaunit.assert_almost_equals(difference, 0.02, 1e-6)
end

function TestIterators.test_difference_greater_modulo()
  local plot_one = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_one:push(i / 10 + i / 100)
  end

  local plot_two = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_two:push(i / 10)
  end

  local difference = iterators.difference(plot_one, plot_two, 2, true)

  luaunit.assert_is_number(difference)
  luaunit.assert_almost_equals(difference, 0.02, 1e-6)
end

function TestIterators.test_difference_less()
  local plot_one = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_one:push(i / 10 - i / 100)
  end

  local plot_two = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_two:push(i / 10)
  end

  local difference = iterators.difference(plot_one, plot_two, 2)

  luaunit.assert_is_number(difference)
  luaunit.assert_almost_equals(difference, -0.02, 1e-6)
end

function TestIterators.test_difference_less_modulo()
  local plot_one = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_one:push(i / 10 - i / 100)
  end

  local plot_two = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_two:push(i / 10)
  end

  local difference = iterators.difference(plot_one, plot_two, 2, true)

  luaunit.assert_is_number(difference)
  luaunit.assert_almost_equals(difference, 0.02, 1e-6)
end

function TestIterators.test_select_by_distance()
  local plot_one = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_one:push(i / 10 - i / 100)
  end

  local plot_two = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_two:push(i / 10)
  end

  local values = {}
  for i = 1, 4 do
    local index = i + 0.5
    local value = iterators.select_by_distance(plot_one, plot_two, index, {
      DistanceLimit:new(-0.04, "one"),
      DistanceLimit:new(-0.02, "two"),
      DistanceLimit:new(math.huge, "three"),
    })
    table.insert(values, value)
  end

  luaunit.assert_equals(values, {"three", "two", "two", "one"})
end

function TestIterators.test_select_by_distance_modulo()
  local plot_one = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_one:push(i / 10 - i / 100)
  end

  local plot_two = Plot:new(0, 0.5)
  for i = 1, 5 do
    plot_two:push(i / 10)
  end

  local values = {}
  for i = 1, 4 do
    local index = i + 0.5
    local value =
      iterators.select_by_distance(plot_one, plot_two, index, true, {
        DistanceLimit:new(0.02, "one"),
        DistanceLimit:new(0.04, "two"),
        DistanceLimit:new(math.huge, "three"),
      })
    table.insert(values, value)
  end

  luaunit.assert_equals(values, {"one", "two", "two", "three"})
end
