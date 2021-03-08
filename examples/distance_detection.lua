-- luarocks install ansicolors 1.0.2-3
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
