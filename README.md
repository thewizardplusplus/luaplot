# luaplot

[![doc:build](https://github.com/thewizardplusplus/luaplot/actions/workflows/doc.yaml/badge.svg)](https://github.com/thewizardplusplus/luaplot/actions/workflows/doc.yaml)
[![doc:link](https://img.shields.io/badge/doc%3Alink-link-blue?logo=github)](https://thewizardplusplus.github.io/luaplot/)
[![lint](https://github.com/thewizardplusplus/luaplot/actions/workflows/lint.yaml/badge.svg)](https://github.com/thewizardplusplus/luaplot/actions/workflows/lint.yaml)
[![test](https://github.com/thewizardplusplus/luaplot/actions/workflows/test.yaml/badge.svg)](https://github.com/thewizardplusplus/luaplot/actions/workflows/test.yaml)
[![luarocks](https://img.shields.io/badge/luarocks-link-blue?logo=lua)](https://luarocks.org/modules/thewizardplusplus/luaplot)

The library that implements a model of a 2D plot with support for displaying functions of time (as in an oscilloscope).

_**Disclaimer:** this library was written directly on an Android smartphone with the [QLua](https://play.google.com/store/apps/details?id=com.quseit.qlua5pro2) IDE._

## Features

- models:
  - 2D plot:
    - storing:
      - values of a displayed function;
      - limits for these values;
      - default value;
    - operations:
      - initializing:
        - filling a specified count of values by a specified default value;
      - iterating over values:
        - via the `__ipairs` metamethod (for Lua 5.2);
        - via the `__index` metamethod (for Lua 5.3+):
          - support of fractional indexes;
      - adding a new value:
        - specific;
        - with a shift from the last value:
          - with a specific shift;
          - with a random shift;
          - using a specified default value as the last value if no values;
        - clamping the added value to specified limits;
      - removing the first value:
        - returning the removed value:
          - returning a specified default value if no values;
  - 2D oscillogram:
    - extending the 2D plot model;
    - kinds:
      - custom (adding a specific new value);
      - linear (adding a new value with a specific shift from the last value);
      - random (adding a new value with a random shift from the last value);
    - operations:
      - updating:
        - first step: adding a new value;
        - second step: removing the first value;
  - 2D plot/oscillogram iterator:
    - storing:
      - 2D plot/oscillogram;
      - transformer for iterated values;
    - iterating over values of 2D plot/oscillogram:
      - via the `__ipairs` metamethod (for Lua 5.2);
      - via the `__index` metamethod (for Lua 5.3+);
    - applying transformations to iterated values via a specified transformer;
  - factory of a 2D plot/oscillogram iterator:
    - storing:
      - transformer for iterated values;
    - generating a 2D plot/oscillogram iterator for a specific 2D plot/oscillogram;
- global operations:
  - calculating a difference (a distance) between two 2D plots/oscillograms in the same index:
    - returning a difference (a distance) by modulo (optionally);
  - selecting a value by a distance between two 2D plots/oscillograms in the specific index:
    - selecting by the specified sequential distance ranges.

## Installation

```
$ luarocks install luaplot
```

## Examples

`luaplot.Plot`:

```lua
local colors = require("ansicolors")
local types = require("luaplot.types")
local Plot = require("luaplot.plot")

local function print_plot(plot, vertical_step)
  assert(types.is_instance(plot, Plot))
  assert(types.is_number_with_limits(vertical_step, 0, 1))

  local text = ""
  for height = 1, 0, -vertical_step do
    for _, point in ipairs(plot) do
      local delta = math.abs(point - height)
      local symbol = delta < vertical_step / 2
        and colors("%{cyan}*%{reset}")
        or "."
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

local SPEED = 0.25
local WIDTH = 40
local HEIGHT = 10
local VERTICAL_STEP = 1 / HEIGHT
local PRINT_DELAY = 1 / (SPEED * WIDTH)
local FACTOR = 1.5 * PRINT_DELAY

math.randomseed(os.time())

local plot = Plot:new(WIDTH, 0.5)
while true do
  plot:shift()
  plot:push_with_random_factor(FACTOR)

  print_plot(plot, VERTICAL_STEP)
  sleep(PRINT_DELAY)
end
```

`luaplot.Oscillogram`:

```lua
local colors = require("ansicolors")
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
      local symbol = delta < vertical_step / 2
        and colors("%{cyan}*%{reset}")
        or "."
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

local SPEED = 0.25
local WIDTH = 40
local HEIGHT = 10
local VERTICAL_STEP = 1 / HEIGHT
local PRINT_DELAY = 1 / (SPEED * WIDTH)
local FACTOR = 1.5 * PRINT_DELAY

math.randomseed(os.time())

local plot = Oscillogram:new("random", WIDTH, 0.5)
while true do
  plot:update(FACTOR)

  print_plot(plot, VERTICAL_STEP)
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

Fractional indexes:

```lua
local iterators = require("luaplot.iterators")
local Plot = require("luaplot.plot")

local plot_one = Plot:new(0)
for i = 1, 5 do
  plot_one:push(i / 10)
end

local plot_two = Plot:new(0)
for i = 1, 5 do
  plot_two:push(i / 16)
end

local item_one = plot_one[3.2]
print(string.format("plot_one[3.2] = %g", item_one))

local item_two = plot_two[3.2]
print(string.format("plot_two[3.2] = %g", item_two))

local difference = iterators.difference(plot_one, plot_two, 3.2)
print(string.format("difference = %g", difference))
```

Distance detection:

```lua
local colors = require("ansicolors")
local types = require("luaplot.types")
local iterators = require("luaplot.iterators")
local Plot = require("luaplot.plot")
local Oscillogram = require("luaplot.oscillogram")
local DistanceLimit = require("luaplot.distancelimit")

local function print_plot(plot, vertical_step)
  assert(types.is_instance(plot, Plot))
  assert(types.is_number_with_limits(vertical_step, 0, 1))

  local text = ""
  for height = 1, 0, -vertical_step do
    for _, point in ipairs(plot) do
      local delta = math.abs(point - height)
      local symbol = delta < vertical_step / 2
        and colors("%{cyan}*%{reset}")
        or "."
      text = text .. symbol
    end

    text = text .. "\n"
  end

  io.write(text)
end

local function sleep(seconds)
  assert(types.is_number_with_limits(seconds, 0))

  local start = os.clock()
  while os.clock() - start < seconds do end
end

local SPEED = 0.25
local WIDTH = 40
local HEIGHT = 5
local VERTICAL_STEP = 1 / HEIGHT
local PRINT_DELAY = 1 / (SPEED * WIDTH)
local FACTOR = 1.5 * PRINT_DELAY

math.randomseed(os.time())

local plot_one = Oscillogram:new("random", WIDTH, 0.5)
local plot_two = Oscillogram:new("random", WIDTH, 0.5)
while true do
  plot_one:update(FACTOR)
  plot_two:update(FACTOR)

  local distance_marks = {}
  for index = 1, WIDTH do
    local distance_color =
      iterators.select_by_distance(plot_one, plot_two, index, {
        DistanceLimit:new(0.33, "green"),
        DistanceLimit:new(0.66, "yellow"),
        DistanceLimit:new(math.huge, "red"),
      })
    local distance_mark =
      colors(string.format("%%{%s}#%%{reset}", distance_color))
    table.insert(distance_marks, distance_mark)
  end

  print_plot(plot_one, VERTICAL_STEP)
  print_plot(plot_two, VERTICAL_STEP)
  for _ = 1, HEIGHT do
    io.write(table.concat(distance_marks, "") .. "\n")
  end
  io.write("\n")

  sleep(PRINT_DELAY)
end
```

## License

The MIT License (MIT)

Copyright &copy; 2020-2021 thewizardplusplus
