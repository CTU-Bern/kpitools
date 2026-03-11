# Print method for kpi objects

Print method for kpi objects

## Usage

``` r
# S3 method for class 'kpi'
print(x, table = TRUE, outlier = TRUE, ...)
```

## Arguments

- x:

  kpi object

- table:

  logical, whether to add a table stats by grouping variable(s) to the
  output

- outlier:

  logical, whether to add a table of outliers to the output

- ...:

  not currently used

## Value

output printed to the console

## Examples

``` r
kpi <- mtcars %>%
  mutate(cylgt4 = cyl > 4) %>%
  kpi(var = "mpg", breakpoints = c(0, 22, 50), by = c("am", "cyl"), txt = "MPG",
      kpi_fn = kpi_fn_median)
print(kpi, table = TRUE, outlier = FALSE)
#> Study level:
#>  txt  N n_nonmiss stat risk  cols
#>  MPG 32        32 19.2  low green
#> 
#> Grouped by am:
#>  txt am  N n_nonmiss stat risk  cols
#>  MPG  0 19        19 17.3  low green
#>  MPG  1 13        13 22.8 high   red
#> 
#> 
#> Grouped by cyl:
#>  txt cyl  N n_nonmiss stat risk  cols
#>  MPG   4 11        11 26.0 high   red
#>  MPG   6  7         7 19.7  low green
#>  MPG   8 14        14 15.2  low green
#> 
#> 
```
