\name{plot.calm}
\alias{plot.calm}
\title{Plot calibration graphs from calibration models}
\description{
	Produce graphics of calibration data, the fitted model as well
  as prediction and confidence intervals.
}
\usage{
  plot.calm(x,...,xunit="",yunit="",measurand="",level=0.95)
}
\arguments{
  \item{x}{
    A calibration model of type \code{\link{calm}}. It is named
    x here because the generic plot method expects x to be its 
    first argument.
    }
  \item{...}{
    I just included this because I wanted to avoid the error messages
    from R CMD check that tell me I should read "Writing R extensions" 
    which I did ...
  }
  \item{xunit}{
    The unit of the given values on the x axis as a character vector.
    }
  \item{yunit}{
    The unit of the y axis as a character vector.
    }
  \item{measurand}{ 
    The name of what is being measured as a character vector.
    }
  \item{level}{
    The confidence level of the confidence and prediction bands. Defaults to
    0.95.
    }
}
\value{
  A plot of the calibration data, of your fitted model as well as lines showing
  the confidence limits and the prediction limits.
} 
\examples{

}
\author{
  Johannes Ranke 
  \email{jranke@uni-bremen.de} 
  \url{http://www.uft.uni-bremen.de/chemie/ranke}
}
\keyword{regression}
