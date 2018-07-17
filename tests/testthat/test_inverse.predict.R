context("Inverse predictions")

library(chemCal)

test_that("Inverse predictions for unweighted regressions are stable", {
  m1 <- lm(y ~ x, data = massart97ex1)

  # Known values from chemcal Version 0.1-37
  p1.1 <- inverse.predict(m1, 15)
  expect_equal(signif(p1.1$Prediction, 7), 6.09381)
  expect_equal(signif(p1.1$`Standard Error`, 7), 1.767278)
  expect_equal(signif(p1.1$Confidence, 7), 4.906751)

  p1.2 <- inverse.predict(m1, 90)
  expect_equal(signif(p1.2$Prediction, 7), 43.93983)
  expect_equal(signif(p1.2$`Standard Error`, 7), 1.767747)
  expect_equal(signif(p1.2$Confidence, 7), 4.908053)

  p1.3 <- inverse.predict(m1, rep(90, 5))
  expect_equal(signif(p1.3$Prediction, 7), 43.93983)
  expect_equal(signif(p1.3$`Standard Error`, 7), 1.141204)
  expect_equal(signif(p1.3$Confidence, 7), 3.168489)
})

test_that("Inverse predictions for weighted regressions are stable", {
  weights <- with(massart97ex3, {
    yx <- split(y, x)
    ybar <- sapply(yx, mean)
    s <- round(sapply(yx, sd), digits = 2)
    w <- round(1 / (s^2), digits = 3)
  })

  massart97ex3.means <- aggregate(y ~ x, massart97ex3, mean)

  m3.means <- lm(y ~ x, w = weights, data = massart97ex3.means)

  p3.1 <- inverse.predict(m3.means, 15, ws = 1.67)
  expect_equal(signif(p3.1$Prediction, 7), 5.865367)
  expect_equal(signif(p3.1$`Standard Error`, 7), 0.8926109)
  expect_equal(signif(p3.1$Confidence, 7), 2.478285)

  p3.2 <- inverse.predict(m3.means, 90, ws = 0.145)
  expect_equal(signif(p3.2$Prediction, 7), 44.06025)
  expect_equal(signif(p3.2$`Standard Error`, 7), 2.829162)
  expect_equal(signif(p3.2$Confidence, 7), 7.855012)
})
