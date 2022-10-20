#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#ifdef HAVE_LIBBACKTRACE
#include <backtrace-supported.h>
#endif


SEXP winch_trace_back_unwind(void);
SEXP winch_trace_back_backtrace(void);


SEXP winch_trace_back(SEXP method) {
  if (TYPEOF(method) != INTSXP) {
    Rf_error("winch_trace_back: method must be integer");
  }

  if (Rf_length(method) != 1) {
    Rf_error("winch_trace_back: method must be scalar");
  }

  if (INTEGER(method)[0] == 1) {
    return winch_trace_back_unwind();
  } else if (INTEGER(method)[0] == 2) {
    return winch_trace_back_backtrace();
  } else {
    Rf_error("winch_trace_back: method invalid");
  }
}

SEXP winch_trace_back_default_method(void) {
#if defined(HAVE_LIBUNWIND)
  return Rf_ScalarInteger(1);
#elif defined(HAVE_LIBBACKTRACE) && BACKTRACE_SUPPORTED
  return Rf_ScalarInteger(2);
#else
  return Rf_ScalarInteger(0);
#endif
}
