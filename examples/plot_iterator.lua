-- luarocks install inspect 3.1.3-0
local inspect = require("inspect")
local assertions = require("luatypechecks.assertions")
local checks = require("luatypechecks.checks")
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
    table.insert(points, point)
  end

  print(inspect(points))
end

local plot = Plot:new(0)
for i = 1, 5 do
  plot:push(i / 10)
end
print_iterable(plot)

local iterator_one = PlotIterator:new(plot, function(index, point)
  assertions.is_number(index)
  assertions.is_number(point)

  return point * index
end)
print_iterable(iterator_one)

local iterator_two = PlotIterator:new(plot, function(index, point)
  assertions.is_number(index)
  assertions.is_number(point)

  return { x = index, y = point }
end)
print_iterable(iterator_two)
