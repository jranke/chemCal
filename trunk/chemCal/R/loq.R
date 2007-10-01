loq <- function(object, ..., alpha = 0.05, k = 3, n = 1, w.loq = "auto", 
  var.loq = "auto")
{
  UseMethod("loq")
}

loq.default <- function(object, ..., alpha = 0.05, k = 3, n = 1, w.loq = "auto",
  var.loq = "auto")
{
  stop("loq is only implemented for univariate lm objects.")
}

loq.lm <- function(object, ..., alpha = 0.05, k = 3, n = 1, w.loq = "auto",
  var.loq = "auto")
{
  if (length(object$weights) > 0 && var.loq == "auto" && w.loq == "auto") {
    stop(paste("If you are using a model from weighted regression,",
      "you need to specify a reasonable approximation for the",
      "weight (w.loq) or the variance (var.loq) at the",
      "limit of quantification"))
  }
  xname <- names(object$model)[[2]]
  yname <- names(object$model)[[1]]
  f <- function(x) {
    newdata <- data.frame(x = x)
    names(newdata) <- xname
    y <- predict(object, newdata)
    p <- inverse.predict(object, rep(y, n), ws = w.loq, 
        var.s = var.loq, alpha = alpha)
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
