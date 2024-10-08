#' Accumulate kpilists into KPIs per site lists
#' The KPIs themselves are all well and good for e.g. a report where you walk
#' through each individual KPI and present all of the info there, but they're
#' not ideal if you want all of the KPIs for a given site or country or the
#' overall study in a single table. \code{kpi_accumulate} does this conversion
#' @param kpilist list of KPIs
#' @param by which \code{by} variable from the \code{kpi} call to accumulate
#' @param split logical. Whether to split the output by the levels of the
#'   \code{by} variable(s)
#' @importFrom purrr map2
#' @importFrom dplyr bind_rows
#' @export
#' @examples
#' kpi1 <- mtcars %>%
#'   kpi(var = "mpg", by = c("am", "cyl"), txt = "MPG",
#'       kpi_fn = kpi_fn_median, breakpoints = c(0, 20, 30, 50))
#' kpi2 <- mtcars %>%
#'   kpi(var = "drat", by = c("am", "cyl"), txt = "DRAT",
#'       kpi_fn = kpi_fn_median, breakpoints = c(0, 3, 4, 50))
#' l <- c(kpi1, kpi2)
#' kpi3 <- mtcars %>%
#'   mutate(cylgt4 = cyl > 4) %>%
#'   kpi(var = "cylgt4", by = c("am", "cyl"), txt = "Cylinders",
#'       kpi_fn = kpi_fn_perc, , breakpoints = c(0, 30, 50, 100))
#' l2 <- c(l, kpi3)
#' kpi_accumulate(l2)
#' # only the cyl level
#' kpi_accumulate(l2, by = "cyl")
#' # only the study/overall level
#' kpi_accumulate(l2, by = "overall")
#' # no splitting
#' kpi_accumulate(l2, split = FALSE)
# kpilist <- l2
kpi_accumulate <- function(kpilist, by = NULL, split = TRUE){

  # if(length(by) > 1) stop("'single'")
  bys <- sapply(kpilist, names) %>%
    as.character() %>%
    unique()
  if(!is.null(by)){
    if(!by %in% bys) stop("'by' not recognised as a 'by' variable used to create the kpis")
  }

  bys <- bys[-which(bys == "settings")]

  lists <- vector(mode = "list", length = length(bys))
  names(lists) <- bys
  for(i in bys){
    lists[[i]] <- lapply(kpilist, function(x){
      x[[i]]$calc
    }) %>%
      bind_rows
  }

  lists2 <- map2(lists, bys, function(x, y){
    if(y == "overall"){
      out <- x
    } else {
      if(!split) out <- x
      if(split) out <- split(x, x[[y]])
    }
    out
  })

  if(!is.null(by)){
    lists2 <- lists2[[by]]
  }

  class(lists2) <- c("kpi_accumulate", class(lists2))
  return(lists2)
}


