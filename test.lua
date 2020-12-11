local luaunit = require("luaunit")

for _, module in ipairs({
  "plot",
}) do
  require("luaplot." .. module .. "_test")
end

os.exit(luaunit.run())
