local inspect = require("inspect")
local types = require("luaplot.types")
local Plot = require("luaplot.plot")
local PlotIteratorFactory = require("luaplot.plotiteratorfactory")

local function print_iterable(iterable)
  local ipairs_metamethod = _VERSION >= "Lua 5.3" and "__index" or "__ipairs"
  assert(types.has_metamethod(iterable, ipairs_metamethod))

  local points = {}
  for _, point in ipairs(iterable) do
    table.insert(points, point)
  end

  print(inspect(points))
end

local iterator = PlotIteratorFactory:new(function(index, point)
  assert(types.is_number_with_limits(index, 1))
  assert(types.is_number_with_limits(point))

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
