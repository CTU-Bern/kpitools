# Labels for KPIs with cutoffs

Labels for KPIs with cutoffs

## Usage

``` r
risklabs(x)
```

## Arguments

- x:

  breakpoints

## Value

string of `length(x) - 1` with suitable labels.

## Examples

``` r
risklabs(1:4)
#> [1] "low"      "moderate" "high"    
```
