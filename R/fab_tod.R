#' Time of day figure(s)
#'
#' In a normal setting it may be that observations that occur at night are
#' indicative of data fabrication. \code{fab_tod} (short for fabrication, time
#' of day), produces a plot that may help to identify problems. Customs vary in
#' different countries, so that should be accounted for when interpreting these
#' figures.
#'
#' @param data data frame containing \code{var} (and, optionally, \code{by}) variable(s)
#' @param var string. Name of variable containing relevant datetimes
#' @param by  string. Name of variable denoting grouping
#' @param dow_fmt format for day of week
#' @param output output format \code{facet} combines figures via ggplot2::facet_wrap,
#'   \code{list} returns a list of ggplot2 plots
#' @param col_poly colour to use for the region indicating possible fabrication
#' @param x_poly x coordinates for the start and end of the region indicating possible fabrication
#' @param col_bars colour to use for bars indicating counts
#' @details Due to a limitation of faceting plots with polar coordinates, faceted
#' plots all have the same y coordinate (equivalent to fixed axes). To free the
#' coordinate system, use the list output (default) and wrap them together using
#' e.g. patchwork, possibly applying some customizations in advance.
#'
#' @return list or ggplot2 object
#' @importFrom tidyr pivot_wider pivot_longer
#' @importFrom stringr str_sub
#' @importFrom ggplot2 geom_bar scale_fill_discrete scale_x_discrete coord_flip ylab xlab facet_wrap geom_polygon coord_polar element_line
#' @export
#'
#' @examples
#' set.seed(234)
#' dat <- data.frame(
#'   x = lubridate::ymd_h("2020-05-01 14") + 60^2*sample(0:20, 40, TRUE),
#'   by = c(rep(1, 10), rep(2, 30))
#' )
#' dat %>% fab_tod("x")
#' dat %>% fab_tod("x") + theme_kpitools()
#' dat %>% fab_tod("x", "by")
#' #faceted of plots
#' dat %>% fab_tod("x", "by", output = "facet")
#' #with patchwork
#' patchwork::wrap_plots(dat %>% fab_tod("x", "by"))
#'

fab_tod <- function(data,
                    var,
                    by = NULL,
                    dow_fmt = "%a",
                    output = c("list", "facet"),
                    col_poly = "black",
                    x_poly = c(8.5, 21.5),
                    col_bars = "grey"){

  output <- match.arg(output)

  if(!"POSIXt" %in% class(data[, var])) stop("datetime (POSIX) data required")

  if(length(x_poly) != 2) stop("'x_poly' should have length 2")

  tmp <- data %>%
    rename(x = !!sym(var))

  if(is.null(by)){
    tmp <- tmp %>%
      mutate(by = "Overall")
  } else {
    tmp <- tmp %>%
      rename(by = !!sym(by))
  }

  hours <- sprintf("%02.0f00", 0:23)

  dat <- tmp %>%
    mutate(hour = as.numeric(format(.data$x, format = "%H")),
           hour = factor(sprintf("%02.0f00", hour),
                               hours, hours))

  polygon_dat <- dat %>%
    group_by(by) %>%
    count(hour) %>%
    summarize(max = max(n)) %>%
    mutate(x1 = 0.5, x2 = .5, x3 = x_poly[1], x4 = x_poly[1], x5 = x_poly[2], x6 = x_poly[2], x7 = 24.5, x8 = 24.5,
           y1 = 0, y2 = max, y3 = max, y4 = 0, y5 = 0, y6 = max, y7 = max, y8 = 0) %>%
    pivot_longer(cols = starts_with(c("x", "y"))) %>%
    mutate(name2 = str_sub(name, 1, 1), name3 = str_sub(name, 2, 2)) %>%
    pivot_wider(values_from = "value",
                names_from = "name2",
                id_cols = c("by", "name3"))


  fn <- function(dat, polygon_dat){
    dat %>%
      ggplot(aes(x = hour)) +
      geom_polygon(data = polygon_dat,
                   aes(x = x, y = y, group = by),
                   fill = col_poly) +
      geom_bar(show.legend = FALSE, fill = col_bars) +
      xlab("Time of day") +
      ylab("Count") +
      scale_x_discrete(drop = FALSE) +
      coord_polar(theta = "x") +
      theme(panel.grid.major.y = element_line())
  }

  if(length(unique(tmp$by)) > 1){
    if(output == "facet"){
      out <- fn(dat, polygon_dat) +
        facet_wrap(~ by)
    }
    if(output == "list"){
      dat <- split(dat, dat$by)
      polygon_dat <- split(polygon_dat, polygon_dat$by)
      out <- map2(dat, polygon_dat, fn)
    }
  } else {
    out <- fn(dat, polygon_dat)
  }

  return(out)
}

