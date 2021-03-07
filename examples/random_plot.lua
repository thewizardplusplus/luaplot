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
