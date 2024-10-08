% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/c.R
\name{c.kpi}
\alias{c.kpi}
\title{Concatenate \code{kpi} objects}
\usage{
\method{c}{kpi}(...)
}
\arguments{
\item{...}{\code{kpi}  or \code{kpilist} objects}
}
\value{
\code{kpilist} object
}
\description{
Concatenate \code{kpi} objects
}
\examples{
kpi1 <- mtcars \%>\%
  kpi(var = "mpg", by = c("am", "cyl"), txt = "MPG",
      kpi_fn = kpi_fn_median)
kpi2 <- mtcars \%>\%
  kpi(var = "drat", by = c("am", "cyl"), txt = "DRAT",
      kpi_fn = kpi_fn_median)
l <- c(kpi1, kpi2)
kpi3 <- mtcars \%>\%
  mutate(cylgt4 = cyl > 4) \%>\%
  kpi(var = "cylgt4", by = c("am", "cyl"), txt = "Cylinders",
      kpi_fn = kpi_fn_perc)
l2 <- c(l, kpi3)
}
