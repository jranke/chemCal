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
  xname <- names(object$model)[[2]]
  yname <- names(object$model)[[1]]
  f <- function(x) {
    newdata <- data.frame(x = x)
    names(newdata) <- xname
    y <- predict(object, newdata)
    p <- inverse.predict(object, rep(y, n), ws = w, alpha = alpha)
    (p[["Prediction"]] - k * p[["Confidence"]])^2
  }
  tmp <- optimize(f,interval=c(0,max(object$model[[2]])))
  loq.x <- tmp$minimum
  newdata <- data.frame(x = loq.x)
  names(newdata) <- xname
  loq.y <- predict(object, newdata)
  loq <- list(loq.x, loq.y)
  names(loq) <- c(xname, yname)
  return(loq)
}
