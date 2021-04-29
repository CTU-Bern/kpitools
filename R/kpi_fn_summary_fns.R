#' KPI summary functions
#'
#' These functions are not intended to be run as they are. They are intended to
#' be passed as arguments to the \code{kpi} or \code{calc_kpi} functions.
#'
#' @param .data data frame
#'
#' @return
#' @export
#'
#' @rdname kpi_fn_
#' @importFrom dplyr n
#' @importFrom stats IQR median quantile
kpi_fn_n <- function(.data){
  if (!is.logical(.data$var) | any(.data$var > 1)) warning("'kpi_fn_n' takes a sum of 'var'. It is intended for 0/1 or logical variables")

  .data %>%
    summarize(stat = sum(.data$var, na.rm = TRUE),
              N = n())
}

#' @rdname kpi_fn_
#' @name Proportions
#' @export
kpi_fn_prop <- function(.data){
  if (!is.logical(.data$var) | any(.data$var > 1)) warning("'kpi_fn_prop' takes a sum of 'var'. It is intended for 0/1 or logical variables")

  .data %>%
    summarize(n = sum(.data$var, na.rm = TRUE),
              N = n()) %>%
    mutate(stat = n/.data$N)
}

#' @rdname kpi_fn_
#' @name Percentages
#' @export
kpi_fn_perc <- function(.data){
  if (!is.logical(.data$var) | any(.data$var > 1)) warning("'kpi_fn_perc' takes a sum of 'var'. It is intended for 0/1 or logical variables")

  .data %>%
    summarize(n = sum(.data$var, na.rm = TRUE),
              N = n()) %>%
    mutate(stat = n/.data$N*100)
}

#' @rdname kpi_fn_
#' @name Median
#' @export
kpi_fn_median <- function(.data){
  .data %>%
    summarize(stat = median(.data$var, na.rm = TRUE),
              N = n())
}

#' @rdname kpi_fn_
#' @name Mean
#' @export
kpi_fn_mean <- function(.data){
  .data %>%
    summarize(stat = mean(.data$var, na.rm = TRUE),
              N = n())
}

#' @rdname kpi_fn_
#' @name IQR
#' @export
kpi_fn_iqr <- function(.data){
  .data %>%
    summarize(stat = IQR(.data$var, na.rm = TRUE),
              N = n())
}

#' @rdname kpi_fn_
#' @name Minimum
#' @export
kpi_fn_min <- function(.data){
  .data %>%
    summarize(stat = min(.data$var, na.rm = TRUE),
              N = n())
}

#' @rdname kpi_fn_
#' @name Maximum
#' @export
kpi_fn_max <- function(.data){
  .data %>%
    summarize(stat = max(.data$var, na.rm = TRUE),
              N = n())
}
