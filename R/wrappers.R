# wrappers


kpi_by <- function(data,
                   var = var,
                   by = NULL,
                   kpi_fn = kpi_fn_mean,
                   txt = "",
                   cutpoints = NULL,
                   cutlabels = NULL){

  print(by)
  out <- list()
  out$calc <- calc_kpi(data,
                       var = var,
                       by = by,
                       kpi_fn = kpi_fn,
                       txt = txt
                       )

  out$outlier <- kpi_outlier(out$calc)

  if (!is.null(cutpoints)) {
    out$calc <- kpi_cut(out$calc,
                        cutpoints,
                        cutlabels)
  }

  out

}




kpi <- function(data,
                   var,
                   by = NULL,
                   kpi_fn = kpi_fn_mean,
                   txt = "",
                   cutpoints = NULL,
                   cutlabels = NULL
                   ){

  print("start")
  out <- list()
  out$overall <- kpi_by(data
                        , var = var
                        , kpi_fn = kpi_fn
                        , txt = txt
                        , cutpoints = cutpoints
                        , cutlabels = cutlabels
                        )
  print("by")

  if (!is.null(by)){

    for (byi in by){
      print(byi)

      out[[byi]] <- kpi_by(data
                           , var = var
                           , by = byi
                           , kpi_fn = kpi_fn
                           , txt = txt
                           , cutpoints = cutpoints
                           , cutlabels = cutlabels
                           )

    }

  }

  out

}



# mtcars %>%
#   mutate(cylgt4 = cyl > 4) %>%
#   # wrap1(var = "mpg", by = c("am")) %>%
#   # wrap1(var = "mpg", by = c("am"), cutpoints = c(0, 22, 50)) %>%
#   # wrap1(var = "mpg", cutpoints = c(0, 22, 50), txt = "MPG") %>%
#   kpi(var = "mpg", cutpoints = c(0, 22, 50), by = c("am", "cylgt4"), txt = "MPG") %>%
#   # kpi(var = "mpg", cutpoints = c(0, 22, 50), by = "am", txt = "MPG") #%>%
#   # kpi_by(var = "mpg", by = "am", txt = "MPG") %>%
#   # kpi_by(var = "mpg", txt = "MPG") %>%
#   boomer::boom()


