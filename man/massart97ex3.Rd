\name{massart97ex3}
\docType{data}
\alias{massart97ex3}
\title{Calibration data from Massart et al. (1997), example 3}
\description{
  Sample dataset to test the package.
}
\usage{data(massart97ex3)}
\format{
  A dataframe containing 6 levels of x values with 5
  observations of y for each level.
}
\examples{
data(massart97ex3)
attach(massart97ex3)
yx <- split(y,x)
ybar <- sapply(yx,mean)
s <- round(sapply(yx,sd),digits=2)
w <- round(1/(s^2),digits=3)
weights <- w[factor(x)]
m <- lm(y ~ x,w=weights)
# The following concords with the book
inverse.predict(m, 15, ws = 1.67)
inverse.predict(m, 90, ws = 0.145)

# Some of the following examples are commented out, because the require
# prediction intervals from predict.lm for weighted models, which is not
# available in R at the moment.

#calplot(m)

m0 <- lm(y ~ x)
lod(m0)
#lod(m)

# Now we want to take advantage of the lower weights at lower y values
#m2 <- lm(y ~ x, w = 1/y)
# To get a reasonable weight for the lod, we need to estimate it and predict 
# a y value for it
#yhat.lod <- predict(m,data.frame(x = lod(m2)))
#lod(m2,w=1/yhat.lod,k=3)
}
\source{
  Massart, L.M, Vandenginste, B.G.M., Buydens, L.M.C., De Jong, S., Lewi, P.J., 
  Smeyers-Verbeke, J. (1997) Handbook of Chemometrics and Qualimetrics: Part A, p. 188
}
\keyword{datasets}
