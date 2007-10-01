\name{powfunc}
\alias{powfunc}
\title{Power function}
\description{
  Arithmetic power function for modelling univariate nonlinear calibration data.
}
\usage{
  powfunc(x,a,b)
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
    \deqn{f(x) = a x^b}{f(x) = a * x^b}
} 
\author{
  Johannes Ranke 
  \email{jranke@uni-bremen.de} 
  \url{http://www.uft.uni-bremen.de/chemie/ranke}
}
\seealso{
  The inverse of this function \code{\link{ipowfunc}}.
}
\keyword{models}
\keyword{regression}
\keyword{nonlinear}
