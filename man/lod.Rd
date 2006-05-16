\name{lod}
\alias{lod}
\alias{lod.lm}
\alias{lod.rlm}
\alias{lod.default}
\title{Estimate a limit of detection (LOD)}
\usage{
  lod(object, \dots, alpha = 0.05, beta = 0.05)
}
\arguments{
  \item{object}{
    A univariate model object of class \code{\link{lm}} or 
    \code{\link[MASS:rlm]{rlm}} 
    with model formula \code{y ~ x} or \code{y ~ x - 1}, 
    optionally from a weighted regression.
  }
  \item{\dots}{
    Placeholder for further arguments that might be needed by 
    future implementations.
  }
  \item{alpha}{
    The error tolerance for the decision limit (critical value).
  }
  \item{beta}{
    The error tolerance beta for the detection limit.
  }
}
\value{
  A list containig the corresponding x and y values of the estimated limit of
  detection of a model used for calibration.  }
\description{
  The decision limit (German: Nachweisgrenze) is defined as the signal or
  analyte concentration that is significantly different from the blank signal
  with a first order error alpha (one-sided significance test).
  The detection limit, or more precise, the minimum detectable value 
  (German: Erfassungsgrenze), is then defined as the signal or analyte
  concentration where the probability that the signal is not detected although
  the analyte is present (type II or false negative error), is beta (also a
  one-sided significance test).
}
\references{
  J. Inczedy, T. Lengyel, and A.M. Ure (2002) International Union of Pure and
  Applied Chemistry Compendium of Analytical Nomenclature: Definitive Rules.
  Web edition.
}
\examples{
  data(din32645)
  m <- lm(y ~ x, data = din32645)
  # The decision limit (critical value) is obtained by using beta = 0.5:
  lod(m, alpha = 0.01, beta = 0.5) # approx. Nachweisgrenze in Dintest 2002
  lod(m, alpha = 0.01, beta = 0.01) 
  # In the latter case (Erfassungsgrenze), we get a slight deviation from 
  # Dintest 2002 test data.
}
\keyword{manip}
