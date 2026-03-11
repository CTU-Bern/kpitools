# Accumulate kpilists into KPIs per site lists The KPIs themselves are all well and good for e.g. a report where you walk through each individual KPI and present all of the info there, but they're not ideal if you want all of the KPIs for a given site or country or the overall study in a single table. `kpi_accumulate` does this conversion

Accumulate kpilists into KPIs per site lists The KPIs themselves are all
well and good for e.g. a report where you walk through each individual
KPI and present all of the info there, but they're not ideal if you want
all of the KPIs for a given site or country or the overall study in a
single table. `kpi_accumulate` does this conversion

## Usage

``` r
kpi_accumulate(kpilist, by = NULL, split = TRUE)
```

## Arguments

- kpilist:

  list of KPIs

- by:

  which `by` variable from the `kpi` call to accumulate

- split:

  logical. Whether to split the output by the levels of the `by`
  variable(s)

## Examples

``` r
kpi1 <- mtcars %>%
  kpi(var = "mpg", by = c("am", "cyl"), txt = "MPG",
      kpi_fn = kpi_fn_median, breakpoints = c(0, 20, 30, 50))
kpi2 <- mtcars %>%
  kpi(var = "drat", by = c("am", "cyl"), txt = "DRAT",
      kpi_fn = kpi_fn_median, breakpoints = c(0, 3, 4, 50))
l <- c(kpi1, kpi2)
kpi3 <- mtcars %>%
  mutate(cylgt4 = cyl > 4) %>%
  kpi(var = "cylgt4", by = c("am", "cyl"), txt = "Cylinders",
      kpi_fn = kpi_fn_perc, , breakpoints = c(0, 30, 50, 100))
l2 <- c(l, kpi3)
kpi_accumulate(l2)
#> $overall
#>         txt  N n_nonmiss   stat     risk   cols  n
#> 1       MPG 32        32 19.200      low  green NA
#> 2      DRAT 32        32  3.695 moderate yellow NA
#> 3 Cylinders 32        32 65.625     high    red 21
#> 
#> $am
#> $am$`0`
#> # A tibble: 3 × 8
#>   txt          am     N n_nonmiss  stat risk     cols       n
#>   <chr>     <dbl> <int>     <int> <dbl> <fct>    <fct>  <int>
#> 1 MPG           0    19        19 17.3  low      green     NA
#> 2 DRAT          0    19        19  3.15 moderate yellow    NA
#> 3 Cylinders     0    19        19 84.2  high     red       16
#> 
#> $am$`1`
#> # A tibble: 3 × 8
#>   txt          am     N n_nonmiss  stat risk     cols       n
#>   <chr>     <dbl> <int>     <int> <dbl> <fct>    <fct>  <int>
#> 1 MPG           1    13        13 22.8  moderate yellow    NA
#> 2 DRAT          1    13        13  4.08 high     red       NA
#> 3 Cylinders     1    13        13 38.5  moderate yellow     5
#> 
#> 
#> $cyl
#> $cyl$`4`
#> # A tibble: 3 × 8
#>   txt         cyl     N n_nonmiss  stat risk     cols       n
#>   <chr>     <dbl> <int>     <int> <dbl> <fct>    <fct>  <int>
#> 1 MPG           4    11        11 26    moderate yellow    NA
#> 2 DRAT          4    11        11  4.08 high     red       NA
#> 3 Cylinders     4    11        11  0    NA       NA         0
#> 
#> $cyl$`6`
#> # A tibble: 3 × 8
#>   txt         cyl     N n_nonmiss  stat risk     cols       n
#>   <chr>     <dbl> <int>     <int> <dbl> <fct>    <fct>  <int>
#> 1 MPG           6     7         7  19.7 low      green     NA
#> 2 DRAT          6     7         7   3.9 moderate yellow    NA
#> 3 Cylinders     6     7         7 100   high     red        7
#> 
#> $cyl$`8`
#> # A tibble: 3 × 8
#>   txt         cyl     N n_nonmiss   stat risk     cols       n
#>   <chr>     <dbl> <int>     <int>  <dbl> <fct>    <fct>  <int>
#> 1 MPG           8    14        14  15.2  low      green     NA
#> 2 DRAT          8    14        14   3.12 moderate yellow    NA
#> 3 Cylinders     8    14        14 100    high     red       14
#> 
#> 
#> attr(,"class")
#> [1] "kpi_accumulate" "list"          
# only the cyl level
kpi_accumulate(l2, by = "cyl")
#> $`4`
#> # A tibble: 3 × 8
#>   txt         cyl     N n_nonmiss  stat risk     cols       n
#>   <chr>     <dbl> <int>     <int> <dbl> <fct>    <fct>  <int>
#> 1 MPG           4    11        11 26    moderate yellow    NA
#> 2 DRAT          4    11        11  4.08 high     red       NA
#> 3 Cylinders     4    11        11  0    NA       NA         0
#> 
#> $`6`
#> # A tibble: 3 × 8
#>   txt         cyl     N n_nonmiss  stat risk     cols       n
#>   <chr>     <dbl> <int>     <int> <dbl> <fct>    <fct>  <int>
#> 1 MPG           6     7         7  19.7 low      green     NA
#> 2 DRAT          6     7         7   3.9 moderate yellow    NA
#> 3 Cylinders     6     7         7 100   high     red        7
#> 
#> $`8`
#> # A tibble: 3 × 8
#>   txt         cyl     N n_nonmiss   stat risk     cols       n
#>   <chr>     <dbl> <int>     <int>  <dbl> <fct>    <fct>  <int>
#> 1 MPG           8    14        14  15.2  low      green     NA
#> 2 DRAT          8    14        14   3.12 moderate yellow    NA
#> 3 Cylinders     8    14        14 100    high     red       14
#> 
#> attr(,"class")
#> [1] "kpi_accumulate" "list"          
# only the study/overall level
kpi_accumulate(l2, by = "overall")
#>         txt  N n_nonmiss   stat     risk   cols  n
#> 1       MPG 32        32 19.200      low  green NA
#> 2      DRAT 32        32  3.695 moderate yellow NA
#> 3 Cylinders 32        32 65.625     high    red 21
# no splitting
kpi_accumulate(l2, split = FALSE)
#> $overall
#>         txt  N n_nonmiss   stat     risk   cols  n
#> 1       MPG 32        32 19.200      low  green NA
#> 2      DRAT 32        32  3.695 moderate yellow NA
#> 3 Cylinders 32        32 65.625     high    red 21
#> 
#> $am
#> # A tibble: 6 × 8
#>   txt          am     N n_nonmiss  stat risk     cols       n
#>   <chr>     <dbl> <int>     <int> <dbl> <fct>    <fct>  <int>
#> 1 MPG           0    19        19 17.3  low      green     NA
#> 2 MPG           1    13        13 22.8  moderate yellow    NA
#> 3 DRAT          0    19        19  3.15 moderate yellow    NA
#> 4 DRAT          1    13        13  4.08 high     red       NA
#> 5 Cylinders     0    19        19 84.2  high     red       16
#> 6 Cylinders     1    13        13 38.5  moderate yellow     5
#> 
#> $cyl
#> # A tibble: 9 × 8
#>   txt         cyl     N n_nonmiss   stat risk     cols       n
#>   <chr>     <dbl> <int>     <int>  <dbl> <fct>    <fct>  <int>
#> 1 MPG           4    11        11  26    moderate yellow    NA
#> 2 MPG           6     7         7  19.7  low      green     NA
#> 3 MPG           8    14        14  15.2  low      green     NA
#> 4 DRAT          4    11        11   4.08 high     red       NA
#> 5 DRAT          6     7         7   3.9  moderate yellow    NA
#> 6 DRAT          8    14        14   3.12 moderate yellow    NA
#> 7 Cylinders     4    11        11   0    NA       NA         0
#> 8 Cylinders     6     7         7 100    high     red        7
#> 9 Cylinders     8    14        14 100    high     red       14
#> 
#> attr(,"class")
#> [1] "kpi_accumulate" "list"          
```
