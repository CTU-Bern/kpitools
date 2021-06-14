

test_that("kpi_fns work correctly", {

  #mean
  expect_equal(kpi_calc(mtcars, "mpg", kpi_fn = kpi_fn_mean)$stat, mean(mtcars$mpg))

  #median
  expect_equal(kpi_calc(mtcars, "mpg", kpi_fn = kpi_fn_median)$stat, median(mtcars$mpg))

  #iqr
  expect_equal(kpi_calc(mtcars, "mpg", kpi_fn = kpi_fn_iqr)$stat, IQR(mtcars$mpg))

  #min
  expect_equal(kpi_calc(mtcars, "mpg", kpi_fn = kpi_fn_min)$stat, min(mtcars$mpg))

  #max
  expect_equal(kpi_calc(mtcars, "mpg", kpi_fn = kpi_fn_max)$stat, max(mtcars$mpg))

  #prop
  expect_warning(a <- kpi_calc(mtcars, "am", kpi_fn = kpi_fn_prop),
               "'kpi_fn_prop' takes a sum of 'var'. It is intended for 0/1 or logical variables")
  expect_equal(a$stat, mean(mtcars$am))

  #percent
  expect_warning(a <- kpi_calc(mtcars, "am", kpi_fn = kpi_fn_perc),
               "'kpi_fn_perc' takes a sum of 'var'. It is intended for 0/1 or logical variables")
  expect_equal(a$stat, mean(mtcars$am)*100)

  #n
  expect_warning(a <- kpi_calc(mtcars, "am", kpi_fn = kpi_fn_n))
  expect_equal(a$stat, sum(mtcars$am))

})

