

test_that("kpi_calc", {
  expect_error(mtcars %>%
                 kpi_calc("mpg"))
  expect_error(mtcars %>%
                 kpi_calc("mpg", kpi_fn = kpi_fn_median), NA)
})



