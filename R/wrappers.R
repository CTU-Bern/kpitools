# wrappers


wrap1 <- function(data,
                  var,
                  by = NULL,
                  kpi_fn = kpi_fn_mean,
                  txt = "",
                  cutpoints = NULL,
                  cutlabels = NULL){

  out <- list()
  out$calc <- calc_kpi(data,
                       var,
                       by,
                       kpi_fn,
                       txt
                       )

  out$outlier <- kpi_outlier(out$calc)

  if (!is.null(cutpoints)) {
    out$calc <- kpi_cut(out$calc,
                        cutpoints,
                        cutlabels)
  }

  out


}




wrap <- function(data,
                 var,
                 by = NULL,
                 cutpoints = NULL,
                 cutlabels = NULL
                 ){


  out <- list()
  out$calc <- calc_kpi(data,
                       var,
                       kpi_fn = kpi_fn_mean
                       )

  out$outlier <- kpi_outlier(out$calc)




  if (!is.null(by)){

    for (byi in by){
      out[[paste0("calc_", byi)]] <- calc_kpi(data,
                                             var,
                                             by = byi,
                                             kpi_fn = kpi_fn_mean)

      out[[paste0("outlier_", byi)]] <- kpi_outlier(out[[paste0("calc_", byi)]])


    }

  }

  out

}



# mtcars %>%
#   mutate(cylgt4 = cyl > 4) %>%
#   # wrap1(var = "mpg", by = c("am")) %>%
#   # wrap1(var = "mpg", by = c("am"), cutpoints = c(0, 22, 50)) %>%
#   wrap1(var = "mpg", cutpoints = c(0, 22, 50), txt = "MPG") %>%
#   boomer::boom()


