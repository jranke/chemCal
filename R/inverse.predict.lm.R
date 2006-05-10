# This is an implementation of Equation (8.28) in the Handbook of Chemometrics
# and Qualimetrics, Part A, Massart et al (1997), page 200, validated with
# Example 8 on the same page

inverse.predict <- function(object, newdata, 
  ws = ifelse(length(object$weights) > 0, mean(object$weights), 1),
  alpha=0.05, ss = "auto")
{
  UseMethod("inverse.predict")
}

inverse.predict.default <- function(object, newdata, 
  ws = ifelse(length(object$weights) > 0, mean(object$weights), 1),
  alpha=0.05, ss = "auto")
{
  stop("Inverse prediction only implemented for univariate lm objects.")
}

inverse.predict.lm <- function(object, newdata, 
  ws = ifelse(length(object$weights) > 0, mean(object$weights), 1),
  alpha=0.05, ss = "auto")
{
  if (length(object$coef) > 2)
    stop("More than one independent variable in your model - not implemented")

  if (alpha <= 0 | alpha >= 1)
    stop("Alpha should be between 0 and 1 (exclusive)")

  ybars <- mean(newdata)
  m <- length(newdata)

  yx <- split(object$model$y,object$model$x)
  n <- length(yx)
  x <- as.numeric(names(yx))
  ybar <- sapply(yx,mean)
  if (length(object$weights) > 0) {
    wx <- split(object$weights,object$model$x)
    w <- sapply(wx,mean)
  } else {
    w <- rep(1,n)
  }
  yhatx <- split(object$fitted.values,object$model$x)
  yhat <- sapply(yhatx,mean)
  se <- sqrt(sum(w*(ybar - yhat)^2)/(n-2))
  if (ss == "auto") {
    ss <- se
  } else {
    ss <- ss
  }

  b1 <- object$coef[["x"]]

  ybarw <- sum(w * ybar)/sum(w)

# The commented out code for sxhats is equation 8.28 without changes.  It has
# been replaced by the code below, in order to be able to take into account a
# precision in the sample measurements that differs from the precision in the
# calibration samples.

#  sxhats <- se/b1 * sqrt(
#    1/(ws * m) + 
#    1/sum(w) + 
#    (ybars - ybarw)^2 * sum(w) /
#      (b1^2 * (sum(w) * sum(w * x^2) - sum(w * x)^2))
#  )

# This is equation 8.28, but with the possibility to take into account a 
# different precision measurement of the sample and standard solutions
# in analogy to equation 8.26
  sxhats <- 1/b1 * sqrt(
    ss^2/(ws * m) + 
    se^2 * (1/sum(w) + 
      (ybars - ybarw)^2 * sum(w) /
        (b1^2 * (sum(w) * sum(w * x^2) - sum(w * x)^2)))
  )

  if (names(object$coef)[1] == "(Intercept)") {
    b0 <- object$coef[["(Intercept)"]]
  } else {
    b0 <- 0
  }

  xs <- (ybars - b0) / b1
  t <- qt(1-0.5*alpha, n - 2)
  conf <- t * sxhats
  result <- list("Prediction"=xs,"Standard Error"=sxhats,
    "Confidence"=conf, "Confidence Limits"=c(xs - conf, xs + conf))
  return(result)
}
