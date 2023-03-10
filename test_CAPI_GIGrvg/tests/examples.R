
library(GIGrvg)
library(test.CAPI.GIGrvg)

## --- auxiliary functions ---------------------------------------------------

## check whether error has been thrown
iserror <- function (expr) { is(try(expr), "try-error") }

## mode of GIG distribution
gig.mode <- function (lambda, chi, psi) {
        omega = sqrt(psi*chi)

        ## lambda can be < 0 !!
        if (lambda >= 1.)
                mode <- (sqrt((lambda-1)*(lambda-1) + psi*chi)+(lambda-1)) / psi
        else
                mode <- chi / (sqrt((1-lambda)*(1-lambda) + psi*chi)+(1-lambda))

        mode
}

## check GIG parameters
check.params <- function (lambda, chi, psi) {
        valid <- FALSE
        if ((chi >= 0 && psi >= 0)   &&
            (chi != 0 || lambda > 0) &&
            (psi != 0 || lambda < 0)) {
                valid <- TRUE
        }
        valid
}

## show warnings immediately
options(warn=1)

##############################################################################
##
## dgig()
##
##############################################################################

## --- check handling of invalid parameters ----------------------------------

xvals <- c(1,NA,NaN)
lambda <- c(1,NA,NaN,Inf)
chi <- c(1, NA, NaN, Inf)
psi <- c(1, NA, NaN, Inf)

for (x in xvals) { for (l in lambda) { for (c in chi) { for (p in psi) {
        f <- dgig(x,l,c,p)
        lf <- dgig(x,l,c,p,TRUE)
        a <- c(x,l,c,p)
        if (length(a[!is.finite(a)])>0 && !(is.na(f) && is.na(lf))) {
                cat ("f=",f,"; logf=",lf,"\t",
                     "; x=",x,"; lambda=",l,"; chi=",c,"; psi=",p,"\n", sep="")
                stop ("NA or NaN expected")
        }
}}}}

if (! (is.nan(dgig(1, -1,-1, 1)) &&
       is.nan(dgig(1, -1, 0, 1)) &&
       is.nan(dgig(1, -1, 1,-1)) &&
       is.nan(dgig(1,  0,-1, 1)) &&
       is.nan(dgig(1,  0, 1, 0)) &&
       is.nan(dgig(1,  0, 0, 1)) &&
       is.nan(dgig(1,  0, 1,-1)) &&
       is.nan(dgig(1,  1,-1, 1)) &&
       is.nan(dgig(1,  1, 1, 0)) &&
       is.nan(dgig(1,  1, 1,-1)) ) ) {
        stop ("NA or NaN expected")
}

## --- verify finite (non-NaN, non-Inf) results: evaluate at mode ------------

lambda <- c(-100, -10, -1, -0.1, 0, 0.1, 1, 10, 100)
chi <- c(0, 0.01, 0.1, 1, 10, 100)
psi <- c(0, 0.01, 0.1, 1, 10, 100)

for (l in lambda) { for (c in chi) { for (p in psi) {
        if (!check.params(l,c,p)) next
        m <- gig.mode(l,c,p)
        if (m==0.0) m <- 1
        f <- signif(dgig(m,l,c,p),5)
        lf <- signif(dgig(m,l,c,p,TRUE),5)
        cat ("f=",f,"; logf=",lf,"\t",
             "; lambda=",l,"; chi=",c,"; psi=",p,";mode=",m,"\n", sep="")
        if (! isTRUE(is.finite(f)) || ! isTRUE(is.finite(lf)))
                stop ("result not finite")
}}}

## --- verify results for special values -------------------------------------

xvals <- c(-Inf,-1,0,Inf)
lambda <- c(-100, -10, -1, -0.1, 0, 0.1, 1, 10, 100)
chi <- c(0, 0.01, 0.1, 1, 10, 100)
psi <- c(0, 0.01, 0.1, 1, 10, 100)

