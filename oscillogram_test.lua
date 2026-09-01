local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local json = require("luaserialization.json")
local Range = require("luamath.models.range")
local Oscillogram = require("luaplot.oscillogram")

-- luacheck: globals TestOscillogram
TestOscillogram = {}

function TestOscillogram.test_from_json_success()
  local plot, err = json.from_json(
    [=[{
      "__name": "Oscillogram",
      "kind": "linear",
      "points": [0.1, 0.2, 0.3],
      "default": 0.5,
      "range": {"__name": "Range", "min": 0, "max": 1}
    }]=],
    Oscillogram.schema(),
    { Range = Range.from_options, Oscillogram = Oscillogram.from_options }
  )

  luaunit.assert_is_table(plot)
  luaunit.assert_true(checks.is_instance(plot, Oscillogram))

  luaunit.assert_is_string(plot._kind)
  luaunit.assert_equals(plot._kind, "linear")

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.1, 0.2, 0.3})

  luaunit.assert_is_number(plot._default)
  luaunit.assert_equals(plot._default, 0.5)

  luaunit.assert_is_table(plot._range)
  luaunit.assert_true(checks.is_instance(plot._range, Range))
  luaunit.assert_equals(plot._range, Range:new(0, 1))

  luaunit.assert_nil(err)
end

function TestOscillogram.test_from_json_error()
  local plot, err = json.from_json(
    [=[{
      "__name": "Oscillogram",
      "kind": "linear",
      "points": [0.1, "invalid", 0.3],
      "default": 0.5,
      "range": {"__name": "Range", "min": 0, "max": 1}
    }]=],
    Oscillogram.schema(),
    { Range = Range.from_options, Oscillogram = Oscillogram.from_options }
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

function TestOscillogram.test_new_full()
  local range = Range:new(23, 42)
  local plot = Oscillogram:new("random", 5, 32, range)

  luaunit.assert_is_table(plot)
  luaunit.assert_true(checks.is_instance(plot, Oscillogram))

  luaunit.assert_is_string(plot._kind)
  luaunit.assert_equals(plot._kind, "random")

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {32, 32, 32, 32, 32})

  luaunit.assert_is_number(plot._default)
  luaunit.assert_equals(plot._default, 32)

  luaunit.assert_is_table(plot._range)
  luaunit.assert_true(checks.is_instance(plot._range, Range))
  luaunit.assert_equals(plot._range, range)
end

function TestOscillogram.test_new_partial()
  local plot = Oscillogram:new("random", 5)

  luaunit.assert_is_table(plot)
  luaunit.assert_true(checks.is_instance(plot, Oscillogram))

  luaunit.assert_is_string(plot._kind)
  luaunit.assert_equals(plot._kind, "random")

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0, 0, 0, 0, 0})

  luaunit.assert_is_number(plot._default)
  luaunit.assert_equals(plot._default, 0)

  luaunit.assert_is_table(plot._range)
  luaunit.assert_true(checks.is_instance(plot._range, Range))
  luaunit.assert_equals(plot._range, Range:new(0, 1))
end

function TestOscillogram.test_tostring()
  local plot = Oscillogram:new("random", 5, 32, Range:new(23, 42))
  local text = tostring(plot)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"Oscillogram\"," ..
    "default = 32," ..
    "kind = \"random\"," ..
    "points = { 32, 32, 32, 32, 32 }," ..
    "range = {" ..
      "__name = \"Range\"," ..
      "max = 42," ..
      "min = 23" ..
    "}" ..
  "}")
end

function TestOscillogram.test_update_custom()
  local plot = Oscillogram:new("custom", 0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local first_point = plot:update(0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.2, 0.3, 0.4, 0.5, 0.2})

  luaunit.assert_is_number(first_point)
  luaunit.assert_equals(first_point, 0.1)
end

function TestOscillogram.test_update_linear()
  local plot = Oscillogram:new("linear", 0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local first_point = plot:update(0.2)

  luaunit.assert_is_table(plot._points)
  luaunit.assert_equals(plot._points, {0.2, 0.3, 0.4, 0.5, 0.7})

  luaunit.assert_is_number(first_point)
  luaunit.assert_equals(first_point, 0.1)
end

function TestOscillogram.test_update_random()
  math.randomseed(1)

  local plot = Oscillogram:new("random", 0, 0.5)
  for i = 1, 5 do
    plot:push(i / 10)
  end

  local first_point = plot:update(0.2)
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
  luaunit.assert_equals(#plot._points, 5)
  luaunit.assert_almost_equals(plot._points[5], last_point, 1e-6)

  luaunit.assert_is_number(first_point)
  luaunit.assert_equals(first_point, 0.1)
end
