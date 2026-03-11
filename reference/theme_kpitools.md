# kpitools `ggplot2` theme

Theme based on `theme_bw` and removing y-axis and moving the legend to
beneath the plot.

## Usage

``` r
theme_kpitools()
```

## Value

`ggplot2` theme object

## Examples

``` r
kpi <- mtcars %>%
  kpi("mpg", by = "cyl", txt = "MPG")

# without the theme
plot(kpi)$cyl

# with the theme
plot(kpi)$cyl +
  theme_kpitools()
```
