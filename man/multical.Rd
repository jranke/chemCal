\name{multical}
\alias{multical}
\title{Calculation of results in a dataframe}
\description{
  This function provides the possibility to perform the calibration
  of multiple components simultaneously, and to provide the results
  including confidence intervals in a dataframe.
}
\usage{
  multical(cf,df,intercept=FALSE)
}
\arguments{
  \item{cf}{ 
    A data frame containig the data for the calibration standards.
    }
  \item{df}{
    A data frame with the measured sample data.
    }
  \item{intercept}{ 
    Logical value determining if an intercept is to be fitted or not. 
    Default is FALSE.
    }
}
\value{
  A data frame containig the measurement results with a confidence interval.
} 
\examples{
data(pahCalibration)
data(pahMeasurements)
result <- multical(pahCalibration,pahMeasurements)
}
\author{
  Johannes Ranke 
  \email{jranke@uni-bremen.de} 
  \url{http://www.uft.uni-bremen.de/chemie/ranke}
}
\keyword{regression}
