#' Plot KPI objects
#'
#' @param kpi result from kpi
#' @param col colour for points
#' @param pch point character
#'
#' @return list of ggplot objects
#' @export
#'
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
plot.kpi <- function(kpi, col = "#E6002EFF", pch = 21){

  w <- names(kpi)[!names(kpi) %in% "overall"]

  if(length(w) == 0) warning("plots only created with the by option")

  kpi2 <- kpi[w]

  plots <- lapply(kpi2, function(x){
    y <- ggplot(x$calc, aes(x = stat, y = 1, size = N)) +
      geom_point(pch = 21, col = col) +
      xlab(unique(x$calc$txt))
    y
  })

  return(plots)

}



