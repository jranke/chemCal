lod <- function(object, ..., alpha = 0.05, beta = 0.05)
{
  UseMethod("lod")
}

lod.default <- function(object, ..., alpha = 0.05, beta = 0.05)
{
  stop("lod is only implemented for univariate lm objects.")
}

lod.lm <- function(object, ..., alpha = 0.05, beta = 0.05)
{
  y0 <- predict(object, data.frame(x = 0), interval="prediction", 
      level = 1 - alpha)
  yc <- y0[[1,"upr"]]
  xc <- inverse.predict(object,yc)[["Prediction"]]
  f <- function(x)
  {
      # Here I need the variance of y values as a function of x or
      # y values
      # Strangely, setting the confidence level to 0.5 does not result
      # in a zero confidence or prediction interval
  }
  lod.x <- optimize(f,interval=c(0,max(object$model$x)))$minimum
  lod.y <-  predict(object, data.frame(x = lod.x))
  return(list(x = lod.x, y = lod.y))
}
