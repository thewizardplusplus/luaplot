rockspec_format = "3.0"
package = "luaplot"
version = "1.3-1"
description = {
  summary = "The library that implements a model of a 2D plot with support for displaying functions of time (as in an oscilloscope).",
  license = "MIT",
  maintainer = "thewizardplusplus <thewizardplusplus@yandex.ru>",
  homepage = "https://github.com/thewizardplusplus/luaplot",
}
source = {
  url = "git+https://github.com/thewizardplusplus/luaplot.git",
  tag = "v1.3",
}
dependencies = {
  "lua >= 5.1",
  "middleclass >= 4.1.1, < 5.0",
}
test_dependencies = {
  "luaunit >= 3.3, < 4.0",
}
build = {
  type = "builtin",
  modules = {
    ["luaplot.types"] = "types.lua",
    ["luaplot.types_test"] = "types_test.lua",
    ["luaplot.maths"] = "maths.lua",
    ["luaplot.maths_test"] = "maths_test.lua",
    ["luaplot.iterators"] = "iterators.lua",
    ["luaplot.iterators_test"] = "iterators_test.lua",
    ["luaplot.iterable"] = "iterable.lua",
    ["luaplot.iterable_test"] = "iterable_test.lua",
    ["luaplot.plot"] = "plot.lua",
    ["luaplot.plot_test"] = "plot_test.lua",
    ["luaplot.plotiterator"] = "plotiterator.lua",
    ["luaplot.plotiterator_test"] = "plotiterator_test.lua",
    ["luaplot.plotiteratorfactory"] = "plotiteratorfactory.lua",
    ["luaplot.plotiteratorfactory_test"] = "plotiteratorfactory_test.lua",
    ["luaplot.oscillogram"] = "oscillogram.lua",
    ["luaplot.oscillogram_test"] = "oscillogram_test.lua",
    ["luaplot.distancelimit"] = "distancelimit.lua",
    ["luaplot.distancelimit_test"] = "distancelimit_test.lua",
  },
  copy_directories = {
    "doc",
  },
}
