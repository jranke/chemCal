lod <- function(object, ..., alpha = 0.05, beta = 0.05, n = 1, w = "auto")
{
  UseMethod("lod")
}

lod.default <- function(object, ..., alpha = 0.05, beta = 0.05,
  n = 1, w = "auto")
{
  stop("lod is only implemented for univariate lm objects.")
}

lod.lm <- function(object, ..., alpha = 0.05, beta = 0.05, n = 1, w = "auto")
{
  f <- function(x) {
    y1 <- predict(object, data.frame(x = 0), interval="prediction", 
      level = 1 - alpha)
    y2 <- predict(object, data.frame(x = x), interval="prediction",
      level = 1 - beta)
    (y2[[1,"lwr"]] - y1[[1,"upr"]])^2
  }
  tmp <- optimize(f,interval=c(0,max(object$model$x)))
  return(tmp$minimum)
}
