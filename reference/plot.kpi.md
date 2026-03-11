# Plot KPI objects

Plot KPI objects

## Usage

``` r
# S3 method for class 'kpi'
plot(x, y = 1, col = "#E6002EFF", pch = 21, ...)
```

## Arguments

- x:

  result from kpi

- y:

  ignored

- col:

  colour for points

- pch:

  point character

- ...:

  for possible future expansion

## Value

list of ggplot objects

## Examples

``` r
# defaults
kpi <- mtcars %>%
  kpi("mpg", by = c("am", "vs"), txt = "MPG")
plot(kpi)
#> $am

#> 
#> $vs

#> 

# customizing the plots
plots <- plot(kpi)

plots$am +
  theme_bw() +
  labs(title = "Foo")

```
