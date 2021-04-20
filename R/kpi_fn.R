# main function ----
kpi_fn <- function(data,
                   ref,
                   vars,
                   indicator,
                   fn,
                   previous,
                   measure = "%",
                   debug = FALSE,
                   firsttime = FALSE){

  out <- list()

  tmp <- data %>%
    select(!!vars) %>%
    fn() %>%
    mutate(indicator = indicator)

  if(firsttime){
    tmp <- tmp %>%
      mutate(last_n_s = "", diff_s = "")
  } else {
    tmp <- tmp %>%
      mutate(last_n_s = previous$study$last_n_s[2],
             last_n = as.numeric(last_n_s),
             diff = pn - last_n,
             diff_s = sprintf("%2.0f", diff)
             )
  }
  tmp <- tmp %>%
    relocate(indicator, pn_s, last_n_s, diff_s) %>%
    select(indicator, pn_s, last_n_s, diff_s) %>%
    ungroup() %>%
    add_row(.before = 1) %>%
    as.data.frame()
  tmp$indicator[1] <- "Indicator"
  tmp$pn_s[1] <- measure
  tmp$last_n_s[1] <- "Last value"
  tmp$diff_s[1] <- "Difference"
  out$study <- tmp
  out$study_label <- glue("tab:{ref}")
  out$study_caption <- indicator

  # country
  if(debug) print("C")
  country <- data %>%
    group_by(country_name) %>%
    select(!!vars, country_name) %>%
    fn %>%
    mutate(country = as.character(country_name))

  if(firsttime) {
    country <- country %>%
      mutate(last_n_s = "", diff_s = "")
  } else {
    country <- country %>%
    left_join(previous$country %>%
                filter(1:n() > 1) %>%
                select(country, last_n_s = pn_s),
              by = c("country")) %>%
    mutate(last_n = as.numeric(last_n_s),
           diff = pn - last_n,
           diff_s = sprintf("%2.0f", diff))
  }
  country <- country %>%
    as.data.frame()
  country$indicator <- indicator
  country_outlier <- country %>%
    mutate(outlier = outlier(pn)) %>%
    filter(outlier) %>%
    mutate(country = as.character(country)) %>%
    ungroup() %>%
    add_row(.after = 0) %>%
    as.data.frame()
  if(nrow(country_outlier) == 1){
    country_outlier <- add_row(country_outlier, .after = 0)
    country_outlier$pn_s[2] <- ""
    country_outlier$country[2] <- "None"
  }
  country_outlier$indicator <- c("Indicator", rep(indicator, nrow(country_outlier)-1))
  country_outlier$pn_s[1] <- measure
  country_outlier$country[1] <- "Country"
  country_outlier <- country_outlier[, c("indicator", "country", "pn_s")]

  # ...figure itself
  if(debug) print("C-fig")
  cou <- ggplot(country, aes(x = pn, y = 1)) +
    geom_point(aes(size = N), col = unibeRed(.5), shape = 1) +
    # xlim(0, 100) +
    xlab(indicator) +
    ggtitle("Countries") +
    labs(size="N participants") +
    myggsettings()

  cpath <- here::here(paths("fd", glue("country_{ref}.pdf")))
  pdf(cpath, height = 1.5, width = 5)
  print(cou)
  dev.off()
  # browser()


  # ...latex code for figure ----
  if(debug) print("C-figlatex")
  out$countryfig <- paste0('\\begin{figure}[h]
\\begin{center}
\\includegraphics{', cpath, '}
\\caption{', indicator, ' across countries. See Table \\ref{tab:country_', ref, '} for any outliers.}
\\label{fig:country_', ref, '}
\\end{center}
\\end{figure}
\\FloatBarrier')

  # ...outlier table ----
  if(debug) print("C-outliertable")
  out$country_outlier <- country_outlier
  out$country_outlier_label <- glue("tab:country_{ref}")
  out$country_outlier_caption <- glue("Outliers in |indicator|. See Table \\ref{tab:app_country_|ref|} for full listing by country.", .open = "|", .close = "|")

  # ...appendix table ----
  if(debug) print("C-apptable")
  country <- add_row(country, .before = 1)
  country$country[1] <- "Country"
  country$pn_s[1] <- measure
  country$last_n_s[1] <- "Last value"
  country$diff_s[1] <- "Difference"
  out$country <- country[, c("indicator", "country", "pn_s", "last_n_s", "diff_s")]
  out$country_label <- glue("tab:app_country_{ref}")
  out$country_caption <- glue("Listing of |indicator| by country. See table \\ref{tab:country_|ref|} for outliers.", .open = "|", .close = "|")

  # site ----
  site <- data %>%
    group_by(institute.name) %>%
    select(!!vars, institute.name) %>%
    fn %>%
    mutate(site = as.character(institute.name))
  if(firsttime) {
    site <- site %>%
      mutate(last_n_s = "", diff_s = "")
  } else {
    site <- site %>%
      left_join(previous$site %>%
                  filter(1:n() > 1) %>%
                  select(site, last_n_s = pn_s),
                by = c("institute.name" = "site")) %>%
      mutate(last_n = as.numeric(last_n_s),
             diff = pn - last_n,
             diff_s = sprintf("%2.0f", diff))
  }
  site <- site %>%
    as.data.frame()
  site$indicator <- indicator
  site_outlier <- site %>%
    mutate(outlier = outlier(pn)) %>%
    filter(outlier) %>%
    mutate(site = as.character(site)) %>%
    ungroup() %>%
    add_row(.after = 0) %>%
    as.data.frame()
  if(nrow(site_outlier) == 1){
    site_outlier <- add_row(site_outlier, .after = 0)
    site_outlier$pn_s[2] <- ""
    site_outlier$site[2] <- "None"
  }
  site_outlier$indicator <- c("Indicator", rep(indicator, nrow(site_outlier)-1))
  site_outlier$pn_s[1] <- measure
  site_outlier$site[1] <- "Site"
  site_outlier <- site_outlier[, c("indicator", "site", "pn_s")]

  # for(by in c("country", "site")){
    # print(by)
    # print(ls())
    # tmp <- dat %>%
    #   group_by(!!sym(by)) %>%
    #   select(!!vars, !!by) %>%
    #   fn %>%
    #   as.data.frame()
    # tmp2 <- tmp %>%
    #   mutate(outlier = outlier(pn)) %>%
    #   filter(outlier) %>%
    #   add_row(.after = 0) %>%
    #   as.data.frame()
    # tmp[, by] <- as.character(tmp[, by])
    # tmp2[, by] <- as.character(tmp2[, by])
    # if(nrow(tmp2) == 1){
    #   tmp2 <- add_row(tmp2, .after = 0)
    #   tmp2$pn_s[2] <- ""
    #   tmp2[2, by] <- "None"
    # }
    # tmp2$indicator <- c("Indicator", rep(indicator, nrow(tmp2)-1))
    # tmp$indicator <- indicator
    # tmp2$pn_s[1] <- measure
    # tmp2[1, by] <- ifelse(by == "country", "Country", "Site")
    # tmp2 <- tmp2[, c("indicator", by, "pn_s")]
    #
    # assign(glue("{by}"), tmp)
    # assign(glue("{by}_outlier"), tmp2)
    # print(ls())
  # }
  # browser()

  # ...figure ----
  spath <- here::here(paths("fd", glue("site_{ref}.pdf")))
  sitefig <- ggplot(site, aes(x = pn, y = 1)) +
    geom_point(aes(size = N), col = unibeRed(.5), shape = 1) +
    # xlim(0, 100) +
    xlab(indicator) +
    ggtitle("Sites") +
    labs(size="N participants") +
    myggsettings()

  pdf(spath, height = 1.5, width = 5)
  print(sitefig)
  dev.off()

  out$sitefig <- paste0('\\begin{figure}[h]
\\begin{center}
\\includegraphics{', spath, '}
\\caption{', indicator, ' across sites See Table \\ref{tab:site_', ref, '} for any outliers.}
\\label{fig:site_', ref, '}
\\end{center}
\\end{figure}
\\FloatBarrier')

  # ...outlier table ----
  out$site_outlier <- site_outlier
  out$site_outlier_label <- glue("tab:site_{ref}")
  out$site_outlier_caption <- glue("Outliers in |indicator|. See Table \\ref{tab:app_site_|ref|} for full listing by site.", .open = "|", .close = "|")



  # ...appendix table ----
  if(debug) print("S-apptable")
  site <- add_row(site, .before = 1)
  site$site[1] <- "Site"
  site$pn_s[1] <- measure
  site$last_n_s[1] <- "Last value"
  site$diff_s[1] <- "Difference"

  out$site <- site[, c("indicator", "site", "pn_s", "last_n_s", "diff_s")]
  out$site_label <- glue("tab:app_site_{ref}")
  out$site_caption <- glue("Listing of |indicator| by site. See table \\ref{tab:site_|ref|} for outliers.", .open = "|", .close = "|")

  return(out)

}

# accessory functions ----
# these functions summarize for different types of indicators
## for proportions ----
kpi_fn_prop <- function(.data){
  .data %>%
    summarize(n = sum(!!sym(vars), na.rm = TRUE),
              N = n()) %>%
    mutate(pn = n/N*100,
           pn_s = sprintf("%2.1f", pn)
           # , last_n = round(pn*abs(rnorm(1, .9, .99)))
           # , diff = pn - last_n
           # , last_n_s = sprintf("%2.1f", last_n)
           # , diff_s = sprintf("%2.1f", diff)
    )
}

## for N ----
kpi_fn_n <- function(.data){
  .data %>%
    summarize(n = sum(!!sym(vars), na.rm = TRUE),
              N = n()) %>%
    mutate(pn = n,
           pn_s = sprintf("%2.0f", pn)
           # , last_n = round(pn*abs(rnorm(1, .9, .99)))
           # , diff = pn - last_n
           # , last_n_s = sprintf("%2.0f", last_n)
           # , diff_s = sprintf("%2.0f", diff)
    )
}

## for medians ----
kpi_fn_median <- function(.data){
  .data %>%
    summarize(x = median(!!sym(vars), na.rm = TRUE),
              N = n()) %>%
    mutate(pn = x,
           pn_s = sprintf("%2.0f", pn)
           # , last_n = round(pn*abs(rnorm(1, .9, .99)))
           # , diff = pn - last_n
           # , last_n_s = sprintf("%2.0f", last_n)
           # , diff_s = sprintf("%2.0f", diff)
    )
}

## for iqr ----
kpi_fn_iqr <- function(.data){
  .data %>%
    summarize(x = IQR(!!sym(vars), na.rm = TRUE),
              N = n()) %>%
    mutate(pn = x,
           pn_s = sprintf("%2.0f", pn)
           # , last_n = round(pn*abs(rnorm(1, .9, .99)))
           # , diff = pn - last_n
           # , last_n_s = sprintf("%2.0f", last_n)
           # , diff_s = sprintf("%2.0f", diff)
    )
}

## for max ----
kpi_fn_max <- function(.data){
  .data %>%
    summarize(x = max(!!sym(vars), na.rm = TRUE),
              N = n()) %>%
    mutate(pn = x,
           pn_s = sprintf("%2.0f", pn)
           # , last_n = round(pn*abs(rnorm(1, .9, .99)))
           # , diff = pn - last_n
           # , last_n_s = sprintf("%2.0f", last_n)
           # , diff_s = sprintf("%2.0f", diff)
    )
}

## for min ----
kpi_fn_min <- function(.data){
  .data %>%
    summarize(x = min(!!sym(vars), na.rm = TRUE),
              N = n()) %>%
    mutate(pn = x,
           pn_s = sprintf("%2.0f", pn)
           # , last_n = round(pn*abs(rnorm(1, .9, .99)))
           # , diff = pn - last_n
           # , last_n_s = sprintf("%2.0f", last_n)
           # , diff_s = sprintf("%2.0f", diff)
    )
}


# helper for printing ----
kpi_btable <- function(object, which = "study"){

  caption <- paste(which, "caption", sep = "_")
  label <- paste(which, "label", sep = "_")

  if(which == "study") align <- "p{4cm}p{2cm}p{2cm}p{2cm}"
  if(grepl("outlier", which)) align <- "p{4cm}p{2cm}p{0.5cm}"
  if(!grepl("outlier|study", which)) align <- "p{4cm}p{4cm}p{2cm}p{2cm}p{2cm}"

  btable(object[[which]],
         nhead = 1,
         nfoot = 0,
         caption = object[[caption]],
         label = object[[label]],
         aligntot = align,
         tab.env = "float",
         rephead = NULL)

  cat("\\FloatBarrier")


}

# actually print elements ----
kpi_print_elements <- function(object, appendix = FALSE){

  if(!appendix){
    # study table
    kpi_btable(object, "study")
    # country figure
    cat(object$countryfig)
    # country outliers
    kpi_btable(object, "country_outlier")
    # site figure
    cat(object$sitefig)
    # site outliers
    kpi_btable(object, "site_outlier")
  } else {
    # country listing
    kpi_btable(object, "country")
    # site listing
    kpi_btable(object, "site")
  }

  invisible(NULL)
}

