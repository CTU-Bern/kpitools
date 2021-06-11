#' KPI summary functions
#'
#' These functions are not intended to be run as they are. They are intended to
#' be passed as arguments to the \code{kpi} or \code{kpi_calc} functions. They
#' summarize the data in the appropriate manner for the type of KPI. For example,
#' the \code{kpi_fn_prop} counts the number of cases and total number of observations
#' then calculates a proportion. \code{kpi_fn_median} simply calculates the median
#' of the observations.
#'
#' Functions should accept a dataframe with a \code{var} variable and return a
#' dataframe with \code{stat} (other variables are optional, although an \code{N}
#' variable allows for compatibility with downstream functions). All provided
#' functions return \code{stat}, \code{n_nonmiss} and \code{N}, with some also returning \code{n}.
#'
#' See the examples passing custom functions.
#'
#' @param .data data frame
#'
#' @export
#'
#' @rdname kpi_fn_
#' @importFrom dplyr n
#' @importFrom stats IQR median quantile
#'
#' @examples
#' # mean
#' kpi(mtcars, "mpg", kpi_fn = kpi_fn_mean)
#' # median
#' kpi(mtcars, "mpg", kpi_fn = kpi_fn_median)
#' # interquartile range
#' kpi(mtcars, "mpg", kpi_fn = kpi_fn_iqr)
#' # minimum
#' kpi(mtcars, "mpg", kpi_fn = kpi_fn_min)
#' # maximum
#' kpi(mtcars, "mpg", kpi_fn = kpi_fn_max)
#' # proportion
#' kpi(mtcars, "am", kpi_fn = kpi_fn_prop)
#' # percentage
#' kpi(mtcars, "am", kpi_fn = kpi_fn_perc)
#' # number/sum
#' kpi(mtcars, "am", kpi_fn = kpi_fn_n)
#'
#'
#'
#'
# fn <- function(x){
#   x %>%
#     summarize(stat = var(var))
# }
#
# kpi(mtcars, "mpg", kpi_fn = fn)
#
#
kpi_fn_n <- function(.data){
  if (!is.logical(.data$var) | any(.data$var > 1)) warning("'kpi_fn_n' takes a sum of 'var'. It is intended for 0/1 or logical variables")

  .data %>%
    summarize(stat = sum(.data$var, na.rm = TRUE)
              , N = n()
              , n_nonmiss = sum(!is.na(.data$var))
              )
}

#' @rdname kpi_fn_
#' @name Proportions
#' @export
kpi_fn_prop <- function(.data){
  if (!is.logical(.data$var) | any(.data$var > 1)) warning("'kpi_fn_prop' takes a sum of 'var'. It is intended for 0/1 or logical variables")

  .data %>%
    summarize(n = sum(.data$var, na.rm = TRUE)
              , N = n()
              , n_nonmiss = sum(!is.na(.data$var))
              ) %>%
    mutate(stat = n/.data$N)
}

#' @rdname kpi_fn_
#' @name Percentages
#' @export
kpi_fn_perc <- function(.data){
  if (!is.logical(.data$var) | any(.data$var > 1)) warning("'kpi_fn_perc' takes a sum of 'var'. It is intended for 0/1 or logical variables")

  .data %>%
    summarize(n = sum(.data$var, na.rm = TRUE)
              , N = n()
              , n_nonmiss = sum(!is.na(.data$var))
              ) %>%
    mutate(stat = n/.data$N*100)
}

#' @rdname kpi_fn_
#' @name Median
#' @export
kpi_fn_median <- function(.data){
  .data %>%
    summarize(N = n()
              , n_nonmiss = sum(!is.na(.data$var))
              , stat = median(.data$var, na.rm = TRUE)
              )
}

#' @rdname kpi_fn_
#' @name Mean
#' @export
kpi_fn_mean <- function(.data){
  .data %>%
    summarize(N = n()
              , n_nonmiss = sum(!is.na(.data$var))
              , stat = mean(.data$var, na.rm = TRUE)
              )
}

#' @rdname kpi_fn_
#' @name IQR
#' @export
kpi_fn_iqr <- function(.data){
  .data %>%
    summarize(N = n()
              , n_nonmiss = sum(!is.na(.data$var))
              , stat = IQR(.data$var, na.rm = TRUE)
              )
}

#' @rdname kpi_fn_
#' @name Minimum
#' @export
kpi_fn_min <- function(.data){
  .data %>%
    summarize(N = n()
              , n_nonmiss = sum(!is.na(.data$var))
              , stat = min(.data$var, na.rm = TRUE)
              )
}

#' @rdname kpi_fn_
#' @name Maximum
#' @export
kpi_fn_max <- function(.data){
  .data %>%
    summarize(N = n()
              , n_nonmiss = sum(!is.na(.data$var))
              , stat = max(.data$var, na.rm = TRUE)
              )
}

#' @rdname kpi_fn_
#' @name Missing
#' @export
kpi_fn_missing <- function(.data){

  .data %>%
    summarize(N = n()
      , nm = sum(is.na(.data$var), na.rm=FALSE)
    ) %>%
    mutate(stat = nm/.data$N*100)
}


#' Get a list of KPI summary functions provided by \code{kpitools}.
#'
#' @return character vector of functions
#' @export
#'
#' @seealso kpi_fn_
#' @examples
#' kpi_fns()
kpi_fns <- function(){
  ls("package:kpitools", pattern = "^kpi_fn_")
}
