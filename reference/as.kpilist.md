# Convert a list to a kpilist

Convert a list to a kpilist

## Usage

``` r
as.kpilist(x)
```

## Arguments

- x:

  list of kpi objects

## Value

a kpilist

## Examples

``` r
l <- lapply(c("drat", "hp", "qsec"), function(x){
 kpi(mtcars,
     var = x,
     by = c("am", "cyl"),
     kpi_fn = kpi_fn_median)
})
as.kpilist(l)
#> $drat__median
#> Study level:
#>   txt  N n_nonmiss  stat
#>  drat 32        32 3.695
#> 
#> Grouped by am:
#>   txt am  N n_nonmiss stat
#>  drat  0 19        19 3.15
#>  drat  1 13        13 4.08
#> 
#> No outliers
#> Grouped by cyl:
#>   txt cyl  N n_nonmiss  stat
#>  drat   4 11        11 4.080
#>  drat   6  7         7 3.900
#>  drat   8 14        14 3.115
#> 
#> No outliers
#> 
#> $hp__median
#> Study level:
#>  txt  N n_nonmiss stat
#>   hp 32        32  123
#> 
#> Grouped by am:
#>  txt am  N n_nonmiss stat
#>   hp  0 19        19  175
#>   hp  1 13        13  109
#> 
#> No outliers
#> Grouped by cyl:
#>  txt cyl  N n_nonmiss  stat
#>   hp   4 11        11  91.0
#>   hp   6  7         7 110.0
#>   hp   8 14        14 192.5
#> 
#> No outliers
#> 
#> $qsec__median
#> Study level:
#>   txt  N n_nonmiss  stat
#>  qsec 32        32 17.71
#> 
#> Grouped by am:
#>   txt am  N n_nonmiss  stat
#>  qsec  0 19        19 17.82
#>  qsec  1 13        13 17.02
#> 
#> No outliers
#> Grouped by cyl:
#>   txt cyl  N n_nonmiss   stat
#>  qsec   4 11        11 18.900
#>  qsec   6  7         7 18.300
#>  qsec   8 14        14 17.175
#> 
#> No outliers
#> 
#> attr(,"class")
#> [1] "kpilist" "list"   
```
