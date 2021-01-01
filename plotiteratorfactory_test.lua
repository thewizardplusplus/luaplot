local luaunit = require("luaunit")
local types = require("luaplot.types")
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
