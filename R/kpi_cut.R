#' Cut KPI indicators
#'
#' @param kpitab output from calc_kpi
#' @param cutpoints cut points (if KPIs use a traffic light system)
#' @param cutlabels labels for the cut points
#'
#' @return
#' @importFrom magrittr '%>%'
#' @importFrom dplyr mutate summarize n
#' @importFrom rlang .data
#'
#' @examples
#' # kpitab <- mtcars %>% calc_kpi("mpg", by = "am", kpi_fn = kpi_fn_median, txt = "MPG")
#' # cutpoints <- c(0, 20, 30)
#' # kpi_cut(kpitab, cutpoints, cutlabels = c("Low", "High"))
#' # kpi_cut(kpitab, cutpoints, cutlabels = 1:2)
#' # kpi_cut(kpitab, cutpoints)

kpi_cut <- function(kpitab, cutpoints, cutlabels = NULL){

  if(!is.null(cutlabels)){
    if(length(cutlabels) != (length(cutpoints) - 1)) stop("cutlabels should have one less value than cutpoints")
  }

  out <- kpitab %>%
    mutate(cut = cut(.data$stat
                     , breaks = cutpoints
                     # , labels = cutlabels
                     )
           )
  if (!is.null(cutlabels)){
    out <- out %>% mutate(
      cutgrp = cut(.data$stat
                   , breaks = cutpoints
                   , labels = cutlabels
      )
    )
  }

  out

}



