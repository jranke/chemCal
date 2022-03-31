#' Predict x from y for a linear calibration
#' 
#' This function predicts x values using a univariate linear model that has
#' been generated for the purpose of calibrating a measurement method.
#' Prediction intervals are given at the specified confidence level.  The
#' calculation method was taken from Massart et al. (1997). In particular,
#' Equations 8.26 and 8.28 were combined in order to yield a general treatment
#' of inverse prediction for univariate linear models, taking into account
#' weights that have been used to create the linear model, and at the same time
#' providing the possibility to specify a precision in sample measurements
#' differing from the precision in standard samples used for the calibration.
#' This is elaborated in the package vignette.
#'
#' This is an implementation of Equation (8.28) in the Handbook of Chemometrics
#' and Qualimetrics, Part A, Massart et al (1997), page 200, validated with
#' Example 8 on the same page, extended as specified in the package vignette
#' 
#' @aliases inverse.predict inverse.predict.lm inverse.predict.rlm
#' inverse.predict.default
#' @param object A univariate model object of class \code{\link{lm}} or
#' \code{\link[MASS:rlm]{rlm}} with model formula \code{y ~ x} or \code{y ~ x -
#' 1}.
#' @param newdata A vector of observed y values for one sample.
#' @param \dots Placeholder for further arguments that might be needed by
#' future implementations.
#' @param ws The weight attributed to the sample. This argument is obligatory
#' if \code{object} has weights.
#' @param alpha The error tolerance level for the confidence interval to be
#' reported.
#' @param var.s The estimated variance of the sample measurements. The default
#' is to take the residual standard error from the calibration and to adjust it
#' using \code{ws}, if applicable. This means that \code{var.s} overrides
#' \code{ws}.
#' @return A list containing the predicted x value, its standard error and a
#' confidence interval.
#' @note The function was validated with examples 7 and 8 from Massart et al.
#' (1997).  Note that the behaviour of inverse.predict changed with chemCal
#' version 0.2.1. Confidence intervals for x values obtained from calibrations
#' with replicate measurements did not take the variation about the means into
#' account.  Please refer to the vignette for details.
#' @references Massart, L.M, Vandenginste, B.G.M., Buydens, L.M.C., De Jong,
#' S., Lewi, P.J., Smeyers-Verbeke, J. (1997) Handbook of Chemometrics and
#' Qualimetrics: Part A, p. 200
#' @importFrom stats optimize predict qt
#' @examples
#' 
#' # This is example 7 from Chapter 8 in Massart et al. (1997)
#' m <- lm(y ~ x, data = massart97ex1)
#' inverse.predict(m, 15)        #  6.1 +- 4.9
#' inverse.predict(m, 90)        # 43.9 +- 4.9
#' inverse.predict(m, rep(90,5)) # 43.9 +- 3.2
#' 
#' # For reproducing the results for replicate standard measurements in example 8,
#' # we need to do the calibration on the means when using chemCal > 0.2
#' weights <- with(massart97ex3, {
#'   yx <- split(y, x)
#'   ybar <- sapply(yx, mean)
#'   s <- round(sapply(yx, sd), digits = 2)
#'   w <- round(1 / (s^2), digits = 3)
#' })
#' 
#' massart97ex3.means <- aggregate(y ~ x, massart97ex3, mean)
#' 
#' m3.means <- lm(y ~ x, w = weights, data = massart97ex3.means)
#' 
#' inverse.predict(m3.means, 15, ws = 1.67)  # 5.9 +- 2.5
#' inverse.predict(m3.means, 90, ws = 0.145) # 44.1 +- 7.9
#' 
#' 
#' @export
inverse.predict <- function(object, newdata, ...,
  ws = "auto", alpha = 0.05, var.s = "auto")
{
  UseMethod("inverse.predict")
}

#' @export
inverse.predict.default <- function(object, newdata, ...,
  ws = "auto", alpha = 0.05, var.s = "auto")
{
  stop("Inverse prediction only implemented for univariate lm objects.")
}

#' @export
inverse.predict.lm <- function(object, newdata, ...,
  ws = "auto", alpha = 0.05, var.s = "auto")
{
  yname = names(object$model)[[1]]
  xname = names(object$model)[[2]]
  if (ws == "auto") {
    ws <- ifelse(length(object$weights) > 0, mean(object$weights), 1)
  }
  if (length(object$weights) > 0) {
    w <- object$weights
  } else {
    w <- rep(1, nrow(object$model))
  }
  .inverse.predict(object = object, newdata = newdata, 
    ws = ws, alpha = alpha, var.s = var.s, w = w, xname = xname, yname = yname)
}

#' @export
inverse.predict.rlm <- function(object, newdata, ...,
  ws = "auto", alpha = 0.05, var.s = "auto")
{
  yname = names(object$model)[[1]]
  xname = names(object$model)[[2]]
  if (ws == "auto") {
    ws <- mean(object$w)
  }
  w <- object$w
  .inverse.predict(object = object, newdata = newdata, 
    ws = ws, alpha = alpha, var.s = var.s, w = w, xname = xname, yname = yname)
}

.inverse.predict <- function(object, newdata, ws, alpha, var.s, w, xname, yname)
{
  if (length(object$coef) > 2)
    stop("More than one independent variable in your model - not implemented")

  if (alpha <= 0 | alpha >= 1)
    stop("Alpha should be between 0 and 1 (exclusive)")

  ybars <- mean(newdata)
  m <- length(newdata)

  n <- nrow(object$model)
  df <- n - length(object$coef)
  xi <- object$model[[2]]
  yi <- object$model[[1]]
  yihat <- object$fitted.values

  se <- sqrt(sum(w * (yi - yihat)^2)/df)

  if (var.s == "auto") {
    var.s <- se^2/ws
  }

  b1 <- object$coef[[xname]]

  ybarw <- sum(w * yi)/sum(w)

# This is the adapted form of equation 8.28 (see package vignette)
  sxhats <- 1/b1 * sqrt(
    (var.s / m) + 
    se^2 * (1/sum(w) + 
      (ybars - ybarw)^2 * sum(w) /
        (b1^2 * (sum(w) * sum(w * xi^2) - sum(w * xi)^2)))
  )

  if (names(object$coef)[1] == "(Intercept)") {
    b0 <- object$coef[["(Intercept)"]]
  } else {
    b0 <- 0
  }

  xs <- (ybars - b0) / b1
  t <- qt(1-0.5*alpha, n - 2)
  conf <- t * sxhats
  result <- list("Prediction"=xs,"Standard Error"=sxhats,
    "Confidence"=conf, "Confidence Limits"=c(xs - conf, xs + conf))
  return(result)
}
