# KPI summary functions

These functions are not intended to be run as they are. They are
intended to be passed as arguments to the `kpi` or `kpi_calc` functions.
They summarize the data in the appropriate manner for the type of KPI.
For example, the `kpi_fn_prop` counts the number of cases and total
number of observations then calculates a proportion. `kpi_fn_median`
simply calculates the median of the observations.

## Usage

``` r
kpi_fn_n(.data)

kpi_fn_prop(.data)

kpi_fn_perc(.data)

kpi_fn_median(.data)

kpi_fn_mean(.data)

kpi_fn_iqr(.data)

kpi_fn_min(.data)

kpi_fn_max(.data)

kpi_fn_missing(.data)
```

## Arguments

- .data:

  data frame

## Details

Functions should accept a dataframe with a `var` variable and return a
dataframe with `stat` (other variables are optional, although an `N`
variable allows for compatibility with downstream functions). All
provided functions return `stat`, `n_nonmiss` and `N`, with some also
returning `n`.

See the examples passing custom functions.

## Examples

``` r
# mean
kpi(mtcars, "mpg", kpi_fn = kpi_fn_mean)
#> Study level:
#>  txt  N n_nonmiss     stat
#>  mpg 32        32 20.09062
#> 
# median
kpi(mtcars, "mpg", kpi_fn = kpi_fn_median)
#> Study level:
#>  txt  N n_nonmiss stat
#>  mpg 32        32 19.2
#> 
# interquartile range
kpi(mtcars, "mpg", kpi_fn = kpi_fn_iqr)
#> Study level:
#>  txt  N n_nonmiss  stat
#>  mpg 32        32 7.375
#> 
# minimum
kpi(mtcars, "mpg", kpi_fn = kpi_fn_min)
#> Study level:
#>  txt  N n_nonmiss stat
#>  mpg 32        32 10.4
#> 
# maximum
kpi(mtcars, "mpg", kpi_fn = kpi_fn_max)
#> Study level:
#>  txt  N n_nonmiss stat
#>  mpg 32        32 33.9
#> 
# proportion
kpi(mtcars, "am", kpi_fn = kpi_fn_prop)
#> Warning: 'kpi_fn_prop' takes a sum of 'var'. It is intended for 0/1 or logical variables
#> Study level:
#>  txt  n  N n_nonmiss    stat
#>   am 13 32        32 0.40625
#> 
# percentage
kpi(mtcars, "am", kpi_fn = kpi_fn_perc)
#> Warning: 'kpi_fn_perc' takes a sum of 'var'. It is intended for 0/1 or logical variables
#> Study level:
#>  txt  n  N n_nonmiss   stat
#>   am 13 32        32 40.625
#> 
# number/sum
kpi(mtcars, "am", kpi_fn = kpi_fn_n)
#> Warning: 'kpi_fn_n' takes a sum of 'var'. It is intended for 0/1 or logical variables
#> Study level:
#>  txt stat  N n_nonmiss
#>   am   13 32        32
#> 



```
