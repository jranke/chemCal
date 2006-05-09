# This is an implementation of Equation (8.28) in the Handbook of Chemometrics
# and Qualimetrics, Part A, Massart et al, page 200, validated with Example 8
# on the same page

inverse.predict <- function(object, newdata, alpha=0.05)
{
  UseMethod("inverse.predict")
}

inverse.predict.default <- function(object, newdata, alpha=0.05)
{
  stop("Inverse prediction only implemented for univariate lm objects.")
}

inverse.predict.lm <- function(object, newdata, alpha=0.05)
{
  if (is.list(newdata)) {
    if (!is.null(newdata$y))
      newdata <- newdata$y
    else
      stop("Newdata list should contain element newdata$y")
  }

  if (is.matrix(newdata)) {
    Y <- newdata
    Ybar <- apply(Y,1,mean)
    nrepl <- ncol(Y)
  }
  else {
    Y <- as.vector(newdata)
    Ybar <- Y
    nrepl <- 1 
  }

  if (length(object$coef) > 2)
    stop("Inverse prediction not yet implemented for more than one independent variable")

  if (alpha <= 0 | alpha >= 1)
    stop("Alpha should be between 0 and 1 (exclusive)")
}
