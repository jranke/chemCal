#' Plot calibration graphs from univariate linear models
#' 
#' Produce graphics of calibration data, the fitted model as well as
#' confidence, and, for unweighted regression, prediction bands.
#' 
#' @aliases calplot calplot.default calplot.lm
#' @param object A univariate model object of class \code{\link{lm}} or
#' \code{\link[MASS:rlm]{rlm}} with model formula \code{y ~ x} or \code{y ~ x -
#' 1}.
#' @param xlim The limits of the plot on the x axis.
#' @param ylim The limits of the plot on the y axis.
#' @param xlab The label of the x axis.
#' @param ylab The label of the y axis.
#' @param legend_x An optional numeric value for adjusting the x coordinate of
#' the legend.
#' @param alpha The error tolerance level for the confidence and prediction
#' bands. Note that this includes both tails of the Gaussian distribution,
#' unlike the alpha and beta parameters used in \code{\link{lod}} (see note
#' below).
#' @param varfunc The variance function for generating the weights in the
#' model.  Currently, this argument is ignored (see note below).
#' @return A plot of the calibration data, of your fitted model as well as
#' lines showing the confidence limits. Prediction limits are only shown for
#' models from unweighted regression.
#' @note Prediction bands for models from weighted linear regression require
#' weights for the data, for which responses should be predicted. Prediction
#' intervals using weights e.g. from a variance function are currently not
#' supported by the internally used function \code{\link{predict.lm}},
#' therefore, \code{calplot} does not draw prediction bands for such models.
#' 
#' It is possible to compare the \code{\link{calplot}} prediction bands with
#' the \code{\link{lod}} values if the \code{lod()} alpha and beta parameters
#' are half the value of the \code{calplot()} alpha parameter.
#' @author Johannes Ranke
#' @importFrom graphics legend matlines plot points
#' @examples
#' 
#' data(massart97ex3)
#' m <- lm(y ~ x, data = massart97ex3)
#' calplot(m)
#' 
#' @export calplot
calplot <- function(object, 
  xlim = c("auto", "auto"), ylim = c("auto", "auto"), 
  xlab = "Concentration", ylab = "Response",
  legend_x = "auto", 
  alpha = 0.05, varfunc = NULL)
{
  UseMethod("calplot")
}

#' @export
calplot.default <- function(object, 
  xlim = c("auto","auto"), ylim = c("auto","auto"), 
  xlab = "Concentration", ylab = "Response",
  legend_x = "auto",
  alpha=0.05, varfunc = NULL)
{
  stop("Calibration plots only implemented for univariate lm objects.")
}

#' @export
calplot.lm <- function(object,
  xlim = c("auto","auto"), ylim = c("auto","auto"), 
  xlab = "Concentration", ylab = "Response",
  legend_x = "auto", 
  alpha=0.05, varfunc = NULL)
{
  if (length(object$coef) > 2)
    stop("More than one independent variable in your model - not implemented")

  if (alpha <= 0 | alpha >= 1)
    stop("Alpha should be between 0 and 1 (exclusive)")

  m <- object
  level <- 1 - alpha
  y <- m$model[[1]]
  x <- m$model[[2]]
  if (xlim[1] == "auto") xlim[1] <- 0
  if (xlim[2] == "auto") xlim[2] <- max(x)
  xlim <- as.numeric(xlim)
  newdata <- list(
    x = seq(from = xlim[[1]], to = xlim[[2]], length=250))
  names(newdata) <- names(m$model)[[2]]
  if (is.null(varfunc)) {
    varfunc <- if (length(m$weights)) {
        function(variable) mean(m$weights)
      } else function(variable) rep(1,250)
  }
  pred.lim <- predict(m, newdata, interval = "prediction",
    level=level, weights.newdata = varfunc(m))
  conf.lim <- predict(m, newdata, interval = "confidence",
    level=level)
  yrange.auto <- range(c(0,pred.lim))
  if (ylim[1] == "auto") ylim[1] <- yrange.auto[1]
  if (ylim[2] == "auto") ylim[2] <- yrange.auto[2]
  if (legend_x[1] == "auto") legend_x <- min(object$model[[2]])
  plot(1,
    type = "n", 
    xlab = xlab,
    ylab = ylab,
    xlim = as.numeric(xlim),
    ylim = as.numeric(ylim)
  )
  points(x,y, pch = 21, bg = "yellow")
  matlines(newdata[[1]], pred.lim, lty = c(1, 4, 4), 
    col = c("black", "red", "red"))
  if (length(object$weights) > 0) {
    legend(min(x), 
      max(pred.lim, na.rm = TRUE), 
      legend = c("Fitted Line", "Confidence Bands"),
      lty = c(1, 3), 
      lwd = 2, 
      col = c("black", "green4"), 
      horiz = FALSE, cex = 0.9, bg = "gray95")
  } else {
  matlines(newdata[[1]], conf.lim, lty = c(1, 3, 3), 
    col = c("black", "green4", "green4"))
  legend(legend_x,
    max(pred.lim, na.rm = TRUE), 
    legend = c("Fitted Line", "Confidence Bands", 
        "Prediction Bands"), 
    lty = c(1, 3, 4), 
    lwd = 2, 
    col = c("black", "green4", "red"), 
    horiz = FALSE, cex = 0.9, bg = "gray95")
  }
}
