local luaunit = require("luaunit")
local types = require("luaplot.types")
local Plot = require("luaplot.plot")
local PlotIterator = require("luaplot.plotiterator")
local PlotIteratorFactory = require("luaplot.plotiteratorfactory")

-- luacheck: globals TestPlotIteratorFactory
TestPlotIteratorFactory = {}

function TestPlotIteratorFactory.test_new()
  local function transformer()
    assert(false, "it should not be called")
  end

  local factory = PlotIteratorFactory:new(transformer)

  luaunit.assert_is_table(factory)
  luaunit.assert_true(types.is_instance(factory, PlotIteratorFactory))

  luaunit.assert_is_function(factory._transformer)
  luaunit.assert_equals(factory._transformer, transformer)
end

function TestPlotIteratorFactory.test_with()
  local function transformer()
    assert(false, "it should not be called")
  end

  local plot = Plot:new(5, 32, 23, 42)
  local factory = PlotIteratorFactory:new(transformer)
  local iterator = factory:with(plot)

  luaunit.assert_is_table(iterator)
  luaunit.assert_true(types.is_instance(iterator, PlotIterator))

  luaunit.assert_is_table(iterator._plot)
  luaunit.assert_true(types.is_instance(iterator._plot, Plot))
  luaunit.assert_equals(iterator._plot, plot)

  luaunit.assert_is_function(iterator._transformer)
  luaunit.assert_equals(iterator._transformer, transformer)
end
