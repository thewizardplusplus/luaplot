---
-- @classmod DistanceLimit

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")

local DistanceLimit = middleclass("Point")

---
-- @table instance
-- @tfield number maximal_distance
-- @tfield any suitable_value

---
-- @function new
-- @tparam number maximal_distance
-- @tparam any suitable_value
-- @treturn DistanceLimit
function DistanceLimit:initialize(maximal_distance, suitable_value)
  assertions.is_number(maximal_distance)

  self.maximal_distance = maximal_distance
  self.suitable_value = suitable_value
end

return DistanceLimit
