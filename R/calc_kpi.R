#' Calculate KPIs
#'
#' @param data dataframe containing \code{var} and, optionally, \code{by}
#' @param var string, variable to calculate KPI from
#' @param by a stratifying variable, KPIs calculated for each strata seperately
#' @param kpi_fn summary function
#' @param txt textual description of the KPI
#'
#' @return a data frame of class \code{kpicalc}
#'
#' @importFrom dplyr is_grouped_df select rename group_by filter any_of
#' @importFrom rlang :=
#' @examples
#' # data(mtcars)
#' # mtcars %>% calc_kpi("mpg", by = "am", kpi_fn = kpi_fn_median)
calc_kpi <- function(data,
                     var,
                     by = NULL,
                     kpi_fn,
                     txt = ""){

  if (is_grouped_df(data)) warning("'data' is already grouped... check results carefully")

  tmp <- data %>%
    select(any_of(c(var, by))) %>%
    rename(var = !!var)

  if(!is.null(by)) {
    tmp <- rename(tmp, by = !!by) %>%
      group_by(by)
  }

  out <- tmp %>%
    kpi_fn %>%
    mutate(txt = txt
           , .before = 1 # experimental option!
           )

  if(!is.null(by)) {
    out <- rename(out, !!by := by)
  }

  class(out) <- c("kpicalc", class(out))

  out
}

# could also be internal...


