

kpi <- mtcars %>%
  kpi("mpg", by = c("am", "cyl"), txt = "MPG")


test_that("Plot runs through", {
  expect_error(plot(kpi), NA)

  p <- plot(kpi)
  expect_equal(length(p), 2)

})

