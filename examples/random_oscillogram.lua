-- luarocks install ansicolors 1.0.2-3
local colors = require("ansicolors")
local assertions = require("luatypechecks.assertions")
local Plot = require("luaplot.plot")
local Oscillogram = require("luaplot.oscillogram")

local function print_plot(plot, vertical_step)
  assertions.is_instance(plot, Plot)
  assertions.is_number(vertical_step)

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
  assertions.is_number(seconds)

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
