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

## License

The MIT License (MIT)

Copyright &copy; 2020 thewizardplusplus
