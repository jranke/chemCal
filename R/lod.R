lod <- function(object, ..., alpha = 0.05, k = 1, n = 1, w = "auto")
{
  UseMethod("lod")
}

loq <- function(object, ..., alpha = 0.05, k = 3, n = 1, w = "auto")
{
  lod(object = object, alpha = alpha, k = k, n = n, w = w)
}

lod.default <- function(object, ..., alpha = 0.05, k = 1, n = 1, w = "auto")
{
  stop("lod is only implemented for univariate lm objects.")
}

lod.lm <- function(object, ..., alpha = 0.05, k = 1, n = 1, w = "auto")
{
  f <- function(x) {
    y <- predict(object, data.frame(x = x))
    p <- inverse.predict(object, rep(y, n), ws = w, alpha = alpha)
    (p[["Prediction"]] - k * p[["Confidence"]])^2
  }
  tmp <- optimize(f,interval=c(0,max(object$model$x)))
  return(tmp$minimum)
}
