\name{inverse.predict}
\alias{inverse.predict}
\alias{inverse.predict.lm}
\alias{inverse.predict.rlm}
\alias{inverse.predict.default}
\title{Predict x from y for a linear calibration}
\usage{inverse.predict(object, newdata, \dots,
  ws, alpha=0.05, var.s = "auto")
}
\arguments{
  \item{object}{
    A univariate model object of class \code{\link{lm}} or 
    \code{\link[MASS:rlm]{rlm}} 
    with model formula \code{y ~ x} or \code{y ~ x - 1}.
  }
  \item{newdata}{ 
    A vector of observed y values for one sample.
  }
  \item{\dots}{
    Placeholder for further arguments that might be needed by 
    future implementations.
  }
  \item{ws}{ 
    The weight attributed to the sample. This argument is obligatory
    if \code{object} has weights.
  }
  \item{alpha}{
    The error tolerance level for the confidence interval to be reported.
  }
  \item{var.s}{
    The estimated variance of the sample measurements. The default is to take
    the residual standard error from the calibration and to adjust it
    using \code{ws}, if applicable. This means that \code{var.s}
    overrides \code{ws}.
  }
}
\value{
  A list containing the predicted x value, its standard error and a
  confidence interval.
}
\description{
  This function predicts x values using a univariate linear model that has been
  generated for the purpose of calibrating a measurement method. Prediction
  intervals are given at the specified confidence level.
  The calculation method was taken from Massart et al. (1997). In particular,
  Equations 8.26 and 8.28 were combined in order to yield a general treatment
  of inverse prediction for univariate linear models, taking into account 
  weights that have been used to create the linear model, and at the same
  time providing the possibility to specify a precision in sample measurements
  differing from the precision in standard samples used for the calibration.
  This is elaborated in the package vignette.
}
\note{
  The function was validated with examples 7 and 8 from Massart et al. (1997).
}
\references{
  Massart, L.M, Vandenginste, B.G.M., Buydens, L.M.C., De Jong, S., Lewi, P.J.,
  Smeyers-Verbeke, J. (1997) Handbook of Chemometrics and Qualimetrics: Part A,
  p. 200
}
\examples{
# This is example 7 from Chapter 8 in Massart et al. (1997)
data(massart97ex1)
m <- lm(y ~ x, data = massart97ex1)
inverse.predict(m, 15)        #  6.1 +- 4.9
inverse.predict(m, 90)        # 43.9 +- 4.9
inverse.predict(m, rep(90,5)) # 43.9 +- 3.2
}
\keyword{manip}
