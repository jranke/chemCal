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
  xname <- names(object$model)[[2]]
  newdata <- data.frame(0)
  names(newdata) <- xname
  y0 <- predict(object, newdata, interval="prediction", 
      level = 1 - 2 * alpha )
  yc <- y0[[1,"upr"]]
  xc <- inverse.predict(object,yc)[["Prediction"]]
  f <- function(x)
  {
    newdata <- data.frame(x)
    names(newdata) <- xname
    pi.y <- predict(object, newdata, interval = "prediction",
      level = 1 - 2 * beta)
    yd <- pi.y[[1,"lwr"]]
    (yd - yc)^2
  }
  lod.x <- optimize(f,interval=c(0,max(object$model[[xname]])))$minimum
  newdata <- data.frame(x = lod.x)
  names(lod.x) <- xname
  lod.y <-  predict(object, newdata = lod.x)
  return(list(x = lod.x, y = lod.y))
}
