#' Plot KPI objects
#'
#' @param x result from kpi
#' @param y ignored
#' @param col colour for points
#' @param pch point character
#' @param ... for possible future expansion
#'
#' @return list of ggplot objects
#' @export
#'
#' @importFrom ggplot2 ggplot geom_point xlab aes
#' @examples
#' # defaults
#' kpi <- mtcars %>%
#'   kpi("mpg", by = c("am", "vs"), txt = "MPG")
#' plot(kpi)
#'
#' # customizing the plots
#' plots <- plot(kpi)
#'
#' plots$am +
#'   theme_bw() +
#'   labs(title = "Foo")
#'
plot.kpi <- function(x
                     , y = 1
                     , col = "#E6002EFF"
                     , pch = 21
                     # , geoms
                     ,
                     ...){
  stat <- N <- NULL # avoid global binding note

  w <- names(x)[!names(x) %in% c("settings", "overall")]

  if(length(w) == 0) stop("plots only created with the by option")

  x2 <- as.list(x)[w]

  plots <- lapply(x2, function(l){
    d <- as.data.frame(l$calc)
    d$y <- y
    p <- ggplot(d, aes(x = stat, y = y, size = N)) +
      # geoms +
      geom_point(pch = 21, col = col) +
      xlab(unique(d$txt))
    p
  })

  return(plots)

}


