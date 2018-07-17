context("Known results for the example datasets provided by Massart (1997)")

require(chemCal)

test_that("Inverse predictions for example 1 are correct",{
  m1 <- lm(y ~ x, data = massart97ex1)

  # Known values are from the book
  p1.1 <- inverse.predict(m1, 15)
  expect_equal(round(p1.1$Prediction, 1), 6.1)
  expect_equal(round(p1.1$Confidence, 1), 4.9)

  p1.2 <- inverse.predict(m1, 90)
  expect_equal(round(p1.2$Prediction, 1), 43.9)
  expect_equal(round(p1.2$Confidence, 1), 4.9)

  p1.3 <- inverse.predict(m1, rep(90, 5))
  expect_equal(round(p1.3$Prediction, 1), 43.9)
  expect_equal(round(p1.3$Confidence, 1), 3.2)
})

test_that("Inverse predictions for example data 3 are correct when regressing on means",{
  weights <- with(massart97ex3, {
    yx <- split(y, x)
    ybar <- sapply(yx, mean)
    s <- round(sapply(yx, sd), digits = 2)
    w <- round(1 / (s^2), digits = 3)
  })

  massart97ex3.means <- aggregate(y ~ x, massart97ex3, mean)

  m3.means <- lm(y ~ x, w = weights, data = massart97ex3.means)

  # Known values are from the book
  p3.1 <- inverse.predict(m3.means, 15, ws = 1.67)
  expect_equal(round(p3.1$Prediction, 1), 5.9)
  expect_equal(round(p3.1$Confidence, 1), 2.5)

  p3.2 <- inverse.predict(m3.means, 90, ws = 0.145)
  expect_equal(round(p3.2$Prediction, 1), 44.1)
  expect_equal(round(p3.2$Confidence, 1), 7.9)
})
