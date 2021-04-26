<!-- README.md is generated from README.Rmd. Please edit that file -->

kpitools
========

Tools for creating KPI reports.

Example usage

    library(kpitools)

KPI for the whole study

    data(mtcars)

    mtcars$highmpg <- mtcars$mpg > 20

    mtcars %>%
      kpi(var = "highmpg", 
          kpi_fn = kpi_fn_perc, 
          txt = "Percentage MPG > 25")

    ## $overall
    ## $overall$calc
    ##                   txt  n  N  stat
    ## 1 Percentage MPG > 25 14 32 43.75
    ## 
    ## $overall$outlier
    ## [1] txt  n    N    stat
    ## <0 rows> (or 0-length row.names)

KPI for groups

    mtcars %>%
      kpi(var = "highmpg", 
          kpi_fn = kpi_fn_perc, 
          txt = "Percentage MPG > 20",
          by = "am")

    ## $overall
    ## $overall$calc
    ##                   txt  n  N  stat
    ## 1 Percentage MPG > 20 14 32 43.75
    ## 
    ## $overall$outlier
    ## [1] txt  n    N    stat
    ## <0 rows> (or 0-length row.names)
    ## 
    ## 
    ## $am
    ## $am$calc
    ## # A tibble: 2 x 5
    ##   txt                    am     n     N  stat
    ##   <chr>               <dbl> <int> <int> <dbl>
    ## 1 Percentage MPG > 20     0     4    19  21.1
    ## 2 Percentage MPG > 20     1    10    13  76.9
    ## 
    ## $am$outlier
    ## # A tibble: 0 x 5
    ## # … with 5 variables: txt <chr>, am <dbl>, n <int>, N <int>, stat <dbl>

KPI over multiple groups

    mtcars %>%
      kpi(var = "highmpg", 
          kpi_fn = kpi_fn_perc, 
          txt = "Percentage MPG > 20",
          by = c("am", "gear"))

    ## $overall
    ## $overall$calc
    ##                   txt  n  N  stat
    ## 1 Percentage MPG > 20 14 32 43.75
    ## 
    ## $overall$outlier
    ## [1] txt  n    N    stat
    ## <0 rows> (or 0-length row.names)
    ## 
    ## 
    ## $am
    ## $am$calc
    ## # A tibble: 2 x 5
    ##   txt                    am     n     N  stat
    ##   <chr>               <dbl> <int> <int> <dbl>
    ## 1 Percentage MPG > 20     0     4    19  21.1
    ## 2 Percentage MPG > 20     1    10    13  76.9
    ## 
    ## $am$outlier
    ## # A tibble: 0 x 5
    ## # … with 5 variables: txt <chr>, am <dbl>, n <int>, N <int>, stat <dbl>
    ## 
    ## 
    ## $gear
    ## $gear$calc
    ## # A tibble: 3 x 5
    ##   txt                  gear     n     N  stat
    ##   <chr>               <dbl> <int> <int> <dbl>
    ## 1 Percentage MPG > 20     3     2    15  13.3
    ## 2 Percentage MPG > 20     4    10    12  83.3
    ## 3 Percentage MPG > 20     5     2     5  40  
    ## 
    ## $gear$outlier
    ## # A tibble: 0 x 5
    ## # … with 5 variables: txt <chr>, gear <dbl>, n <int>, N <int>, stat <dbl>

Add in cutoffs for quality without labels

    mtcars %>%
      kpi(var = "highmpg", 
          kpi_fn = kpi_fn_perc, 
          txt = "Percentage MPG > 20",
          by = "am",
          cutpoints = c(0,33.3,66.6,100))

    ## $overall
    ## $overall$calc
    ##                   txt  n  N  stat         cut
    ## 1 Percentage MPG > 20 14 32 43.75 (33.3,66.6]
    ## 
    ## $overall$outlier
    ## [1] txt  n    N    stat
    ## <0 rows> (or 0-length row.names)
    ## 
    ## 
    ## $am
    ## $am$calc
    ## # A tibble: 2 x 6
    ##   txt                    am     n     N  stat cut       
    ##   <chr>               <dbl> <int> <int> <dbl> <fct>     
    ## 1 Percentage MPG > 20     0     4    19  21.1 (0,33.3]  
    ## 2 Percentage MPG > 20     1    10    13  76.9 (66.6,100]
    ## 
    ## $am$outlier
    ## # A tibble: 0 x 5
    ## # … with 5 variables: txt <chr>, am <dbl>, n <int>, N <int>, stat <dbl>

Add in cutoffs for quality with labels

    mtcars %>%
      kpi(var = "highmpg", 
          kpi_fn = kpi_fn_perc, 
          txt = "Percentage MPG > 20",
          by = "am",
          cutpoints = c(0,33.3,66.6,100),
          cutlabels = c("Low", "Medium", "High"))

    ## $overall
    ## $overall$calc
    ##                   txt  n  N  stat         cut cutgrp
    ## 1 Percentage MPG > 20 14 32 43.75 (33.3,66.6] Medium
    ## 
    ## $overall$outlier
    ## [1] txt  n    N    stat
    ## <0 rows> (or 0-length row.names)
    ## 
    ## 
    ## $am
    ## $am$calc
    ## # A tibble: 2 x 7
    ##   txt                    am     n     N  stat cut        cutgrp
    ##   <chr>               <dbl> <int> <int> <dbl> <fct>      <fct> 
    ## 1 Percentage MPG > 20     0     4    19  21.1 (0,33.3]   Low   
    ## 2 Percentage MPG > 20     1    10    13  76.9 (66.6,100] High  
    ## 
    ## $am$outlier
    ## # A tibble: 0 x 5
    ## # … with 5 variables: txt <chr>, am <dbl>, n <int>, N <int>, stat <dbl>
