#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

SEXP winch_stop(SEXP message) {
  Rf_error("winch_stop(): %s", CHAR(STRING_ELT(message, 0)));
}

// For embedded libbacktrace
SEXP R_abort() {
  Rf_error("abort() called from C code");
}
