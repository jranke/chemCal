#' Estimate a limit of detection (LOD)
#' 
#' The decision limit (German: Nachweisgrenze) is defined as the signal or
#' analyte concentration that is significantly different from the blank signal
#' with a first order error alpha (one-sided significance test).  The detection
#' limit, or more precise, the minimum detectable value (German:
#' Erfassungsgrenze), is then defined as the signal or analyte concentration
#' where the probability that the signal is not detected although the analyte
#' is present (type II or false negative error), is beta (also a one-sided
#' significance test).
#' 
#' @aliases lod lod.lm lod.rlm lod.default
#' @param object A univariate model object of class \code{\link{lm}} or
#' \code{\link[MASS:rlm]{rlm}} with model formula \code{y ~ x} or \code{y ~ x -
#' 1}, optionally from a weighted regression.
#' @param \dots Placeholder for further arguments that might be needed by
#' future implementations.
#' @param alpha The error tolerance for the decision limit (critical value).
#' @param beta The error tolerance beta for the detection limit.
#' @param method The \dQuote{default} method uses a prediction interval at the
#' LOD for the estimation of the LOD, which obviously requires iteration. This
#' is described for example in Massart, p. 432 ff.  The \dQuote{din} method
#' uses the prediction interval at x = 0 as an approximation.
#' @param tol When the \dQuote{default} method is used, the default tolerance
#' for the LOD on the x scale is the value of the smallest non-zero standard
#' divided by 1000. Can be set to a numeric value to override this.
#' @return A list containig the corresponding x and y values of the estimated
#' limit of detection of a model used for calibration.
#' @note 
#' * The default values for alpha and beta are the ones recommended by IUPAC.
#' * The estimation of the LOD in terms of the analyte amount/concentration xD
#' from the LOD in the signal domain SD is done by simply inverting the
#' calibration function (i.e. assuming a known calibration function).
#' * The calculation of a LOD from weighted calibration models requires a
#' weights argument for the internally used \code{\link{predict.lm}}
#' function, which is currently not supported in R.
#' @seealso Examples for \code{\link{din32645}}
#' @references Massart, L.M, Vandenginste, B.G.M., Buydens, L.M.C., De Jong,
#' S., Lewi, P.J., Smeyers-Verbeke, J. (1997) Handbook of Chemometrics and
#' Qualimetrics: Part A, Chapter 13.7.8
#' 
#' J. Inczedy, T. Lengyel, and A.M. Ure (2002) International Union of Pure and
#' Applied Chemistry Compendium of Analytical Nomenclature: Definitive Rules.
#' Web edition.
#' 
#' Currie, L. A. (1997) Nomenclature in evaluation of analytical methods
#' including detection and quantification capabilities (IUPAC Recommendations
#' 1995).  Analytica Chimica Acta 391, 105 - 126.
#' @importFrom stats optimize predict
#' @examples
#' 
#' m <- lm(y ~ x, data = din32645)
#' lod(m) 
#' 
#' # The critical value (decision limit, German Nachweisgrenze) can be obtained
#' # by using beta = 0.5:
#' lod(m, alpha = 0.01, beta = 0.5)
#' 
#' @export
lod <- function(object, ..., alpha = 0.05, beta = 0.05, method = "default", tol = "default")
{
  UseMethod("lod")
}

#' @export
lod.default <- function(object, ..., alpha = 0.05, beta = 0.05, method = "default", tol = "default")
{
  stop("lod is only implemented for univariate lm objects.")
}

#' @export
lod.lm <- function(object, ..., alpha = 0.05, beta = 0.05, method = "default", tol = "default")
{
  if (length(object$weights) > 0) {
    stop(paste(
      "\nThe detemination of a lod from calibration models obtained by",
      "weighted linear regression requires confidence intervals for",
      "predicted y values taking into account weights for the x values",
      "from which the predictions are to be generated.",
      "This is not supported by the internally used predict.lm method.",
      sep = "\n"
    ))
  }
  xname <- names(object$model)[[2]]
  xvalues <- object$model[[2]]
  yname <- names(object$model)[[1]]
  newdata <- data.frame(0)
  names(newdata) <- xname
  y0 <- predict(object, newdata, interval = "prediction", 
    level = 1 - 2 * alpha)
  yc <- y0[[1,"upr"]]
  if (method == "din") {
    y0.d <- predict(object, newdata, interval = "prediction",
      level = 1 - 2 * beta)
    deltay <- y0.d[[1, "upr"]] - y0.d[[1, "fit"]]
    lod.y <- yc + deltay 
    lod.x <- inverse.predict(object, lod.y)$Prediction
  } else {
    f <- function(x) {
      newdata <- data.frame(x)
      names(newdata) <- xname
      pi.y <- predict(object, newdata, interval = "prediction",
        level = 1 - 2 * beta)
      yd <- pi.y[[1,"lwr"]]
      (yd - yc)^2
    }
    if (tol == "default") tol = min(xvalues[xvalues !=0]) / 1000
    lod.x <- optimize(f, interval = c(0, max(xvalues) * 10), tol = tol)$minimum
    newdata <- data.frame(x = lod.x)
    names(newdata) <- xname
    lod.y <-  predict(object, newdata)
    names(lod.y) <- NULL
  }
  lod <- list(lod.x, lod.y)
  names(lod) <- c(xname, yname)
  return(lod)
}
