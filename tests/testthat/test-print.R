

kpi <- mtcars %>%
  kpi("mpg", by = c("am", "cyl"), txt = "MPG")


test_that("print runs through", {
  expect_error(kpi, NA)
  expect_error(capture_output(print(kpi)), NA)

})

