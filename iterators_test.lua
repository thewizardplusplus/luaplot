local luaunit = require("luaunit")
local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local iterators = require("luaplot.iterators")
local Plot = require("luaplot.plot")
local DistanceLimit = require("luaplot.distancelimit")

local function _item_difference(item_count, item_index)
  assertions.is_number(item_count)
  assertions.is_number(item_index)

  return ((item_count + 1) / 2 - item_index) / 100
end

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

function TestIterators.test_difference_tables()
  local item_count = 5

  local table_one = {}
  local table_two = {}
  for i = 1, item_count do
    table.insert(table_one, i / 10 + _item_difference(item_count, i))
    table.insert(table_two, i / 10)
  end

  local wanted_differences = {}
  local differences = {}
  for i = 1, item_count do
    table.insert(wanted_differences, _item_difference(item_count, i))

    local difference = iterators.difference(table_one, table_two, i)
    table.insert(differences, difference)
  end

  luaunit.assert_equals(#differences, #wanted_differences)
  for index, difference in ipairs(differences) do
    local wanted_difference = wanted_differences[index]
    luaunit.assert_almost_equals(difference, wanted_difference, 1e-6)
  end
end

function TestIterators.test_difference_tables_modulo()
  local item_count = 5

  local table_one = {}
  local table_two = {}
  for i = 1, item_count do
    table.insert(table_one, i / 10 + _item_difference(item_count, i))
    table.insert(table_two, i / 10)
  end

  local wanted_differences = {}
  local differences = {}
  for i = 1, item_count do
    table.insert(wanted_differences, math.abs(_item_difference(item_count, i)))

    local difference = iterators.difference(table_one, table_two, i, true)
    table.insert(differences, difference)
  end

  luaunit.assert_equals(#differences, #wanted_differences)
  for index, difference in ipairs(differences) do
    local wanted_difference = wanted_differences[index]
    luaunit.assert_almost_equals(difference, wanted_difference, 1e-6)
  end
end

function TestIterators.test_difference_indexables()
  local item_count = 5

  local plot_one = Plot:new(0, 0.5)
  local plot_two = Plot:new(0, 0.5)
  for i = 1, item_count do
    plot_one:push(i / 10 + _item_difference(item_count, i))
    plot_two:push(i / 10)
  end

  local wanted_differences = {}
  local differences = {}
  for i = 1, item_count do
    table.insert(wanted_differences, _item_difference(item_count, i))

    local difference = iterators.difference(plot_one, plot_two, i)
    table.insert(differences, difference)
  end

  luaunit.assert_equals(#differences, #wanted_differences)
  for index, difference in ipairs(differences) do
    local wanted_difference = wanted_differences[index]
    luaunit.assert_almost_equals(difference, wanted_difference, 1e-6)
  end
end

function TestIterators.test_difference_indexables_modulo()
  local item_count = 5

  local plot_one = Plot:new(0, 0.5)
  local plot_two = Plot:new(0, 0.5)
  for i = 1, item_count do
    plot_one:push(i / 10 + _item_difference(item_count, i))
    plot_two:push(i / 10)
  end

  local wanted_differences = {}
  local differences = {}
  for i = 1, item_count do
    table.insert(wanted_differences, math.abs(_item_difference(item_count, i)))

    local difference = iterators.difference(plot_one, plot_two, i, true)
    table.insert(differences, difference)
  end

  luaunit.assert_equals(#differences, #wanted_differences)
  for index, difference in ipairs(differences) do
    local wanted_difference = wanted_differences[index]
    luaunit.assert_almost_equals(difference, wanted_difference, 1e-6)
  end
end

function TestIterators.test_difference_vector2ds()
  local vectors_one = {Vector2D:new(1, 0.1)}
  local vectors_two = {Vector2D:new(2, 0.2)}

  local difference = iterators.difference(vectors_one, vectors_two, 1)

  luaunit.assert_is_number(difference)
  luaunit.assert_almost_equals(difference, -0.1, 1e-6)
end

function TestIterators.test_difference_vector2ds_modulo()
  local vectors_one = {Vector2D:new(1, 0.1)}
  local vectors_two = {Vector2D:new(2, 0.2)}

  local difference = iterators.difference(vectors_one, vectors_two, 1, true)

  luaunit.assert_is_number(difference)
  luaunit.assert_almost_equals(difference, 0.1, 1e-6)
end

function TestIterators.test_select_by_distance_tables()
  local item_count = 5

  local table_one = {}
  local table_two = {}
  for i = 1, item_count do
    table.insert(table_one, i / 10 - i / 100)
    table.insert(table_two, i / 10)
  end

  local values = {}
  for i = 1, item_count do
    local value = iterators.select_by_distance(table_one, table_two, i, {
      DistanceLimit:new(-0.05 + 0.001, "one"),
      DistanceLimit:new(-0.02 + 0.001, "two"),
      DistanceLimit:new(math.huge, "three"),
    })
    table.insert(values, value)
  end

  luaunit.assert_equals(values, {"three", "two", "two", "two", "one"})
end

function TestIterators.test_select_by_distance_tables_modulo()
  local item_count = 5

  local table_one = {}
  local table_two = {}
  for i = 1, item_count do
    table.insert(table_one, i / 10 - i / 100)
    table.insert(table_two, i / 10)
  end

  local values = {}
  for i = 1, item_count do
    local value = iterators.select_by_distance(table_one, table_two, i, true, {
      DistanceLimit:new(0.02 - 0.001, "one"),
      DistanceLimit:new(0.05 - 0.001, "two"),
      DistanceLimit:new(math.huge, "three"),
    })
    table.insert(values, value)
  end

  luaunit.assert_equals(values, {"one", "two", "two", "two", "three"})
end

function TestIterators.test_select_by_distance_indexables()
  local item_count = 5

  local plot_one = Plot:new(0, 0.5)
  local plot_two = Plot:new(0, 0.5)
  for i = 1, item_count do
    plot_one:push(i / 10 - i / 100)
    plot_two:push(i / 10)
  end

  local values = {}
  for i = 1, item_count - 1 do
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

function TestIterators.test_select_by_distance_indexables_modulo()
  local item_count = 5

  local plot_one = Plot:new(0, 0.5)
  local plot_two = Plot:new(0, 0.5)
  for i = 1, item_count do
    plot_one:push(i / 10 - i / 100)
    plot_two:push(i / 10)
  end

  local values = {}
  for i = 1, item_count - 1 do
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
