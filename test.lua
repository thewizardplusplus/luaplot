local luaunit = require("luaunit")

for _, module in ipairs({
  "plot",
  "plotiterator",
  "plotiteratorfactory",
  "oscillogram",
  "distancelimit",
  "iterators",
  "iterable",
}) do
  require("luaplot." .. module .. "_test")
end

os.exit(luaunit.run())
