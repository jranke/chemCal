\name{inverse.predict}
\alias{inverse.predict}
\alias{inverse.predict.lm}
\alias{inverse.predict.default}
\title{Predict x from y for a linear calibration}
\usage{inverse.predict(object, newdata, 
  ws = ifelse(length(object$weights) > 0, mean(object$weights), 1),
  alpha=0.05, ss = "auto")
}
\arguments{
  \item{object}{
    A univariate model object of class \code{\link{lm}} with model formula
    \code{y ~ x} or \code{y ~ x - 1}.
  }
  \item{newdata}{ 
    A vector of observed y values for one sample.
  }
  \item{ws}{ 
    The weight attributed to the sample. The default is to take the 
    mean of the weights in the model, if there are any.
  }
  \item{alpha}{
    The confidence level for the confidence interval to be reported.
  }
  \item{ss}{
    The estimated standard error of the sample measurements. The 
    default is to take the residual standard error from the calibration.
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
data(massart97ex3)
attach(massart97ex3)
yx <- split(y,factor(x))
s <- round(sapply(yx,sd),digits=2)
w <- round(1/(s^2),digits=3)
weights <- w[factor(x)]
m <- lm(y ~ x,w=weights)

inverse.predict(m,c(15))
}
\keyword{manip}
