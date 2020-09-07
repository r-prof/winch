#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

SEXP winch_stop(SEXP message) {
  Rf_error("winch_stop(): %s", CHAR(STRING_ELT(message, 0)));
}
