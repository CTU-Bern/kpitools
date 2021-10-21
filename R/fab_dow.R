#' Day of week figure(s)
#'
#' In a normal setting it may be that observations that occur at the weekend are
#' indicative of data fabrication. \code{fab_dow} (short for fabrication, day of
#' week), produces a plot that may help to identify problems. Customs vary in
#' different countries, so that should be accounted for when interpreting these
#' figures.
#'
#' @param data cdata frame containing \code{var} (and, optionally, \code{by}) variable(s)
#' @param var string. Name of variable containing relevant dates or datetimes
#'   (will be coerced to date via \code{as.Date})
#' @param by  string. Name of variable denoting grouping
#' @param dow_fmt format for day of week
#' @param output output format \code{facet} combines figures via ggplot2::facet_wrap,
#'   \code{list} returns a list of ggplot2 plots
#' @param col colour to use for bar lines
#' @param fill colour to use for bar fill
#' @param ... options passed to facet_wrap (see examples)
#'
#' @return list or ggplot2 object
#' @importFrom purrr map
#' @export
#'
#' @examples
#' set.seed(234)
#' dat <- data.frame(
#'   x = Sys.Date() + sample(-20:19, 40, TRUE),
#'   by = c(rep(1, 10), rep(2, 30))
#' )
#' dat %>% fab_dow("x")
#' dat %>% fab_dow("x", "by")
#' # free x scale
#' dat %>% fab_dow("x", "by", scales = "free_x")
#' # different colour bars
#' dat %>% fab_dow("x", fill = "orange")
#' # list of plots
#' dat %>% fab_dow("x", "by", output = "list")
#' # change colours
#' dat %>% fab_dow("x", col = "purple", fill = "pink")
#'

fab_dow <- function(data,
                    var,
                    by = NULL,
                    dow_fmt = "%a",
                    output = c("facet", "list"),
                    col = "grey",
                    fill = "grey",
                    ...){

  if(!is.character(var) | length(var) > 1) stop("'var' should be character of length 1")
  if(!is.null(by) && (!is.character(by) | length(by) > 1)) stop("'by' should be character of length 1")
  output <- match.arg(output)

  tmp <- data %>%
    mutate(x2 = as.Date(!!sym(var)))

  if (sum(is.na(tmp$x2)) > sum(is.na(data[, var]))) warning("NAs introduced when coercing x to date")
  if (all(is.na(tmp$x2))) stop("x should be coercible to date via as.Date(x)")

  if(is.null(by)){
    tmp <- tmp %>%
      mutate(by = "Overall")
  } else {
    tmp <- tmp %>%
      rename(by = !!sym(by))
  }

  dat <- tmp %>%
    rename(date = !!sym(var)) %>%
    mutate(dow = as.numeric(format(.data$date, format = "%u")),
           dow = factor(dow, 7:1, rev(format(as.Date("2021-04-12") + 0:6, dow_fmt))))

  fn <- function(dat, col, fill){
    dat %>%
      filter(!is.na(dow)) %>%
      ggplot(aes(x = dow)) +
      geom_bar(show.legend = FALSE, col = col, fill = fill) +
      scale_fill_discrete(drop = FALSE) +
      scale_x_discrete(drop = FALSE) +
      coord_flip() +
      xlab("Day of week") +
      ylab("Count")
  }

  if(length(unique(dat$by)) > 1){
    if(output == "facet"){
      out <- fn(dat, col, fill) +
        facet_wrap(~ by, ...)
    }
    if(output == "list"){
      dat <- split(dat, dat$by)
      out <- map(dat, fn, col = col, fill = fill)
    }
  } else {
    out <- fn(dat, col, fill)
  }

  return(out)
}

