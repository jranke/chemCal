\name{ipowfunc}
\alias{ipowfunc}
\title{Power function}
\description{
  Inverse of the arithmetic power function \code{\link{powfunc}} used for
  modelling univariate nonlinear calibration data. }
\usage{
  ipowfunc(x,a,b)
}
\arguments{
  \item{x}{
    Independent variable}
  \item{a}{
    Coefficient}
  \item{b}{
    Exponent}
}
\value{
  The result of evaluating the function
    \deqn{f(x) = \frac{y}{a}^\frac{1}{b}}{f(x) = y/a^1/b}
  which is the inverse of the function defined by \code{\link{powfunc}}
} 
\author{
  Johannes Ranke 
  \email{jranke@uni-bremen.de} 
  \url{http://www.uft.uni-bremen.de/chemie/ranke}
}
\seealso{
  The original function \code{\link{powfunc}}.
}
\keyword{models}
\keyword{regression}
\keyword{nonlinear}
