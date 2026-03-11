# Create KPI tables

Create KPI tables

## Usage

``` r
kpi(
  data,
  var,
  by = NULL,
  kpi_fn = kpi_fn_mean,
  txt = "",
  n_iqr = 2,
  breakpoints = NULL,
  risklabels = risklabs(breakpoints),
  riskcolors = riskcols(breakpoints),
  direction = c("increasing", "decreasing"),
  raw_cut = FALSE,
  keep_data = FALSE
)
```

## Arguments

- data:

  a data frame

- var:

  the variable to summarize

- by:

  optional variable(s) to group over

- kpi_fn:

  summary function

- txt:

  a descriptive text

- n_iqr:

  number of IQRs below/above the lower/upper quartiles that should be
  considered outliers

- breakpoints:

  cut points (if KPIs use a traffic light system)

- risklabels:

  labels for the cut points. By default, variations on low/moderate/high
  are used

- riskcolors:

  colors for the cut points. By default, variations on green/yellow/red
  are used

- direction:

  seriousness relative to `breakpoints`

- raw_cut:

  add a group variable without applying `risklabels`

- keep_data:

  keep raw data or not

## Value

a list with either 1 or (length(by) + 1) lists.

## Examples

``` r
kpi_test <- mtcars %>%
  mutate(cylgt4 = cyl > 4) %>%
  kpi(var = "mpg",
      breakpoints = c(0, 22, 50),
      by = c("am", "cyl"),
      txt = "MPG",
      kpi_fn = kpi_fn_median)
```
