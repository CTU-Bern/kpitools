#' Concatenate \code{kpi} objects
#'
#' @param ... \code{kpi}  or \code{kpilist} objects
#'
#' @return \code{kpilist} object
#' @export
#'
#' @examples
#' kpi1 <- mtcars %>%
#'   kpi(var = "mpg", by = c("am", "cyl"), txt = "MPG",
#'       kpi_fn = kpi_fn_median)
#' kpi2 <- mtcars %>%
#'   kpi(var = "drat", by = c("am", "cyl"), txt = "DRAT",
#'       kpi_fn = kpi_fn_median)
#' l <- c(kpi1, kpi2)
#' kpi3 <- mtcars %>%
#'   mutate(cylgt4 = cyl > 4) %>%
#'   kpi(var = "cylgt4", by = c("am", "cyl"), txt = "Cylinders",
#'       kpi_fn = kpi_fn_perc)
#' l2 <- c(l, kpi3)
# args <- list(kpi1, kpi2)
# args <- list(l, kpi3)
#
c.kpi <- function(...){
  args <- list(...)

  classes <- purrr::map(args, class)
  if(!any(purrr::map_lgl(classes, ~ any(. %in% c("kpilist", "kpi"))))) {
    stop("objects should be of class 'kpi' or 'kpilist'")
  }

  out <- list()
  counter <- 1
  for(i in seq_along(args)){
    x <- args[[i]]
    if("kpilist" %in% class(x)){
      for(j in seq_along(x)){
        name <- paste0(x[[j]]$settings$var, "__", x[[j]]$settings$kpitype)
        if(name %in% names(out)) warning("possible duplicate kpi created")
        out[[counter]] <- x[[j]]
        names(out)[counter] <- name
        counter <- counter + 1
      }
    } else {
      name <- paste0(x$settings$var, "__", x$settings$kpitype)
      if(name %in% names(out)) warning("possible duplicate kpi created")
      out[[counter]] <- x
      names(out)[counter] <- name
      counter <- counter + 1
    }
  }

  class(out) <- c("kpilist", "list")
  out
}
#' @export
c.kpilist <- c.kpi



# kpi <- mtcars %>%
#   mutate(cylgt4 = cyl > 4) %>%
#   kpi(var = "mpg", cutpoints = c(0, 22, 50), by = c("am", "cyl"), txt = "MPG",
#       kpi_fn = kpi_fn_median)
# kpi2 <- mtcars %>%
#   mutate(cylgt4 = cyl > 4) %>%
#   kpi(var = "drat", by = c("am", "cyl"), txt = "MPG",
#       kpi_fn = kpi_fn_median)
# l <- c(kpi, kpi2)
