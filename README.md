# luaplot

The library that implements a model of a 2D plot with support for displaying functions of time (as in an oscilloscope).

## Installation

Clone this repository:

```
$ git clone https://github.com/thewizardplusplus/luaplot.git
$ cd luaplot
```

Install the library with the [LuaRocks](https://luarocks.org/) tool:

```
$ luarocks make
```

## Examples

`luaplot.Plot`:

```lua
local types = require("luaplot.types")
local Plot = require("luaplot.plot")

local function print_plot(plot, vertical_step)
  assert(types.is_instance(plot, Plot))
  assert(types.is_number_with_limits(vertical_step, 0, 1))

  local text = ""
  for height = 1, 0, -vertical_step do
    for _, point in ipairs(plot) do
      local delta = math.abs(point - height)
      local symbol = delta < vertical_step / 2 and "*" or "."
      text = text .. symbol
    end

    text = text .. "\n"
  end

  print(text)
end

local function sleep(seconds)
  assert(types.is_number_with_limits(seconds, 0))

  local start = os.clock()
  while os.clock() - start < seconds do end
end

local WIDTH = 40
local HEIGHT = 10
local NOISE_FACTOR = 1.5
local PRINT_DELAY = 0.1

math.randomseed(os.time())

local plot = Plot:new(WIDTH, 0.5)
local vertical_step = 1 / HEIGHT
while true do
  plot:shift()
  plot:push_with_random_factor(NOISE_FACTOR * vertical_step)

  print_plot(plot, vertical_step)
  sleep(PRINT_DELAY)
end
```

`luaplot.Oscillogram`:

```lua
local types = require("luaplot.types")
local Plot = require("luaplot.plot")
local Oscillogram = require("luaplot.oscillogram")

local function print_plot(plot, vertical_step)
  assert(types.is_instance(plot, Plot))
  assert(types.is_number_with_limits(vertical_step, 0, 1))

  local text = ""
  for height = 1, 0, -vertical_step do
    for _, point in ipairs(plot) do
      local delta = math.abs(point - height)
      local symbol = delta < vertical_step / 2 and "*" or "."
      text = text .. symbol
    end

    text = text .. "\n"
  end

  print(text)
end

local function sleep(seconds)
  assert(types.is_number_with_limits(seconds, 0))

  local start = os.clock()
  while os.clock() - start < seconds do end
end

local WIDTH = 40
local HEIGHT = 10
local NOISE_FACTOR = 1.5
local PRINT_DELAY = 0.1

math.randomseed(os.time())

local plot = Oscillogram:new("random", WIDTH, 0.5)
local vertical_step = 1 / HEIGHT
while true do
  plot:update(NOISE_FACTOR * vertical_step)

  print_plot(plot, vertical_step)
  sleep(PRINT_DELAY)
end
```

`luaplot.PlotIterator`:

```lua
local inspect = require("inspect")
local types = require("luaplot.types")
local Plot = require("luaplot.plot")
local PlotIterator = require("luaplot.plotiterator")

local function print_iterable(iterable)
  local ipairs_metamethod = _VERSION >= "Lua 5.3" and "__index" or "__ipairs"
  assert(types.has_metamethod(iterable, ipairs_metamethod))

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
  assert(types.is_number_with_limits(index, 1))
  assert(types.is_number_with_limits(point))

  return point * index
end)
print_iterable(iterator_one)

local iterator_two = PlotIterator:new(plot, function(index, point)
  assert(types.is_number_with_limits(index, 1))
  assert(types.is_number_with_limits(point))

  return {x = index, y = point}
end)
print_iterable(iterator_two)
```

`luaplot.PlotIteratorFactory`:

```lua
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
```

## License

The MIT License (MIT)

Copyright &copy; 2020 thewizardplusplus
