#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

static SEXP do_winch_call(SEXP function, SEXP env) {
  SEXP call = PROTECT(Rf_lang1(function));
  SEXP out = Rf_eval(call, env);
  UNPROTECT(1);
  return out;
}

SEXP winch_call(SEXP function, SEXP env) {
  return do_winch_call(function, env);
}
