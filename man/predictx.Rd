\name{predictx}
\alias{predictx}
\title{Predict x from y values for calibration models}
\description{
  This function predicts x values from y values, as in classical calibration,
  including a confindence interval.
}
\usage{
  predictx(m,yobs,level=0.95)
}
\arguments{
  \item{m}{
    A calibration model of type \code{\link{calm}}.
    }
  \item{yobs}{ 
    A vector of observed y values for one sample.
    }
  \item{level}{
    The confidence level for the confidence interval to be reported.
    }
}
\value{
  A vector containing the estimate (\code{estimate}), its estimated standard
  deviation (\code{sdxpred}), its estimated confidence (\code{confxpred}).
} 
\examples{
  data(din32645)
  m <- calm(din32645)
  r <- predictx(m,3500,level=0.95)
  cat("\nThe confidence interval is",r[["estimate"]],"+-",r[["confxpred"]],"\n")
}
\author{
  Johannes Ranke 
  \email{jranke@uni-bremen.de} 
  \url{http://www.uft.uni-bremen.de/chemie/ranke}
}
\keyword{regression}
