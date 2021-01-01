---
-- @classmod PlotIteratorFactory

local middleclass = require("middleclass")
local types = require("luaplot.types")

---
-- @table instance
-- @tfield func _transformer func(index: number, point: number): any

local PlotIteratorFactory = middleclass("PlotIteratorFactory")

---
-- @function new
-- @tparam func transformer func(index: number, point: number): any
-- @treturn PlotIteratorFactory
function PlotIteratorFactory:initialize(transformer)
  assert(types.is_callable(transformer))

  self._transformer = transformer
end

return PlotIteratorFactory
