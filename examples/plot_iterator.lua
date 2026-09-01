-- luarocks install inspect 3.1.3-0
local inspect = require("inspect")
local assertions = require("luatypechecks.assertions")
local checks = require("luatypechecks.checks")
local Vector2D = require("luamath.vector2d")
local Plot = require("luaplot.plot")
local PlotIterator = require("luaplot.plotiterator")

local function print_iterable(iterable)
  if _VERSION >= "Lua 5.3" then
    assertions.is_true(
      checks.is_sequence(iterable)
        or checks.has_metamethods(iterable, {"__index"})
    )
  else
    assertions.has_metamethods(iterable, {"__ipairs"})
  end

  local points = {}
  for _, point in ipairs(iterable) do
    table.insert(points, tostring(point))
  end

  print(inspect(points))
end

local plot = Plot:new(0)
for i = 1, 5 do
  plot:push(i / 10)
end
print_iterable(plot)

local iterator_one = PlotIterator:new(plot, function(point)
  assertions.is_instance(point, Vector2D)

  return point.x * point.y
end)
print_iterable(iterator_one)

local iterator_two = PlotIterator:new(plot, function(point)
  assertions.is_instance(point, Vector2D)

  return point.x ^ point.y
end)
print_iterable(iterator_two)
