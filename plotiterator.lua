---
-- @classmod PlotIterator

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Iterable = require("luaplot.iterable")
local Plot = require("luaplot.plot")

---
-- @table instance
-- @tfield Plot _plot
-- @tfield func _transformer func(index: number, point: number): any

local PlotIterator = middleclass("PlotIterator")
PlotIterator:include(Iterable)

---
-- @function new
-- @tparam Plot plot
-- @tparam func transformer func(index: number, point: number): any
-- @treturn PlotIterator
function PlotIterator:initialize(plot, transformer)
  assertions.is_instance(plot, Plot)
  assertions.is_callable(transformer)

  self._plot = plot
  self._transformer = transformer
end

---
-- It is used for iterating over plot points in Lua 5.3+.
-- @tparam number index [1, ∞)
-- @treturn number
function PlotIterator:__index(index)
  assertions.is_number(index)

  local point = self._plot[index]
  if point == nil then
    return
  end

  return self._transformer(index, point)
end

---
-- It is used for iterating over plot points in Lua 5.2.
-- @function __ipairs
-- @treturn iterators.inext iterator function
-- @treturn PlotIterator self
-- @treturn number always zero

return PlotIterator
