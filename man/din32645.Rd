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
(prediction <- inverse.predict(m,3500,alpha=0.01))
# This should give 0.074 according to DIN (cited from the Dintest test data)
round(prediction$Confidence,3)

# According to Dintest, we should get 0.07, but we get 0.0759
lod(m, alpha = 0.01)

# In German, there is the "Erfassungsgrenze", with k = 2, 
# and we should get 0.14 according to Dintest
lod(m, k = 2, alpha = 0.01)

# According to Dintest, we should get 0.21, we get 0.212
loq(m, alpha = 0.01)
}
\references{
  DIN 32645 (equivalent to ISO 11843)

  Dintest. Plugin for MS Excel for evaluations of calibration data. Written
  by Georg Schmitt, University of Heidelberg. 
  \url{http://www.rzuser.uni-heidelberg.de/~df6/download/dintest.htm}
}
\keyword{datasets}
