\name{calm}
\alias{calm}
\alias{print.calm}
\alias{predict.calm}
\alias{summary.calm}
\title{Generate a calibration model}
\description{
  This function fits a calibration model to the data 
  frame.
}
\usage{
  calm(data)
}
\arguments{
  \item{data}{
    A data frame with numeric x data in the first column and
    numeric y data in the second column.
    }
}
\value{
  An object of class \code{calm}, which is derived from
  a linear model \code{lm}, the only difference being that
  it contains the additional attributes \code{xname},
  \code{yname} and \code{intercept}, the latter being a 
  boolean reporting wether the model uses an intercept or not.
} 
\note{
  The decision if the returned model contains an intercept is taken based on
  the significance of the fitted intercept on a significance level of 0.95.
  The methods \code{\link{print.calm}}, \code{\link{predict.calm}}
  \code{\link{summary.calm}} are just newly assigned names for the
  corresponding methods from the class \code{\link{lm}}.
}
\examples{
  data(din32645)
  calm(din32645)
}
\author{
  Johannes Ranke 
  \email{jranke@uni-bremen.de} 
  \url{http://www.uft.uni-bremen.de/chemie/ranke}
}
\keyword{regression}
