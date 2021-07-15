#' Depict KPIs as gauges
#'
#' @param kpi \code{kpi} object
#' @param level which level to depict (e.g. \code{overall}, or one of the \code{by} variables)
#' @param focus if using a \code{by} variable, which 'site' to make the focus
#' @param others logical, depict the other 'sites' (levels of the \code{by} variable)
#' @param others_alpha alpha to use for the \code{others}
#' @param needle_width Width of the needle
#' @param cont_colours for continuous scales, a set of colours to use for the ramp
#'
#' @return \code{ggplot2} object
#'
#' @examples
#' mtcars %>%
#' mutate(cylgt4 = cyl > 4) %>%
#'   kpi(var = "mpg",
#'       breakpoints = c(0, 22, 50),
#'       by = c("am", "cyl"),
#'       txt = "MPG",
#'       kpi_fn = kpi_fn_median) %>%
#'   kpi_gauge("am", 0,
#'             needle_width = .2)
#' mtcars %>%
#'   mutate(cylgt4 = cyl > 4) %>%
#'   kpi(var = "mpg",
#'       by = c("am", "cyl"),
#'       txt = "MPG",
#'       kpi_fn = kpi_fn_median
#'       #, dir = "dec"
#'       ) %>%
#'   kpi_gauge("cyl", 6,
#'             others = TRUE,
#'             needle_width = .5)
kpi_gauge <- function(kpi
                      , level = "overall"
                      , focus = NULL
                      , annot_size = 8
                      , title = TRUE
                      , others = FALSE
                      , others_alpha = .25
                      , needle_width = 1
                      , cont_colours = c("green", "gold", "red")
                      ){

  if(!level %in% names(kpi)[2:length(kpi)])
    stop("level not recognized (use 'overall' or one of the 'by' levels)")

  if(!level == "overall" && !focus %in% kpi[[level]]$calc[[level]])
    stop("focus not recognized as a level of selected level")

  if (level == "overall") {
    val <- kpi$overall$calc$stat
  } else {
      val <- kpi[[level]]$calc %>%
        filter(!!sym(level) == focus) %>%
        select(stat) %>%
        as.numeric()
      other_vals <- kpi[[level]]$calc %>%
        filter(!!sym(level) != focus) %>%
        select(stat)
    }


  g <- ggplot() +
    coord_fixed()

  if(!is.null(kpi$settings$breakpoints)){

    br <- kpi$settings$breakpoints
    start <- br[1:(length(br)-1)]
    end <- br[2:length(br)]
    range <- max(br)-min(br)
    gauge <- pmap(list(start,
              end,
              kpi$settings$riskcolors),
         function(start, end, col){
           geom_polygon(data = get_poly_break(start, end, range = range),
                        aes(x = x, y = y), fill = col)
         }
         )
    g <- g +
      gauge

  } else {

    # normalise

    gauge <- geom_segment(data = get_poly_cont(0, 1),
                 aes(x = x, y = y, xend = xend, yend = yend, col = xend))

    if (kpi$settings$direction == "decreasing") cont_colours <- rev(cont_colours)

    g <- g +
      gauge +
      scale_color_gradientn(colors = cont_colours)

  }

    needle <- geom_polygon(data = get_poly_break(val - needle_width,
                                                 val + needle_width,
                                                 0.2, range = range),
                           aes(x = x, y = y))
    annot <- annotate("text", x = 0, y = 0, label = val, size = annot_size)

  if(others){
    refs <- lapply(other_vals$stat,
                   function(x){
                     geom_polygon(data = get_poly_break(x - needle_width,
                                                        x + needle_width,
                                                        0.2, range = range),
                                  aes(x = x, y = y), alpha = others_alpha)
                     }
                   )

    g <- g + refs
  }

  if(title){
    g <- g + ggtitle(kpi$settings$txt)
  }


  g <- g +
    needle +
    annot +
    guides(colour = guide_none()) +
    theme_void()

  return(g)

}


# helpers ----

norm <- function(x, floor = 0, ceiling = 1){
  ((ceiling - floor) * (x - min(x))) / (max(x) - min(x)) + floor
}

get_poly_break <- function(a, b, r1 = 0.5, r2 = 1.0, range) {
  th.start <- pi*(1-a/range)
  th.end   <- pi*(1-b/range)
  th       <- seq(th.start,th.end,length=100)
  x        <- c(r1*cos(th),rev(r2*cos(th)))
  y        <- c(r1*sin(th),rev(r2*sin(th)))
  return(data.frame(x,y))
}

get_poly_cont <- function(min = 0, max = 1, r1 = 0.5, r2 = 1.0) {
  range <- max - min
  b <- max / max
  a <- min / (max - (max - range))
  th.start <- pi * (1 - a / range)
  th.end   <- pi * (1 - b / range)
  th       <- seq(th.start, th.end, length = 1000)
  x        <- r1 * cos(th)
  xend     <- r2 * cos(th)
  y        <- r1 * sin(th)
  yend     <- r2 * sin(th)
  data.frame(x, y, xend, yend)
}
