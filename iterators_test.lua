local luaunit = require("luaunit")
local iterators = require("luaplot.iterators")

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