for (x in xvals) { for (l in lambda) { for (c in chi) { for (p in psi) {
        if (!check.params(l,c,p)) next
        f <- dgig(x,l,c,p)
        lf <- dgig(x,l,c,p,TRUE)
        if (! isTRUE(all(c(f,lf) == c(0,-Inf))) ) {
                cat ("f=",f,"; logf=",lf,"\t",
                     "; x=",x,"; lambda=",l,"; chi=",c,"; psi=",p,"\n", sep="")
                stop ("0 and -Inf expected")
        }
}}}}

## --- verify normalization constant: integrate density ----------------------

lambda <- c(-10, -1, -0.1, 0, 0.1, 1, 10)
chi <- c(0.01, 0.1, 1, 10, 100)
psi <- c(0.01, 0.1, 1, 10, 100)

for (l in lambda) { for (c in chi) { for (p in psi) {
        if (!check.params(l,c,p)) next
        if ( (c < 0.009 && p < 0.05) || (c < 0.05 && p < 0.009) ) {
                ## integrate() does not work for these parameters 
                next
        }
        a <- integrate(dgig,0,Inf,lambda=l,chi=c,psi=p,rel.tol=1.e-10)
        if (all.equal(a$value,1, tolerance=1e-4) != TRUE) {
                cat("lambda =",l,"; chi =",c,"; psi =",p,"\n\t")
                print(a)
                stop("normalization constant might be wrong")
        }
}}}

## special cases
lambda <- c(-10, -1, -0.5, 0, 0.5,1,10)
chi <- c(0, 0.1, 1, 10, 100)
psi <- c(0, 0.1, 1, 10, 100)

for (l in lambda) { for (c in chi) { for (p in psi) {
        if (!check.params(l,c,p)) next
        if ( (c < 0.009 && p < 0.05) || (c < 0.05 && p < 0.009) ) {
                ## integrate does not work for these parameters 
                next
        }
        a <- integrate(dgig,0,Inf,lambda=l,chi=c,psi=p,rel.tol=1.e-10)
        if (all.equal(a$value,1, tolerance=1e-4) != TRUE) {
                cat("lambda =",l,"; chi =",c,"; psi =",p,"\n\t")
                print(a)
                stop("normalization constant might be wrong")
        }
}}}


##############################################################################
##
## myrgig()
##
##############################################################################

## --- check handling of invalid parameters ----------------------------------

stopifnot (iserror(myrgig(1,-1,-1, 1)), TRUE)
stopifnot (iserror(myrgig(1,-1, 0, 1)), TRUE)
stopifnot (iserror(myrgig(1,-1, 1,-1)), TRUE)
stopifnot (iserror(myrgig(1, 0,-1, 1)), TRUE)
stopifnot (iserror(myrgig(1, 0, 1, 0)), TRUE)
stopifnot (iserror(myrgig(1, 0, 0, 1)), TRUE)
stopifnot (iserror(myrgig(1, 0, 1,-1)), TRUE)
stopifnot (iserror(myrgig(1, 1,-1, 1)), TRUE)
stopifnot (iserror(myrgig(1, 1, 1, 0)), TRUE)
stopifnot (iserror(myrgig(1, 1, 1,-1)), TRUE)

## --- just run generator ----------------------------------------------------

if(!interactive())
    set.seed(123)

## should return numeric(0) 
x <- myrgig(0, 1,1,1)
if (! (is.numeric(x) && length(x) == 0)) {
    stop("rgig(0) not equal numeric(0)")
}

lambda <- c(-100, -10, -1, -0.1, 0, 0.1, 1, 10, 100)
chi <- c(0, 1e-12, 0.01, 0.1, 1, 10, 100)
psi <- c(0, 1e-12, 0.01, 0.1, 1, 10, 100)

for (l in lambda) { for (c in chi) { for (p in psi) {
        if (!check.params(l,c,p)) next
        x <- myrgig(1,l,c,p)
        cat ("x=",signif(x,5),";\tlambda=",l,"; chi=",c,"; psi=",p,"\n", sep="")
        if (! isTRUE(is.finite(x))) {
                cat ("x=",x,";\tlambda=",l,"; chi=",c,"; psi=",p,"\n", sep="")
                stop ("result not finite")
        }
}}}

## --- end -------------------------------------------------------------------
