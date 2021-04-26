
## for N ----
kpi_fn_n <- function(.data){
  .data %>%
    summarize(stat = sum(var, na.rm = TRUE),
              N = n())
}

## for proportions ----
kpi_fn_prop <- function(.data){
  .data %>%
    summarize(n = sum(var, na.rm = TRUE),
              N = n()) %>%
    mutate(stat = n/N)
}

## for percentages ----
kpi_fn_prop <- function(.data){
  .data %>%
    summarize(n = sum(var, na.rm = TRUE),
              N = n()) %>%
    mutate(stat = n/N*100)
}

## for medians ----
kpi_fn_median <- function(.data){
  .data %>%
    summarize(stat = median(var, na.rm = TRUE),
              N = n())
}

## for means ----
kpi_fn_mean <- function(.data){
  .data %>%
    summarize(stat = mean(var, na.rm = TRUE),
              N = n())
}

## for iqr ----
kpi_fn_iqr <- function(.data){
  .data %>%
    summarize(stat = IQR(var, na.rm = TRUE),
              N = n())
}

## for min ----
kpi_fn_min <- function(.data){
  .data %>%
    summarize(stat = min(var, na.rm = TRUE),
              N = n())
}

## for max ----
kpi_fn_max <- function(.data){
  .data %>%
    summarize(stat = max(var, na.rm = TRUE),
              N = n())
}
