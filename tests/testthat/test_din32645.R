context("Known results for the dataset provided in DIN 32645")

require(chemCal)

m <- lm(y ~ x, data = din32645)
prediction <- inverse.predict(m, 3500, alpha = 0.01)

test_that("We get correct confidence intervals", {
  # Result collected from Procontrol 3.1 (isomehr GmbH)
  expect_equal(round(prediction$Confidence, 5), 0.07434)
})

test_that("We get a correct critical value", {
  crit <- lod(m, alpha = 0.01, beta = 0.5)
  # DIN 32645 gives 0.07 for the critical value
  # (decision limit, "Nachweisgrenze")
  expect_equal(round(crit$x, 2), 0.07)
  # According to Dintest test data, we should get 0.0698
  expect_equal(round(crit$x, 4), 0.0698)
})

test_that("We get a correct smalles detectable value using the DIN method", {
  lod.din <- lod(m, alpha = 0.01, beta = 0.01, method = "din")
  # DIN 32645 gives 0.14 for the smallest detectable value ("Erfassungsgrenze")
  expect_equal(round(lod.din$x, 2), 0.14)
})

test_that("We get a correct limit of quantification", {
  loq.din <- loq(m, alpha = 0.01)
  # The value cited for Procontrol 3.1 (0.2121) deviates
  # at the last digit, so we only test for three digits
  expect_equal(round(loq.din$x, 3), 0.212)
})
