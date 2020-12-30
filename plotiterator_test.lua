local luaunit = require("luaunit")
local types = require("luaplot.types")
local Plot = require("luaplot.plot")
local PlotIterator = require("luaplot.plotiterator")

-- luacheck: globals TestPlotIterator
TestPlotIterator = {}

function TestPlotIterator.test_new()
  local function transformer()
    assert(false, "it should not be called")
  end

  local plot = Plot:new(5, 32, 23, 42)
  local iterator = PlotIterator:new(plot, transformer)

  luaunit.assert_is_table(iterator)
  luaunit.assert_true(types.is_instance(iterator, PlotIterator))

  luaunit.assert_is_table(iterator._plot)
  luaunit.assert_true(types.is_instance(iterator._plot, Plot))
  luaunit.assert_equals(iterator._plot, plot)

  luaunit.assert_is_function(iterator._transformer)
  luaunit.assert_equals(iterator._transformer, transformer)
end
