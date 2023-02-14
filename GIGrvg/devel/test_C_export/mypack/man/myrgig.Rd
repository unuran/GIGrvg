
\name{myrgig}
\alias{myrgig}

\title{ 
  Generator and Density of Generalized Inverse Gaussian (GIG) distribution.
}

\description{
  Random variate generator for the Generalized Inverse Gaussian (GIG)
  distribution.
}

\usage{
myrgig(n=1, lambda, chi, psi)
}

\arguments{
  \item{n}{Number of observations}
  \item{lambda}{Shape parameter}
  \item{chi}{Shape and scale parameter. Must be nonnegative for positive lambda and positive else.}
  \item{psi}{Shape and scale parameter. Must be nonnegative for negative lambda and positive else.}
}

\details{
  The package uses a parametrization for the GIG distribution where the
  density is proportional to
  \deqn{f(x) = x^{\lambda-1} e^{-\frac{1}{2}(\chi/x+\psi x)}.}{%
    f(x) = x^(\lambda-1) e^(-(\chi/x+\psi*x)/2) .}
  The parameters have to satisfy the conditions
  
  \deqn{%
    \begin{array}{l}
    \lambda > 0,\, \psi > 0, \chi \geq 0, \quad\mbox{or} \\
    \lambda = 0,\, \psi > 0, \chi > 0,    \quad\mbox{or}  \\
    \lambda < 0,\, \psi \geq 0, \chi > 0.
    \end{array}
  }{%
    \lambda > 0, \psi > 0, \chi >= 0, or
    \lambda = 0, \psi > 0, \chi > 0,  or
    \lambda < 0, \psi >= 0, \chi > 0. }

  The generator is especially designed for the varying parameter case,
  i.e., for sample size \code{n=1}.

  \strong{Note} that the arguments \code{n}, \code{lambda}, \code{chi},
  \code{psi} for these two \R routines are assumed to be single values.
  If a vector is provided, then just the first value is used!
}

\value{
  \code{myrgig} creates a random sample of size \code{n}. In case of
  invalid arguments the routine simply stops execution.
}

\author{
  Josef Leydold \email{josef.leydold@wu.ac.at}
}

\examples{
## Draw a random sample
x <- myrgig(n=10, lambda=0.5, chi=0.1, psi=2)
x
}

