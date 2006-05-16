loq <- function(object, ..., alpha = 0.05, k = 3, n = 1, w = "auto")
{
  UseMethod("loq")
}

loq.default <- function(object, ..., alpha = 0.05, k = 3, n = 1, w = "auto")
{
  stop("loq is only implemented for univariate lm objects.")
}

loq.lm <- function(object, ..., alpha = 0.05, k = 3, n = 1, w = "auto")
{
  f <- function(x) {
    y <- predict(object, data.frame(x = x))
    p <- inverse.predict(object, rep(y, n), ws = w, alpha = alpha)
    (p[["Prediction"]] - k * p[["Confidence"]])^2
  }
  tmp <- optimize(f,interval=c(0,max(object$model$x)))
  return(tmp$minimum)
}
