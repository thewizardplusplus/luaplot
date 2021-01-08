local luaunit = require("luaunit")

for _, module in ipairs({
  "plot",
  "plotiterator",
  "plotiteratorfactory",
  "oscillogram",
  "types",
  "maths",
  "iterators",
  "iterable",
}) do
  require("luaplot." .. module .. "_test")
end

os.exit(luaunit.run())
