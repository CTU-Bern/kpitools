

k1 <- suppressWarnings(kpi(mtcars, "am", kpi_fn = kpi_fn_perc))
k2 <- kpi(mtcars, "mpg", kpi_fn = kpi_fn_median)
kpis <- c(k1, k2)

k1 <- suppressWarnings(kpi(mtcars, "am", by = "cyl", kpi_fn = kpi_fn_perc))
k2 <- kpi(mtcars, "mpg", by = "cyl", kpi_fn = kpi_fn_median)
kpis2 <- c(k1, k2)



test_that("kpi_accumulate", {
  expect_warning(kpi_accumulate(kpis), NA)
  expect_warning(kpi_accumulate(kpis2), NA)
  expect_error(a <- kpi_accumulate(kpis), NA)
  expect_error(b <- kpi_accumulate(kpis2), NA)
  expect_error(d <- kpi_accumulate(kpis2, "overall"), NA)
  expect_error(e <- kpi_accumulate(kpis2, split = FALSE), NA)

  expect_equal(length(a), 1)
  expect_equal(nrow(a$overall), 2)
  expect_equal(class(a)[1], "kpi_accumulate")
  expect_equal(length(b), 2)
  expect_equal(nrow(b$overall), 2)
  expect_equal(length(b$cyl), 3)
  expect_equal(nrow(b$cyl$`4`), 2)
  expect_equal(class(b)[1], "kpi_accumulate")

  expect_equal(class(d)[1], "kpi_accumulate")
  expect_equal(nrow(d), 2)

  expect_equal(nrow(e$cyl), 6)


})




