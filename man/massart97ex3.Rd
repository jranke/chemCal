% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chemCal-package.R
\docType{data}
\name{massart97ex3}
\alias{massart97ex3}
\title{Calibration data from Massart et al. (1997), example 3}
\format{
A dataframe containing 6 levels of x values with 5 observations of y
for each level.
}
\source{
Massart, L.M, Vandenginste, B.G.M., Buydens, L.M.C., De Jong, S.,
Lewi, P.J., Smeyers-Verbeke, J. (1997) Handbook of Chemometrics and
Qualimetrics: Part A, Chapter 8.
}
\description{
Sample dataset from p. 188 to test the package.
}
\examples{

# For reproducing the results for replicate standard measurements in example 8,
# we need to do the calibration on the means when using chemCal > 0.2
weights <- with(massart97ex3, {
  yx <- split(y, x)
  ybar <- sapply(yx, mean)
  s <- round(sapply(yx, sd), digits = 2)
  w <- round(1 / (s^2), digits = 3)
})

massart97ex3.means <- aggregate(y ~ x, massart97ex3, mean)

m3.means <- lm(y ~ x, w = weights, data = massart97ex3.means)

# The following concords with the book p. 200
inverse.predict(m3.means, 15, ws = 1.67)  # 5.9 +- 2.5
inverse.predict(m3.means, 90, ws = 0.145) # 44.1 +- 7.9

# The LOD is only calculated for models from unweighted regression
# with this version of chemCal
m0 <- lm(y ~ x, data = massart97ex3) 
lod(m0)

# Limit of quantification from unweighted regression
loq(m0)

# For calculating the limit of quantification from a model from weighted
# regression, we need to supply weights, internally used for inverse.predict
# If we are not using a variance function, we can use the weight from
# the above example as a first approximation (x = 15 is close to our
# loq approx 14 from above).
loq(m3.means, w.loq = 1.67)
# The weight for the loq should therefore be derived at x = 7.3 instead
# of 15, but the graphical procedure of Massart (p. 201) to derive the 
# variances on which the weights are based is quite inaccurate anyway. 

}
\keyword{datasets}
