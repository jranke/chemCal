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
  if (length(object$weights) > 0) {
    wx <- split(object$model$y,object$model$x)
    w <- sapply(wx,mean)
  } else {
    w <- rep(1,length(split(object$model$y,object$model$x)))
  }
  .inverse.predict(object, newdata, ws, alpha, ss, w)
}

inverse.predict.rlm <- function(object, newdata, 
  ws = mean(object$w), alpha=0.05, ss = "auto")
{
  wx <- split(object$weights,object$model$x)
  w <- sapply(wx,mean)
  .inverse.predict(object, newdata, ws, alpha, ss, w)
}

.inverse.predict <- function(object, newdata, 
  ws = ifelse(length(object$weights) > 0, mean(object$weights), 1),
  alpha=0.05, ss = "auto", w)
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

# This is an adapted form of equation 8.28 (see package vignette)
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
