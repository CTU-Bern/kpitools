# Get the outliers

Get the outliers

## Usage

``` r
kpi_outlier(kpitab, n_iqr = 2)
```

## Arguments

- kpitab:

  result from calc_kpi

- n_iqr:

  number of IQRs below/above the lower/upper quartiles that should be
  considered outliers

## Value

`kpitab` with just the outliers

## Examples

``` r
# data(mtcars)
# mtcars %>%
#   kpi_calc("mpg", by = "am", kpi_fn = kpi_fn_median) %>%
#   kpi_outlier()
```
