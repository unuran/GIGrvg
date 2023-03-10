
myrgig <- function(n=1, lambda, chi, psi) {
  ## ------------------------------------------------------------------------
  ## Generate GIG distributed random variates
  ##
  ## density proportional to
  ##    f(x) = x^{lambda-1} e^{-1/2 (chi/x+psi x)}
  ## 
  ##       x >= 0
  ## ------------------------------------------------------------------------
  ## Arguments:
  ##
  ##   n ....... sample size
  ##   lambda .. parameter for distribution
  ##   chi   ... parameter for distribution                                   
  ##   psi   ... parameter for distribution                                   
  ## ------------------------------------------------------------------------

  ## generate sample
  .Call("my_rgig", n, lambda, chi, psi, PACKAGE="test.CAPI.GIGrvg")
}
