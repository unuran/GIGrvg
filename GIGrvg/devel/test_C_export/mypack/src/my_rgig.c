#include <Rinternals.h> 
#include <R_ext/Rdynload.h>
#include <GIGrvg.h>

SEXP my_rgig (SEXP n, SEXP lambda, SEXP chi, SEXP psi)
{ 
   SEXP (*fun)(SEXP,SEXP,SEXP,SEXP) = NULL;

   if (!fun) 
      fun = (SEXP(*)(SEXP,SEXP,SEXP,SEXP)) R_GetCCallable("GIGrvg", "rgig");

   return (fun(n,lambda,chi,psi));
}
