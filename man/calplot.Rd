\name{calplot}
\alias{calplot}
\title{Plot calibration graphs}
\description{
	Produce graphics of calibration data, the fitted model as well
  as prediction and confidence intervals.
}
\usage{
  calplot(x,y,intercept=FALSE,measurand="substance x",xunit="mg/L",yunit="Area",level=0.95)
}
\arguments{
  \item{x}{
    A vector of x values.
    }
  \item{y}{
    A vector of y values.
    }
  \item{intercept}{
    A boolean describing if the calibration curve is to be forced
    through zero.
    }
  \item{measurand}{ 
    The name of what is being measured as a character vector.
    }
  \item{xunit}{
    The unit of the given values on the x axis as a character vector.
    }
  \item{yunit}{
    The unit of the y axis as a character vector. Defaults to "Area".
    }
  \item{level}{
    The confidence level of the confidence and prediction bands. Defaults to
    0.95.
    }
}
\value{
  A linear model object for y ~ x.  You will also get a plot of the calibration
  data, of your fitted model as well as lines showing the confidence limits and
  the prediction limits.
} 
\examples{
data(pahCalibration)
attach(pahCalibration)
\dontrun{calplot(conc,phenanthrene,"Phenanthrene","mg/L")}
detach(pahCalibration)
}
\author{
  Johannes Ranke 
  \email{jranke@uni-bremen.de} 
  \url{http://www.uft.uni-bremen.de/chemie/ranke}
}
\keyword{regression}
