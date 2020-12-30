---
-- @classmod PlotIterator

local middleclass = require("middleclass")
local types = require("luaplot.types")
local Plot = require("luaplot.plot")

---
-- @table instance
-- @tfield Plot _plot
-- @tfield func _transformer func(index: number, point: number): any

local PlotIterator = middleclass("PlotIterator")

---
-- @function new
-- @tparam Plot plot
-- @tparam func transformer func(index: number, point: number): any
-- @treturn PlotIterator
function PlotIterator:initialize(plot, transformer)
  assert(types.is_instance(plot, Plot))
  assert(types._is_callable(transformer))

  self._plot = plot
  self._transformer = transformer
end

return PlotIterator
