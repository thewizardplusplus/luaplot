local luaunit = require("luaunit")

for _, module in ipairs({
  "plot",
  "types",
  "maths",
  "iterators",
}) do
  require("luaplot." .. module .. "_test")
end

os.exit(luaunit.run())
