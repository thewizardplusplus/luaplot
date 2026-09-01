# Change Log

## [v1.3.1](https://github.com/thewizardplusplus/luaplot/tree/v1.3.1) (2026-09-02)

Using the `luatypechecks`, `luaserialization`, and `luamath` libraries for type validation, model serialization, and mathematical primitives.

- models:
  - 2D plot:
    - storing limits as a `Range` from the [luamath](https://github.com/thewizardplusplus/luamath) library;
    - iterating over points represented as `Vector2D(index, value)` from the [luamath](https://github.com/thewizardplusplus/luamath) library;
    - copying mutable constructor and factory inputs;
  - distance limit:
    - fixing the class name from `Point` to `DistanceLimit`;
  - 2D plot, 2D oscillogram, and distance limit:
    - exposing a class name and a stringified representation via the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library;
    - generating a JSON Schema via the `schema()` static method;
    - constructing an instance from serializable options via the `from_options()` static method;
- global operations:
  - supporting both sequences and objects with the `__index` metamethod in the `iterators` package;
  - calculating the vertical difference between points represented as `Vector2D` objects;
- refactoring:
  - replacing the internal `types` package with the [luatypechecks](https://github.com/thewizardplusplus/luatypechecks) library;
  - replacing the internal `maths` package and the CPML library with the [luamath](https://github.com/thewizardplusplus/luamath) library;
  - adding the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library;
- misc.:
  - adding GitHub Actions workflows for tests, linting, and documentation deployment;
  - supporting Lua 5.1, 5.2, 5.3, 5.4, 5.5, and LuaJIT;
  - improving the generated documentation.

## [v1.3](https://github.com/thewizardplusplus/luaplot/tree/v1.3) (2021-03-08)

Selecting a value by a distance between two 2D plots/oscillograms in the specific index.

- global operations:
  - selecting a value by a distance between two 2D plots/oscillograms in the specific index:
    - selecting by the specified sequential distance ranges;
- refactoring:
  - using the [cpml](https://github.com/excessive/cpml) library:
    - using the `cpml.utils.clamp()` function;
    - using the `cpml.utils.lerp()` function;
- examples:
  - colorizing the plots in the examples;
  - specifying the versions of the example dependencies.

## [v1.2.1](https://github.com/thewizardplusplus/luaplot/tree/v1.2.1) (2021-02-13)

Describing releases of the library.

- describing for releases:
  - features;
  - change log.

## [v1.2](https://github.com/thewizardplusplus/luaplot/tree/v1.2) (2021-01-10)

Calculating a difference (a distance) between two 2D plots/oscillograms in the same index.

- models:
  - 2D plot:
    - operations:
      - iterating over values:
        - via the `__ipairs` metamethod (for Lua 5.2):
          - using the `__index` metamethod for accessing by index;
        - via the `__index` metamethod (for Lua 5.3+):
          - support of fractional indexes;
- global operations:
  - calculating a difference (a distance) between two 2D plots/oscillograms in the same index:
    - returning a difference (a distance) by modulo (optionally);
- refactoring:
  - adding the `maths.lerp()` function;
  - adding the `Iterable` mixin.

### Features

- models:
  - 2D plot:
    - storing:
      - values of a displayed function;
      - limits for these values;
      - default value;
    - operations:
      - initializing:
        - filling a specified count of values by a specified default value;
      - iterating over values:
        - via the `__ipairs` metamethod (for Lua 5.2);
        - via the `__index` metamethod (for Lua 5.3+):
          - support of fractional indexes;
      - adding a new value:
        - specific;
        - with a shift from the last value:
          - with a specific shift;
          - with a random shift;
          - using a specified default value as the last value if no values;
        - clamping the added value to specified limits;
      - removing the first value:
        - returning the removed value:
          - returning a specified default value if no values;
  - 2D oscillogram:
    - extending the 2D plot model;
    - kinds:
      - custom (adding a specific new value);
      - linear (adding a new value with a specific shift from the last value);
      - random (adding a new value with a random shift from the last value);
    - operations:
      - updating:
        - first step: adding a new value;
        - second step: removing the first value;
  - 2D plot/oscillogram iterator:
    - storing:
      - 2D plot/oscillogram;
      - transformer for iterated values;
    - iterating over values of 2D plot/oscillogram:
      - via the `__ipairs` metamethod (for Lua 5.2);
      - via the `__index` metamethod (for Lua 5.3+);
    - applying transformations to iterated values via a specified transformer;
  - factory of a 2D plot/oscillogram iterator:
    - storing:
      - transformer for iterated values;
    - generating a 2D plot/oscillogram iterator for a specific 2D plot/oscillogram;
- global operations:
  - calculating a difference (a distance) between two 2D plots/oscillograms in the same index:
    - returning a difference (a distance) by modulo (optionally).

## [v1.1](https://github.com/thewizardplusplus/luaplot/tree/v1.1) (2021-01-03)

Adding models of a 2D oscillogram and a 2D plot/oscillogram iterator.

- models:
  - 2D plot:
    - storing:
      - default value;
    - operations:
      - initializing:
        - filling a specified count of values by a specified default value;
      - adding a new value:
        - with a shift from the last value:
          - using a specified default value as the last value if no values;
      - removing the first value:
        - returning the removed value:
          - returning a specified default value if no values;
  - 2D oscillogram:
    - extending the 2D plot model;
    - kinds:
      - custom (adding a specific new value);
      - linear (adding a new value with a specific shift from the last value);
      - random (adding a new value with a random shift from the last value);
    - operations:
      - updating:
        - first step: adding a new value;
        - second step: removing the first value;
  - 2D plot/oscillogram iterator:
    - storing:
      - 2D plot/oscillogram;
      - transformer for iterated values;
    - iterating over values of 2D plot/oscillogram:
      - via the `__ipairs` metamethod (for Lua 5.2);
      - via the `__index` metamethod (for Lua 5.3+);
    - applying transformations to iterated values via a specified transformer;
  - factory of a 2D plot/oscillogram iterator:
    - storing:
      - transformer for iterated values;
    - generating a 2D plot/oscillogram iterator for a specific 2D plot/oscillogram;
- refactoring:
  - adding the `maths` module:
    - adding the `maths.clamp()` function;
    - adding the `maths.random_in_range()` function;
  - adding the `iterators.inext()` function.

### Features

- models:
  - 2D plot:
    - storing:
      - values of a displayed function;
      - limits for these values;
      - default value;
    - operations:
      - initializing:
        - filling a specified count of values by a specified default value;
      - iterating over values:
        - via the `__ipairs` metamethod (for Lua 5.2);
        - via the `__index` metamethod (for Lua 5.3+);
      - adding a new value:
        - specific;
        - with a shift from the last value:
          - with a specific shift;
          - with a random shift;
          - using a specified default value as the last value if no values;
        - clamping the added value to specified limits;
      - removing the first value:
        - returning the removed value:
          - returning a specified default value if no values;
  - 2D oscillogram:
    - extending the 2D plot model;
    - kinds:
      - custom (adding a specific new value);
      - linear (adding a new value with a specific shift from the last value);
      - random (adding a new value with a random shift from the last value);
    - operations:
      - updating:
        - first step: adding a new value;
        - second step: removing the first value;
  - 2D plot/oscillogram iterator:
    - storing:
      - 2D plot/oscillogram;
      - transformer for iterated values;
    - iterating over values of 2D plot/oscillogram:
      - via the `__ipairs` metamethod (for Lua 5.2);
      - via the `__index` metamethod (for Lua 5.3+);
    - applying transformations to iterated values via a specified transformer;
  - factory of a 2D plot/oscillogram iterator:
    - storing:
      - transformer for iterated values;
    - generating a 2D plot/oscillogram iterator for a specific 2D plot/oscillogram.

## [v1.0](https://github.com/thewizardplusplus/luaplot/tree/v1.0) (2020-12-23)

Major version.

### Features

- models:
  - 2D plot:
    - storing:
      - values of a displayed function;
      - limits for these values;
    - operations:
      - initializing:
        - filling a specified count of values by a bottom limit;
      - iterating over values:
        - via the `__ipairs` metamethod (for Lua 5.2);
        - via the `__index` metamethod (for Lua 5.3+);
      - adding a new value:
        - specific;
        - with a shift from the last value:
          - with a specific shift;
          - with a random shift;
          - using a bottom limit as the last value if no values;
        - clamping the added value to specified limits;
      - removing the first value:
        - returning the removed value:
          - returning a bottom limit if no values.
