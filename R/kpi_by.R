
kpi_by <- function(data
                   , var = var
                   , by = NULL
                   , kpi_fn = kpi_fn_mean
                   , txt = ""
                   , n_iqr = 2
                   , breakpoints = NULL
                   , risklabels = NULL
                   , riskcolors = NULL
                   , direction = c("increasing", "decreasing")
                   , raw_cut = FALSE
){

  # print(by)
  out <- list()
  out$calc <- kpi_calc(data,
                       var = var,
                       by = by,
                       kpi_fn = kpi_fn,
                       txt = txt
  )

  if(!is.null(by)) out$outlier <- kpi_outlier(out$calc, n_iqr)

  if (!is.null(breakpoints)) {
    out$calc <- kpi_cut(out$calc
                        , breakpoints = breakpoints
                        , risklabels = risklabels
                        , riskcolors = riskcolors
                        , direction = direction
                        , raw_cut = raw_cut
    )
  }

  out

}


