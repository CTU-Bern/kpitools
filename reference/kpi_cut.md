# Cut KPI indicators

Cut KPI indicators

## Usage

``` r
kpi_cut(
  kpitab,
  breakpoints,
  risklabels = risklabs(breakpoints),
  riskcolors = riskcols(breakpoints),
  direction = c("increasing", "decreasing"),
  raw_cut = FALSE
)
```

## Arguments

- kpitab:

  output from calc_kpi

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

## Examples

``` r
kpitab <- mtcars %>%
   kpitools:::kpi_calc("mpg", by = "am",
     kpi_fn = kpi_fn_median, txt = "MPG")
cutpoints <- c(0, 20, 30)
kpitools:::kpi_cut(kpitab, cutpoints, risklabels = c("Low", "High"))
#> # A tibble: 2 × 7
#>   txt      am     N n_nonmiss  stat risk  cols 
#>   <chr> <dbl> <int>     <int> <dbl> <fct> <fct>
#> 1 MPG       0    19        19  17.3 Low   green
#> 2 MPG       1    13        13  22.8 High  red  
kpitools:::kpi_cut(kpitab, cutpoints, risklabels = 1:2)
#> # A tibble: 2 × 7
#>   txt      am     N n_nonmiss  stat risk  cols 
#>   <chr> <dbl> <int>     <int> <dbl> <fct> <fct>
#> 1 MPG       0    19        19  17.3 1     green
#> 2 MPG       1    13        13  22.8 2     red  
kpitools:::kpi_cut(kpitab, cutpoints)
#> # A tibble: 2 × 7
#>   txt      am     N n_nonmiss  stat risk  cols 
#>   <chr> <dbl> <int>     <int> <dbl> <fct> <fct>
#> 1 MPG       0    19        19  17.3 low   green
#> 2 MPG       1    13        13  22.8 high  red  
kpitools:::kpi_cut(kpitab, cutpoints, riskcolors = c("pink","blue"), direction="decreasing")
#> # A tibble: 2 × 7
#>   txt      am     N n_nonmiss  stat risk  cols 
#>   <chr> <dbl> <int>     <int> <dbl> <fct> <fct>
#> 1 MPG       0    19        19  17.3 high  pink 
#> 2 MPG       1    13        13  22.8 low   blue 
```
