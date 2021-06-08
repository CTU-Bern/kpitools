#' Convert a kpilist to a set of dataframes for overall numbers and each \code{by} group
#'
#' @param x kpilist
#' @param keep_kpiname each kpi in a \code{kpilist} has a name constructed from
#'   the variable and the summary function. Should this name be retained in the
#'   output?
#' @param ... currently ignored
#'
#' @return list of dataframes
#'
#' @examples
#' kpi1 <- mtcars %>%
#'   kpi(var = "mpg", by = c("am", "cyl"), txt = "MPG",
#'       kpi_fn = kpi_fn_median)
#' kpi2 <- mtcars %>%
#'   kpi(var = "drat", by = c("am", "cyl"), txt = "DRAT",
#'       kpi_fn = kpi_fn_median)
#' kpi3 <- mtcars %>%
#'   mutate(cylgt4 = cyl > 4) %>%
#'   kpi(var = "cylgt4", by = c("am", "cyl"), txt = "Cylinders",
#'       kpi_fn = kpi_fn_perc)
#' l <- c(kpi1, kpi2, kpi3)
#' kpitools:::as_data_frames(l, FALSE)
#'
as_data_frames <- function(x, keep_kpiname = TRUE, ...){

  groups <- names(x[[1]])
  groups <- groups[!grepl("^(settings)$", groups)]

  tabs <- mapply(function(y, name){
    tmp <- y[names(y) %in% groups]
    tmp <- lapply(tmp, function(z){
      tmp2 <- z$calc
      tmp2$kpiname <- name
      tmp2
      })
    tmp
    }
    , x
    , names(x)
    , SIMPLIFY = FALSE
    )

  tabs2 <- list()
  for(i in c("overall", groups)){
    tmp <- lapply(tabs, "[[", i) %>%
      bind_rows()

    if(!keep_kpiname) tmp <- select(tmp, -.data$kpiname)

    tabs2[[i]] <- tmp
  }
  return(tabs2)

}


