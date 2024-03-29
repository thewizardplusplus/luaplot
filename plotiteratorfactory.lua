---
-- @classmod PlotIteratorFactory

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Plot = require("luaplot.plot")
local PlotIterator = require("luaplot.plotiterator")

---
-- @table instance
-- @tfield func _transformer func(index: number, point: number): any

local PlotIteratorFactory = middleclass("PlotIteratorFactory")

---
-- @function new
-- @tparam func transformer func(index: number, point: number): any
-- @treturn PlotIteratorFactory
function PlotIteratorFactory:initialize(transformer)
  assertions.is_callable(transformer)

  self._transformer = transformer
end

---
-- @tparam Plot plot
-- @treturn PlotIterator
function PlotIteratorFactory:with(plot)
  assertions.is_instance(plot, Plot)

  return PlotIterator:new(plot, self._transformer)
end

return PlotIteratorFactory
