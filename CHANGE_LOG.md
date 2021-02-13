# Change Log

## [v1.2.1](https://github.com/thewizardplusplus/luaplot/tree/v1.2.1) (2021-02-13)

- describing for releases:
  - features;
  - change log.

## [v1.2](https://github.com/thewizardplusplus/luaplot/tree/v1.2) (2021-01-10)

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
