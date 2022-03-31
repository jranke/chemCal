#' Estimate a limit of quantification (LOQ)
#' 
#' The limit of quantification is the x value, where the relative error of the
#' quantification given the calibration model reaches a prespecified value 1/k.
#' Thus, it is the solution of the equation \deqn{L = k c(L)}{L = k * c(L)}
#' where c(L) is half of the length of the confidence interval at the limit L
#' (DIN 32645, equivalent to ISO 11843). c(L) is internally estimated by
#' \code{\link{inverse.predict}}, and L is obtained by iteration.
#' 
#' @aliases loq loq.lm loq.rlm loq.default
#' @param object A univariate model object of class \code{\link{lm}} or
#' \code{\link[MASS:rlm]{rlm}} with model formula \code{y ~ x} or \code{y ~ x -
#' 1}, optionally from a weighted regression. If weights are specified in the
#' model, either \code{w.loq} or \code{var.loq} have to be specified.
#' @param alpha The error tolerance for the prediction of x values in the
#' calculation.
#' @param \dots Placeholder for further arguments that might be needed by
#' future implementations.
#' @param k The inverse of the maximum relative error tolerated at the desired
#' LOQ.
#' @param n The number of replicate measurements for which the LOQ should be
#' specified.
#' @param w.loq The weight that should be attributed to the LOQ. Defaults to
#' one for unweighted regression, and to the mean of the weights for weighted
#' regression. See \code{\link{massart97ex3}} for an example how to take
#' advantage of knowledge about the variance function.
#' @param var.loq The approximate variance at the LOQ. The default value is
#' calculated from the model.
#' @param tol The default tolerance for the LOQ on the x scale is the value of
#' the smallest non-zero standard divided by 1000. Can be set to a numeric
#' value to override this.
#' @return The estimated limit of quantification for a model used for
#' calibration.
#' @note 
#' * IUPAC recommends to base the LOQ on the standard deviation of the
#' signal where x = 0.
#' * The calculation of a LOQ based on weighted regression is non-standard and
#' therefore not tested. Feedback is welcome.
#' @seealso Examples for \code{\link{din32645}}
#' @examples
#' 
#' m <- lm(y ~ x, data = massart97ex1)
#' loq(m)
#' 
#' # We can get better by using replicate measurements
#' loq(m, n = 3)
#' 
#' @export
loq <- function(object, ..., alpha = 0.05, k = 3, n = 1, w.loq = "auto", 
  var.loq = "auto", tol = "default")
{
  UseMethod("loq")
}

#' @export
loq.default <- function(object, ..., alpha = 0.05, k = 3, n = 1, w.loq = "auto",
  var.loq = "auto", tol = "default")
{
  stop("loq is only implemented for univariate lm objects.")
}

#' @export
loq.lm <- function(object, ..., alpha = 0.05, k = 3, n = 1, w.loq = "auto",
  var.loq = "auto", tol = "default")
{
  if (length(object$weights) > 0 && var.loq == "auto" && w.loq == "auto") {
    stop(paste("If you are using a model from weighted regression,",
      "you need to specify a reasonable approximation for the",
      "weight (w.loq) or the variance (var.loq) at the",
      "limit of quantification"))
  }
  xname <- names(object$model)[[2]]
  xvalues <- object$model[[2]]
  yname <- names(object$model)[[1]]
  f <- function(x) {
    newdata <- data.frame(x = x)
    names(newdata) <- xname
    y <- predict(object, newdata)
    p <- inverse.predict(object, rep(y, n), ws = w.loq, 
        var.s = var.loq, alpha = alpha)
    (p[["Prediction"]] - k * p[["Confidence"]])^2
  }
  if (tol == "default") tol = min(xvalues[xvalues !=0]) / 1000
  loq.x <- optimize(f, interval = c(0, max(xvalues) * 10), tol = tol)$minimum
  newdata <- data.frame(x = loq.x)
  names(newdata) <- xname
  loq.y <- predict(object, newdata)
  names(loq.y) <- NULL
  loq <- list(loq.x, loq.y)
  names(loq) <- c(xname, yname)
  return(loq)
}
