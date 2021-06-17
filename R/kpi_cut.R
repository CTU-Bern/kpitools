#' Cut KPI indicators
#'
#' @param kpitab output from calc_kpi
#' @param breakpoints cut points (if KPIs use a traffic light system)
#' @param risklabels labels for the cut points. By default, variations on
#' low/moderate/high are used
#' @param riskcolors colors for the cut points. By default, variations on
#' green/yellow/red are used
#' @param direction seriousness relative to \code{breakpoints}
#' @param raw_cut add a group variable without applying \code{risklabels}
#'
#' @importFrom magrittr '%>%'
#' @importFrom dplyr mutate summarize n
#' @importFrom rlang .data
#' @keywords internal
#'
#' @examples
#' kpitab <- mtcars %>%
#'    kpitools:::kpi_calc("mpg", by = "am",
#'      kpi_fn = kpi_fn_median, txt = "MPG")
#' cutpoints <- c(0, 20, 30)
#' kpitools:::kpi_cut(kpitab, cutpoints, risklabels = c("Low", "High"))
#' kpitools:::kpi_cut(kpitab, cutpoints, risklabels = 1:2)
#' kpitools:::kpi_cut(kpitab, cutpoints)
#' kpitools:::kpi_cut(kpitab, cutpoints, riskcolors = c("pink","blue"), direction="decreasing")

kpi_cut <- function(kpitab
                    , breakpoints
                    , risklabels = risklabs(breakpoints)
                    , riskcolors = riskcols(breakpoints)
                    , direction = c("increasing", "decreasing")
                    , raw_cut = FALSE
                    ){

  direction <- match.arg(direction)

  if(!is.null(risklabels)){
    if(length(risklabels) != (length(breakpoints) - 1)) stop("risklabels should have one less value than cutpoints")
  }

  if(!is.null(riskcolors)){
    if(length(riskcolors) != (length(breakpoints) - 1)) stop("riskcolors should have one less value than cutpoints")
  }

  if(direction == "decreasing") risklabels <- rev(risklabels)

  out <- kpitab %>% mutate(
    risk = cut(.data$stat
               , breaks = breakpoints
               , labels = risklabels
    ),
    cols = cut(.data$stat
               , breaks = breakpoints
               , labels = riskcolors
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

#' Colors for KPIs cutoffs
#'
#' @param x breakpoints
#'
#' @return string of \code{length(x) - 1} with suitable colors.
#' @export
#'
#' @examples
#' riskcols(1:4)
riskcols <- function(x){
  if (!is.null(x)){
    if (length(x) > 6) stop("breakpoints/colors must be defined manually for more than 5 groups")

    ops <- list("none",
                c("green", "red"),
                c("green", "yellow", "red"),
                c("greend", "yellow", "orange", "red"),
                c("green", "yellow", "orange", "red", "violet"))
    ops[[length(x)-1]]
  }
}


