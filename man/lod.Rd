\name{lod}
\alias{lod}
\alias{lod.lm}
\alias{lod.rlm}
\alias{lod.default}
\title{Estimate a limit of detection (LOD)}
\usage{
  lod(object, \dots, alpha = 0.05, beta = 0.05, method = "default")
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
  \item{method}{
    The default method uses a prediction interval at the LOD
    for the estimation of the LOD, which obviously requires
    iteration. This is described for example in Massart, p. 432 ff.
    The \dQuote{din} method uses the prediction interval at
    x = 0 as an approximation.
  }
}
\value{
  A list containig the corresponding x and y values of the estimated limit of
  detection of a model used for calibration.  
}
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
\note{
  - The default values for alpha and beta are the ones recommended by IUPAC.
  - The estimation of the LOD in terms of the analyte amount/concentration
    xD from the LOD in the signal domain SD is done by simply inverting the
    calibration function (i.e. assuming a known calibration function).
  - The calculation of a LOD from weighted calibration models requires
    a weights argument for the internally used \code{\link{predict.lm}}
    function, which is currently not supported in R.
}
\references{
  Massart, L.M, Vandenginste, B.G.M., Buydens, L.M.C., De Jong, S., Lewi, P.J., 
  Smeyers-Verbeke, J. (1997) Handbook of Chemometrics and Qualimetrics: Part A,
  Chapter 13.7.8 

  J. Inczedy, T. Lengyel, and A.M. Ure (2002) International Union of Pure and
  Applied Chemistry Compendium of Analytical Nomenclature: Definitive Rules.
  Web edition.

  Currie, L. A. (1997) Nomenclature in evaluation of analytical methods including
  detection and quantification capabilities (IUPAC Recommendations 1995). 
  Analytica Chimica Acta 391, 105 - 126.
}
\examples{
data(din32645)
m <- lm(y ~ x, data = din32645)
lod(m) 

# The critical value (decision limit, German Nachweisgrenze) can be obtained
# by using beta = 0.5:
lod(m, alpha = 0.01, beta = 0.5)
}
\seealso{
  Examples for \code{\link{din32645}}  
}
\keyword{manip}
