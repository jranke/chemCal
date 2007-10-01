\name{calplot}
\alias{calplot}
\alias{calplot.default}
\alias{calplot.lm}
\title{Plot calibration graphs from univariate linear models}
\description{
	Produce graphics of calibration data, the fitted model as well
  as confidence, and, for unweighted regression, prediction bands. 
}
\usage{
  calplot(object, xlim = c("auto", "auto"), ylim = c("auto", "auto"),
    xlab = "Concentration", ylab = "Response", alpha=0.05, varfunc = NULL)
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
  \item{varfunc}{
    The variance function for generating the weights in the model.
    Currently, this argument is ignored (see note below).
  }
}
\value{
  A plot of the calibration data, of your fitted model as well as lines showing
  the confidence limits. Prediction limits are only shown for models from
  unweighted regression.
} 
\note{
  Prediction bands for models from weighted linear regression require weights
  for the data, for which responses should be predicted. Prediction intervals
  using weights e.g. from a variance function are currently not supported by
  the internally used function \code{\link{predict.lm}}, therefore,
  \code{calplot} does not draw prediction bands for such models.
}
\examples{
data(massart97ex3)
m <- lm(y ~ x, data = massart97ex3)
calplot(m)
}
\author{
  Johannes Ranke 
  \email{jranke@uni-bremen.de} 
  \url{http://www.uft.uni-bremen.de/chemie/ranke}
}
\keyword{regression}
