# Concatenate `kpi` objects

Concatenate `kpi` objects

## Usage

``` r
# S3 method for class 'kpi'
c(...)
```

## Arguments

- ...:

  `kpi` or `kpilist` objects

## Value

`kpilist` object

## Examples

``` r
kpi1 <- mtcars %>%
  kpi(var = "mpg", by = c("am", "cyl"), txt = "MPG",
      kpi_fn = kpi_fn_median)
kpi2 <- mtcars %>%
  kpi(var = "drat", by = c("am", "cyl"), txt = "DRAT",
      kpi_fn = kpi_fn_median)
l <- c(kpi1, kpi2)
kpi3 <- mtcars %>%
  mutate(cylgt4 = cyl > 4) %>%
  kpi(var = "cylgt4", by = c("am", "cyl"), txt = "Cylinders",
      kpi_fn = kpi_fn_perc)
l2 <- c(l, kpi3)
```
