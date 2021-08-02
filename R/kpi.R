#' Create KPI tables
#' @param data a data frame
#' @param var the variable to summarize
#' @param by optional variable(s) to group over
#' @param kpi_fn summary function
#' @param txt a descriptive text
#' @param keep_data keep raw data or not
#' @inheritParams kpi_cut
#' @inheritParams kpi_outlier
#'
#' @return a list with either 1 or (length(by) + 1) lists.
#' @export
#'
#' @examples
#' kpi_test <- mtcars %>%
#'   mutate(cylgt4 = cyl > 4) %>%
#'   kpi(var = "mpg",
#'       breakpoints = c(0, 22, 50),
#'       by = c("am", "cyl"),
#'       txt = "MPG",
#'       kpi_fn = kpi_fn_median)
kpi <- function(data
                , var
                , by = NULL
                , kpi_fn = kpi_fn_mean
                , txt = ""
                , n_iqr = 2
                , breakpoints = NULL
                , risklabels = risklabs(breakpoints)
                , riskcolors = riskcols(breakpoints)
                , direction = c("increasing", "decreasing")
                , raw_cut = FALSE
                , keep_data = FALSE
                ){

  direction <- match.arg(direction)

  if(txt == "") txt <- var

  kpitype <- as.character(as.list(match.call())$kpi_fn)
  kpitype <- sub("^kpi_fn_", "", kpitype)

  if(keep_data){
    dat <- data.frame(var = data[, var])
    if(!is.null(by)) dat <- cbind(dat, data[, by])
  } else {
    dat <- NULL
  }
  # print("start")
  out <- list(settings = list(var = var
                              , by = by
                              , txt = txt
                              , kpitype = kpitype
                              , breakpoints = breakpoints
                              , risklabels = risklabels
                              , riskcolors = riskcolors
                              , direction = direction
                              , data = dat
                              )
              )
  out$overall <- kpi_by(data
                        , var = var
                        , kpi_fn = kpi_fn
                        , txt = txt
                        , n_iqr = 2
                        , breakpoints = breakpoints
                        , risklabels = risklabels
                        , riskcolors = riskcolors
                        , direction = direction
                        , raw_cut = raw_cut
                        )
  # print("by")

  if (!is.null(by)){

    for (byi in by){
      # print(byi)

      out[[byi]] <- kpi_by(data
                           , var = var
                           , by = byi
                           , kpi_fn = kpi_fn
                           , txt = txt
                           , breakpoints = breakpoints
                           , risklabels = risklabels
                           , riskcolors = riskcolors
                           , direction = direction
                           , raw_cut = raw_cut
                           )

    }

  }


  class(out) <- c("kpi", class(out))

  out

}



# mtcars %>%
#   mutate(cylgt4 = cyl > 4) %>%
#   # wrap1(var = "mpg", by = c("am")) %>%
#   # wrap1(var = "mpg", by = c("am"), cutpoints = c(0, 22, 50)) %>%
#   # wrap1(var = "mpg", cutpoints = c(0, 22, 50), txt = "MPG") %>%
#   # kpi(var = "mpg", cutpoints = c(0, 22, 50), by = c("am", "cylgt4"), txt = "MPG") %>%
#   kpi(var = "mpg", cutpoints = c(0, 22, 50), by = c("am", "cyl"), txt = "MPG") -> kpis
#   # kpi(var = "mpg", cutpoints = c(0, 22, 50), by = "am", txt = "MPG") #%>%
#   # kpi_by(var = "mpg", by = "am", txt = "MPG") %>%
#   # kpi_by(var = "mpg", txt = "MPG") %>%
#   boomer::boom()

kpi_output <- function(kpi
                       , txt = TRUE
                       , plot = TRUE
                       , tabs = TRUE

                       ) {

  if(!"kpi" %in% class(kpi)) stop("'kpi_output' requires object of class 'kpi'")





}
