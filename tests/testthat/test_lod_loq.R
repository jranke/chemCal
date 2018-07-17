context("LOD and LOQ")

library(chemCal)

test_that("lod is stable across chemCal versions", {
  m <- lm(y ~ x, data = din32645)
  lod_1 <- lod(m)
  expect_equal(signif(lod_1$x, 7), 0.08655484)
  expect_equal(signif(lod_1$y, 7), 3317.154)

  # Critical value (decision limit, Nachweisgrenze)
  lod_2 <- lod(m, alpha = 0.01, beta = 0.5)
  expect_equal(signif(lod_2$x, 7), 0.0698127)
  expect_equal(signif(lod_2$y, 7), 3155.393)
})

test_that("loq is stable across chemCal versions", {
  # Actually it was not stable between chemCal <0.2 and 
  # chemCal > 0.2, so we needed to adapt the test
  # to work on a model on the means
  massart97ex3_means <- aggregate(y ~ x, massart97ex3, mean)
  m2 <- lm(y ~ x, data = massart97ex3_means)
  loq_1 <- loq(m2)
  expect_equal(signif(loq_1$x, 7), 13.97764)
  expect_equal(signif(loq_1$y, 7), 30.6235)

  loq_2 <- loq(m2, n = 3)
  expect_equal(signif(loq_2$x, 7), 9.971963)
  expect_equal(signif(loq_2$y, 7), 22.68539)
})


