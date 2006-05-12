\name{lod}
\alias{lod}
\alias{lod.lm}
\alias{lod.rlm}
\alias{lod.default}
\alias{loq}
\alias{loq.lm}
\alias{loq.rlm}
\alias{loq.default}
\title{Estimate a limit of detection (LOD) or quantification (LOQ)}
\usage{
  lod(object, \dots, alpha = 0.05, k = 1, n = 1, w = "auto")
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
    desired LOD/LOQ.
  }
  \item{n}{
    The number of replicate measurements for which the LOD/LOQ should be
    specified.
  }
  \item{w}{
    The weight that should be attributed to the LOD/LOQ. Defaults
    to one for unweighted regression, and to the mean of the weights
    for weighted regression. See \code{\link{massart97ex3}} for 
    an example how to take advantage of knowledge about the variance function.
  }
}
\value{
  The estimated limit of detection for a model used for calibration.
}
\description{
  A useful operationalisation of a lower limit L of a measurement method is
  simply the solution of the equation
    \deqn{L = k c(L)}{L = k * c(L)}
  where c(L) is half of the lenght of the confidence interval at the limit L.
}
\examples{
  data(din32645)
  m <- lm(y ~ x, data = din32645)
  lod(m)
}
\keyword{manip}
