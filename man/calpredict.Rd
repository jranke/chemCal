\name{calpredict}
\alias{calpredict}
\title{Estimate measurement results including confidence intervals}
\description{
  This function generates estimates for x values from y values, including
  a confidence interval for the x values.  The formulas in this function used
  for prediction of concentrations from (replicate) measurements are taken from 
  the "Handbook of Chemometrics and Qualimetrics Part A" by D. L. Massart, 
  Vandeginste, B. G. M., Buydens, L. M. C., De Jong, S., Lewi, P. J. and
  Smeyers-Verbeke, J, Elsevier, Amsterdam, 1997 and from the EURACHEM/CITAC
  report on "Quantifying uncertainty in analytical measurement", 2000, 
  pp. 111f.
}
\usage{
  calpredict(yobs,xi,yi,xunit="",level=0.95,intercept=FALSE,syobs=FALSE)
}
\arguments{
  \item{yobs}{ 
    A numeric vector containing the observed data.
    }
  \item{xi}{
    A vector of x values of the calibration. 
    }
  \item{yi}{
    A vector of y values of the calibration. 
    }
  \item{xunit}{ 
    The unit of the given values on the x axis as a character string.
    }
  \item{level}{ 
    The desired confidence level for the confidence interval of the
    estimates. Defaults to 0.95.
    }
  \item{intercept}{ 
    Logical value determining if an intercept is to be fitted or not. 
    Default is FALSE.
    }
  \item{syobs}{ 
    If TRUE, a standard deviation for the given y values is 
    calculated, and the resulting confidence interval will
    include this variability (not validated yet). If FALSE (default), this
    standard deviation is not included in the 
    confidence interval. If a numeric value is given, 
    it is used for the standard deviation of "real samples",
    in addition to the standard deviation of the y values
    in the calibration (also not validated yet).
    }
}
\value{
  A list containing the estimate, its standard deviation and its 
  confidence interval.
} 
\examples{
data(pahCalibration)
attach(pahCalibration)
y <- c(51.2,51.4,51.1,51.8)
estimate <- calpredict(y,conc,acenaphthene,xunit="mg/L")
}
\author{
  Johannes Ranke 
  \email{jranke@uni-bremen.de} 
  \url{http://www.uft.uni-bremen.de/chemie/ranke}
}
\keyword{regression}
