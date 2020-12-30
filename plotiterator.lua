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

---
-- It is used for iterating over plot points in Lua 5.3+.
-- @tparam number index [1, ∞)
-- @treturn number
function PlotIterator:__index(index)
  assert(types.is_number_with_limits(index, 1))

  local point = self._plot[index]
  if point == nil then
    return
  end

  return self._transformer(index, point)
end

return PlotIterator
