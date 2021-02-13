# Change Log

## [v1.2](https://github.com/thewizardplusplus/luaplot/tree/v1.2) (2021-01-10)

## [v1.1](https://github.com/thewizardplusplus/luaplot/tree/v1.1) (2021-01-03)

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
