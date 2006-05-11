\name{din32645}
\docType{data}
\alias{din32645}
\title{Calibration data from DIN 32645}
\description{
  Sample dataset to test the package.
}
\usage{data(din32645)}
\format{
  A dataframe containing 10 rows of x and y values.
}
\examples{
data(din32645)
m <- lm(y ~ x, data=din32645)
calplot(m)
prediction <- inverse.predict(m,3500,alpha=0.01)
# This should give 0.074 according to DIN (cited from the Dintest test data)
round(prediction$Confidence,3)
}
\references{
  DIN 32645 (equivalent to ISO 11843)

  Dintest. Plugin for MS Excel for evaluations of calibration data. Written
  by Georg Schmitt, University of Heidelberg. 
  \url{http://www.rzuser.uni-heidelberg.de/~df6/download/dintest.htm}
}
\keyword{datasets}
