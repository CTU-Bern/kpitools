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
plot.kpi <- function(x, y, col = "#E6002EFF", pch = 21, ...){
  stat <- N <- NULL # avoid global binding note

  w <- names(x)[!names(x) %in% "overall"]

  if(length(w) == 0) warning("plots only created with the by option")

  x2 <- x[w]

  plots <- lapply(x2, function(x){
    y <- ggplot(x$calc, aes(x = stat, y = 1, size = N)) +
      geom_point(pch = 21, col = col) +
      xlab(unique(x$calc$txt))
    y
  })

  return(plots)

}



