-- luarocks install inspect 3.1.1-0
local inspect = require("inspect")
local assertions = require("luatypechecks.assertions")
local Plot = require("luaplot.plot")
local PlotIteratorFactory = require("luaplot.plotiteratorfactory")

local function print_iterable(iterable)
  if _VERSION >= "Lua 5.3" then
    assertions.has_metamethods(iterable, {"__index"})
  else
    assertions.has_metamethods(iterable, {"__ipairs"})
  end

  local points = {}
  for _, point in ipairs(iterable) do
    table.insert(points, point)
  end

  print(inspect(points))
end

local iterator = PlotIteratorFactory:new(function(index, point)
  assertions.is_number(index)
  assertions.is_number(point)

  return {x = index, y = point}
end)

local plot_one = Plot:new(0)
for i = 1, 5 do
  plot_one:push(i / 10)
end
print_iterable(iterator:with(plot_one))

local plot_two = Plot:new(0)
for i = 1, 5 do
  plot_two:push(i / 20)
end
print_iterable(iterator:with(plot_two))
