#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

SEXP winch_call(SEXP function, SEXP env) {
  SEXP call = PROTECT(Rf_lang1(function));
  SEXP out = Rf_eval(call, env);
  UNPROTECT(1);
  return out;
}
