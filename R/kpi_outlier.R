#' Get the outliers
#'
#' @param kpitab result from calc_kpi
#' @param n_iqr number of IQRs below/above the lower/upper quartiles that should be considered outliers
#'
#' @return \code{kpitab} with just the outliers
#'
#' @examples
#' # data(mtcars)
#' # mtcars %>%
#' #   kpi_calc("mpg", by = "am", kpi_fn = kpi_fn_median) %>%
#' #   kpi_outlier()
kpi_outlier <- function(kpitab, n_iqr = 2){
  kpitab %>%
    mutate(outlier = outlier(.data$stat, n_iqr)) %>%
    filter(outlier) %>%
    select(-outlier)
}

# function for identifying outliers
outlier <- function(x, n_iqr = 2){
  med <- median(x, na.rm = TRUE)
  quart <- quantile(x, c(.25, .75), na.rm = TRUE)
  iqr <- quart[2] - quart[1]
  limits <- quart + c(-n_iqr, n_iqr) * iqr
  out <- x < limits[1] | x > limits[2]
  return(out)
}

