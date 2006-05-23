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
# This should give 0.07434 according to Dintest test data, as 
# collected from Procontrol 3.1 (isomehr GmbH)
round(prediction$Confidence,5)

# According to Dintest test data, we should get 0.0698 for the critical value
# (decision limit, "Nachweisgrenze")
(lod <- lod(m, alpha = 0.01, beta = 0.5))
round(lod$x,4)

# In German, the smallest detectable value is the "Erfassungsgrenze", and we
# should get 0.140 according to Dintest test data, but with chemCal, we can't
# reproduce this, 
lod(m, alpha = 0.01, beta = 0.01) 
# except by using an equivalent to the approximation
# xD = 2 * Sc / A (Currie 1999, p. 118, or Orange Book, Chapter 18.4.3.7)
lod.approx <- 2 * lod$x
round(lod.approx, digits=3)
# which seems to be the pragmatic definition in DIN 32645, as judging from
# the Dintest test data. 

# This accords to the test data from Dintest again, except for the last digit
# of the value cited for Procontrol 3.1 (0.2121)
(loq <- loq(m, alpha = 0.01))
round(loq$x,4)
# A similar value is obtained using the approximation 
# LQ = 3.04 * LC (Currie 1999, p. 120)
3.04 * lod(m,alpha = 0.01, beta = 0.5)$x
}
\references{
  DIN 32645 (equivalent to ISO 11843)

  Dintest. Plugin for MS Excel for evaluations of calibration data. Written
  by Georg Schmitt, University of Heidelberg. 
  \url{http://www.rzuser.uni-heidelberg.de/~df6/download/dintest.htm}

  Currie, L. A. (1997) Nomenclature in evaluation of analytical methods including
  detection and quantification capabilities (IUPAC Recommendations 1995). 
  Analytica Chimica Acta 391, 105 - 126.
}
\keyword{datasets}
