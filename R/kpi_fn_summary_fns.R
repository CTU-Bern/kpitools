#' KPI summary functions
#'
#' @param .data data frame
#'
#' @return
#' @export
#'
#' @examples
#' @rdname kpi_fn_
kpi_fn_n <- function(.data){
  .data %>%
    summarize(stat = sum(var, na.rm = TRUE),
              N = n())
}

#' @rdname kpi_fn_
#' @name Proportions
#' @export
kpi_fn_prop <- function(.data){
  .data %>%
    summarize(n = sum(var, na.rm = TRUE),
              N = n()) %>%
    mutate(stat = n/N)
}

#' @rdname kpi_fn_
#' @name Percentages
#' @export
kpi_fn_perc <- function(.data){
  .data %>%
    summarize(n = sum(var, na.rm = TRUE),
              N = n()) %>%
    mutate(stat = n/N*100)
}

#' @rdname kpi_fn_
#' @name Median
#' @export
kpi_fn_median <- function(.data){
  .data %>%
    summarize(stat = median(var, na.rm = TRUE),
              N = n())
}

#' @rdname kpi_fn_
#' @name Mean
#' @export
kpi_fn_mean <- function(.data){
  .data %>%
    summarize(stat = mean(var, na.rm = TRUE),
              N = n())
}

#' @rdname kpi_fn_
#' @name IQR
#' @export
kpi_fn_iqr <- function(.data){
  .data %>%
    summarize(stat = IQR(var, na.rm = TRUE),
              N = n())
}

#' @rdname kpi_fn_
#' @name Minimum
#' @export
kpi_fn_min <- function(.data){
  .data %>%
    summarize(stat = min(var, na.rm = TRUE),
              N = n())
}

#' @rdname kpi_fn_
#' @name Maximum
#' @export
kpi_fn_max <- function(.data){
  .data %>%
    summarize(stat = max(var, na.rm = TRUE),
              N = n())
}
