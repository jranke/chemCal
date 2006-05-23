\name{calplot}
\alias{calplot}
\alias{calplot.default}
\alias{calplot.lm}
\title{Plot calibration graphs from univariate linear models}
\description{
	Produce graphics of calibration data, the fitted model as well
  as prediction and confidence bands. 
}
\usage{
  calplot(object, xlim = "auto", ylim = "auto", 
  xlab = "Concentration", ylab = "Response", alpha=0.05)
}
\arguments{
  \item{object}{
    A univariate model object of class \code{\link{lm}} or 
    \code{\link[MASS:rlm]{rlm}} 
    with model formula \code{y ~ x} or \code{y ~ x - 1}.
  }
  \item{xlim}{
    The limits of the plot on the x axis.
  }
  \item{ylim}{
    The limits of the plot on the y axis.
  }
  \item{xlab}{
    The label of the x axis.
  }
  \item{ylab}{
    The label of the y axis.
  }
  \item{alpha}{
    The error tolerance level for the confidence and prediction bands.
  }
}
\value{
  A plot of the calibration data, of your fitted model as well as lines showing
  the confidence limits as well as the prediction limits.
} 
\examples{
# Example of a Calibration plot for a weighted regression
source("/home/ranke/tmp/r-base-2.3.0/src/library/stats/R/lm.R")
data(massart97ex3)
attach(massart97ex3)
yx <- split(y,factor(x))
s <- round(sapply(yx,sd),digits=2)
w <- round(1/(s^2),digits=3)
weights <- w[factor(x)]
m <- lm(y ~ x,w=10 * weights)
calplot(m)
calplot(m)
}
\author{
  Johannes Ranke 
  \email{jranke@uni-bremen.de} 
  \url{http://www.uft.uni-bremen.de/chemie/ranke}
}
\keyword{regression}
