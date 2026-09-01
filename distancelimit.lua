-- luacheck: no max comment line length

---
-- @classmod DistanceLimit

local middleclass = require("middleclass")
local inspect = require("inspect")
local assertions = require("luatypechecks.assertions")
local checks = require("luatypechecks.checks")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")

local DistanceLimit = middleclass("DistanceLimit")
DistanceLimit:include(Nameable)
DistanceLimit:include(Stringifiable)

---
-- @function schema
-- @static
-- @treturn tab JSON Schema for this class
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function DistanceLimit.static.schema()
  return {
    type = "object",
    required = {"maximal_distance", "suitable_value"},
    properties = {
      maximal_distance = { type = "number" },
      suitable_value = {},
    },
  }
end

---
-- @function from_options
-- @static
-- @tparam tab options constructor options conforming to the JSON Schema
--   returned by @{DistanceLimit.schema|DistanceLimit.schema()}
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
-- @treturn DistanceLimit
function DistanceLimit.static.from_options(options)
  assertions.is_table(options)

  return DistanceLimit:new(options.maximal_distance, options.suitable_value)
end

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

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function DistanceLimit:__data()
  -- TODO: remove after resolving https://github.com/thewizardplusplus/luaserialization/issues/2
  local suitable_value = self.suitable_value
  if
    checks.is_table(suitable_value)
      and not checks.has_metamethods(suitable_value, {"__data"})
  then
    suitable_value = inspect(suitable_value)
  end

  return {
    maximal_distance = self.maximal_distance,
    suitable_value = suitable_value,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

return DistanceLimit
