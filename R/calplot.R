calplot <- function(object, xlim = "auto", ylim = "auto", 
  xlab = "Concentration", ylab = "Response", alpha=0.05)
{
  UseMethod("calplot")
}

calplot.default <- function(object, xlim = "auto", ylim = "auto", 
  xlab = "Concentration", ylab = "Response", alpha=0.05)
{
  stop("Calibration plots only implemented for univariate lm objects.")
}

calplot.lm <- function(object, xlim = "auto", ylim = "auto", 
  xlab = "Concentration", ylab = "Response", alpha=0.05)
{
  if (length(object$coef) > 2)
    stop("More than one independent variable in your model - not implemented")

  if (alpha <= 0 | alpha >= 1)
    stop("Alpha should be between 0 and 1 (exclusive)")

  m <- object
  level <- 1 - alpha
  x <- m$model$x
  y <- m$model$y
  newdata <- data.frame(x = seq(0,max(x),length=250))
  pred.lim <- predict(m, newdata, interval = "prediction",level=level)
  conf.lim <- predict(m, newdata, interval = "confidence",level=level)
  if (xlim == "auto") xlim = c(0,max(x))
  if (ylim == "auto") ylim = range(c(pred.lim,y))
  plot(1,
    type = "n", 
    xlab = xlab,
    ylab = ylab,
    xlim = xlim,
    ylim = ylim
  )
  points(x,y, pch = 21, bg = "yellow")
  matlines(newdata$x, pred.lim, lty = c(1, 4, 4), 
    col = c("black", "red", "red"))
  matlines(newdata$x, conf.lim, lty = c(1, 3, 3), 
    col = c("black", "green4", "green4"))

  legend(min(x), 
    max(pred.lim, na.rm = TRUE), 
    legend = c("Fitted Line", "Confidence Bands", 
        "Prediction Bands"), 
    lty = c(1, 3, 4), 
    lwd = 2, 
    col = c("black", "green4", "red"), 
    horiz = FALSE, cex = 0.9, bg = "gray95")
}
