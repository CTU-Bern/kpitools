

test_that("calc_kpi", {
  expect_error(mtcars %>%
                 calc_kpi("mpg"))
  expect_error(mtcars %>%
                 calc_kpi("mpg", kpi_fn = kpi_fn_median), NA)
})



