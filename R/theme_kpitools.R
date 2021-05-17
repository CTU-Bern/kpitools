#' kpitools \code{ggplot2} theme
#'
#' Theme based on \code{theme_bw} and removing y-axis and moving the legend to beneath the plot.
#'
#' @return \code{ggplot2} theme object
#' @export
#' @importFrom ggplot2 theme_bw %+replace% theme element_blank margin
#'
#' @examples
#' kpi <- mtcars %>%
#'   kpi("mpg", by = "cyl", txt = "MPG")
#'
#' # without the theme
#' plot(kpi)$cyl
#' # with the theme
#' plot(kpi)$cyl +
#'   theme_kpitools()
theme_kpitools <- function() {
  theme_bw() %+replace%
    theme(legend.position = "bottom"
          , axis.text.y = element_blank()
          , axis.title.y = element_blank()
          , axis.ticks.y = element_blank()
          , legend.margin = margin(0,0,0,0)
          , panel.grid = element_blank()
          )
}

