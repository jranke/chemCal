\name{loq}
\alias{loq}
\alias{loq.lm}
\alias{loq.rlm}
\alias{loq.default}
\title{Estimate a limit of quantification (LOQ)}
\usage{
  loq(object, \dots, alpha = 0.05, k = 3, n = 1, w = "auto")
}
\arguments{
  \item{object}{
    A univariate model object of class \code{\link{lm}} or 
    \code{\link[MASS:rlm]{rlm}} 
    with model formula \code{y ~ x} or \code{y ~ x - 1}, 
    optionally from a weighted regression.
  }
  \item{alpha}{
    The error tolerance for the prediction of x values in the calculation.
  }
  \item{\dots}{
    Placeholder for further arguments that might be needed by 
    future implementations.
  }
  \item{k}{ 
    The inverse of the maximum relative error tolerated at the
    desired LOQ.
  }
  \item{n}{
    The number of replicate measurements for which the LOQ should be
    specified.
  }
  \item{w}{
    The weight that should be attributed to the LOQ. Defaults
    to one for unweighted regression, and to the mean of the weights
    for weighted regression. See \code{\link{massart97ex3}} for 
    an example how to take advantage of knowledge about the 
    variance function.
  }
}
\value{
  The estimated limit of quantification for a model used for calibration.
}
\description{
  A useful operationalisation of a limit of quantification is simply the
  solution of the equation
    \deqn{L = k c(L)}{L = k * c(L)}
  where c(L) is half of the length of the confidence interval at the limit L as
  estimated by \code{\link{inverse.predict}}. By virtue of this formula, the 
  limit of detection is the x value, where the relative error
  of the quantification with the given calibration model is 1/k.
}
\examples{
  data(massart97ex3)
  attach(massart97ex3)
  m0 <- lm(y ~ x)
  loq(m0)

  # Now we use a weighted regression
  yx <- split(y,factor(x))
  s <- round(sapply(yx,sd),digits=2)
  w <- round(1/(s^2),digits=3)
  weights <- w[factor(x)]
  mw <- lm(y ~ x,w=weights)
  loq(mw)

  # In order to define the weight at the loq, we can use
  # the variance function 1/y for the model
  mwy <- lm(y ~ x, w = 1/y)

  # Let's do this with one iteration only
  loq(mwy, w = 1 / predict(mwy,list(x = loq(mwy))))

  # We can get better by doing replicate measurements
  loq(mwy, n = 3, w = 1 / predict(mwy,list(x = loq(mwy))))
}
\keyword{manip}
