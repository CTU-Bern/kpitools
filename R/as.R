#' Convert a list to a kpilist
#'
#' @param x list of kpi objects
#'
#' @return a kpilist
#'
#' @export
#'
#' @examples
#' l <- lapply(c("drat", "hp", "qsec"), function(x){
#'  kpi(mtcars,
#'      var = x,
#'      by = c("am", "cyl"),
#'      kpi_fn = kpi_fn_median)
#' })
#' as.kpilist(l)
#'
as.kpilist <- function(x) {

  out <- x

  names <- map(x, ~ paste0(.x$settings$var, "__", .x$settings$kpitype))

  names(out) <- names

  class(out) <- c("kpilist", class(out))

  return(out)
}
