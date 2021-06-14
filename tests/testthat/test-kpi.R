





kpi1 <- mtcars %>%
  kpi(var = "mpg")


test_that("defaults", {
  expect_equal(length(kpi1), 2)
  expect_equal(names(kpi1), c("settings", "overall"))
  expect_true(all(c("txt", "N", "stat", "n_nonmiss") %in% names(kpi1$overall$calc)))
  expect_false(any(c("risk", "raw_cut") %in% names(kpi1$overall$calc)))
  expect_equal(kpi1$overall$calc$stat, mean(mtcars$mpg))
})

kpi1 <- mtcars %>%
  kpi(var = "mpg", kpi_fn = kpi_fn_median)

test_that("median", {
  expect_equal(length(kpi1), 2)
  expect_equal(names(kpi1), c("settings", "overall"))
  expect_true(all(c("txt", "N", "stat", "n_nonmiss") %in% names(kpi1$overall$calc)))
  expect_false(any(c("risk", "raw_cut") %in% names(kpi1$overall$calc)))
  expect_equal(kpi1$overall$calc$stat, median(mtcars$mpg))
})

kpi1 <- mtcars %>%
  kpi(var = "mpg", by = "am")

test_that("by", {
  expect_equal(length(kpi1), 3)
  expect_equal(names(kpi1), c("settings", "overall", "am"))
  expect_true(all(c("txt", "N", "stat", "n_nonmiss") %in% names(kpi1$overall$calc)))
  expect_true(all(c("txt", "N", "stat", "am", "n_nonmiss") %in% names(kpi1$am$calc)))
  expect_false(any(c("risk", "raw_cut") %in% names(kpi1$overall$calc)))
  expect_false(any(c("risk", "raw_cut") %in% names(kpi1$am$calc)))
  expect_equal(kpi1$overall$calc$stat, mean(mtcars$mpg))
  expect_equal(kpi1$am$calc$stat, tapply(mtcars$mpg, mtcars$am, mean), ignore_attr = TRUE)
})



kpi1 <- mtcars %>%
  kpi(var = "mpg", by = c("am", "cyl"))

test_that("multiple by", {
  expect_equal(length(kpi1), 4)
  expect_equal(names(kpi1), c("settings", "overall", "am", "cyl"))
  expect_true(all(c("txt", "N", "stat", "n_nonmiss") %in% names(kpi1$overall$calc)))
  expect_true(all(c("txt", "N", "stat", "am", "n_nonmiss") %in% names(kpi1$am$calc)))
  expect_true(all(c("txt", "N", "stat", "cyl", "n_nonmiss") %in% names(kpi1$cyl$calc)))
  expect_true(all(c("calc", "outlier") %in% names(kpi1$cyl)))
  expect_false(any(c("risk", "raw_cut") %in% names(kpi1$overall$calc)))
  expect_false(any(c("risk", "raw_cut") %in% names(kpi1$am$calc)))
  expect_equal(kpi1$overall$calc$stat, mean(mtcars$mpg))
  expect_equal(kpi1$am$calc$stat, tapply(mtcars$mpg, mtcars$am, mean), ignore_attr = TRUE)
})


br <- c(0, 10, 20, 30)
kpi1 <- mtcars %>%
  kpi(var = "mpg", breakpoints = br)
kpi2 <- mtcars %>%
  kpi(var = "mpg", breakpoints = br,
      risklabels = c("foo", "baa", "foobaa"))

test_that("breakpoints", {
  expect_equal(length(kpi1), 2)
  expect_equal(names(kpi1), c("settings", "overall"))
  expect_true(all(c("txt", "N", "stat", "risk", "n_nonmiss") %in% names(kpi1$overall$calc)))
  expect_false(any(c("raw_cut") %in% names(kpi1$overall$calc)))
  expect_equal(kpi1$overall$calc$risk,
               cut(mean(mtcars$mpg), breaks = br, labels = risklabs(br)))
  expect_equal(kpi2$overall$calc$risk,
               cut(mean(mtcars$mpg), breaks = br, labels = c("foo", "baa", "foobaa")))
})






