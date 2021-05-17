#' Cut KPI indicators
#'
#' @param kpitab output from calc_kpi
#' @param breakpoints cut points (if KPIs use a traffic light system)
#' @param risklabels labels for the cut points. By default, variations on
#' low/moderate/high are used
#' @param direction seriousness relative to \code{breakpoints}
#' @param raw_cut add a group variable without applying \code{risklabels}
#'
#' @return
#' @importFrom magrittr '%>%'
#' @importFrom dplyr mutate summarize n
#' @importFrom rlang .data
#'
#' @examples
#' kpitab <- mtcars %>% calc_kpi("mpg", by = "am", kpi_fn = kpi_fn_median, txt = "MPG")
#' cutpoints <- c(0, 20, 30)
#' kpi_cut(kpitab, cutpoints, risklabels = c("Low", "High"))
#' kpi_cut(kpitab, cutpoints, risklabels = 1:2)
#' kpi_cut(kpitab, cutpoints)

kpi_cut <- function(kpitab
                    , breakpoints
                    , risklabels = risklabs(breakpoints)
                    , direction = c("increasing", "decreasing")
                    , raw_cut = FALSE
                    ){

  direction <- match.arg(direction)

  if(!is.null(risklabels)){
    if(length(risklabels) != (length(breakpoints) - 1)) stop("risklabels should have one less value than cutpoints")
  }

  if(direction == "decreasing") rev(risklabels)

  out <- kpitab %>% mutate(
    risk = cut(.data$stat
               , breaks = breakpoints
               , labels = risklabels
    )
  )

  if(raw_cut){
    out <- out %>%
      mutate(raw_cut = cut(.data$stat
                       , breaks = breakpoints
                       )
             )
  }
  out

}


#' Labels for KPIs with cutoffs
#'
#' @param x breakpoints
#'
#' @return string of \code{length(x) - 1} with suitable labels.
#' @export
#'
#' @examples
#' risklabs(1:4)
risklabs <- function(x){
  if (!is.null(x)){
    if (length(x) > 6) stop("breakpoints must be defined manually for more than 5 groups")

    ops <- list("none",
                c("low", "high"),
                c("low", "moderate", "high"),
                c("very low", "low", "high", "very high"),
                c("very low", "low", "moderate", "high", "very high"))
    ops[[length(x)-1]]
  }
}


