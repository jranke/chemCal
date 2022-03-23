if (requireNamespace("investr")) {

context("Compare with investr::calibrate")

test_that("Unweighted regressions give same results as investr::calibrate using the Wald method", {

  compare_investr <- function(object, y_sample) {
    pred_chemCal <- inverse.predict(object, y_sample)
    pred_investr <- investr::calibrate(object, y_sample, interval = "Wald")
    expect_equivalent(pred_chemCal[["Prediction"]], 
                      pred_investr$estimate)
    expect_equivalent(pred_chemCal[["Standard Error"]], 
                      pred_investr$se)
    expect_equivalent(pred_chemCal[["Confidence Limits"]][1], 
                      pred_investr$lower)  
    expect_equivalent(pred_chemCal[["Confidence Limits"]][2],
                      pred_investr$upper)  
  }
  m_tol <- lm(peak_area ~ amount, data = rl95_toluene)
  compare_investr(m_tol, 1000)

  m_din <- lm(y ~ x, din32645)
  compare_investr(m_din, 5000)

  m_m1 <- lm(y ~ x, massart97ex1)
  compare_investr(m_m1, 15)

  m_m3 <- lm(y ~ x, massart97ex3)
  compare_investr(m_m3, 15)
})

}
