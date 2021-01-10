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
