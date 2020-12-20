local types = require("luaplot.types")
local Plot = require("luaplot.plot")

local function print_plot(plot)
  assert(types.is_instance(plot, Plot))

  for _, point in ipairs(plot) do
    point = math.floor(5 * point)
    io.write(string.format("%d ", point))
  end
  io.write("\n")
end

local function sleep(seconds)
  assert(types.is_number_with_limits(seconds, 0))

  local start = os.clock()
  while os.clock() - start < seconds do end
end

math.randomseed(os.time())

local plot = Plot:new(0)
for _ = 1, 10 do
  plot:push(0.5)
end

while true do
  plot:shift()
  plot:push_with_random_factor(0.2)

  print_plot(plot)
  sleep(0.2)
end
