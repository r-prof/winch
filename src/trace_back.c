#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#include <execinfo.h>

void* buf[10000];

SEXP winch_trace_back() {
  int size = backtrace(buf, sizeof(buf) / sizeof(*buf));

  char** symbols = backtrace_symbols(buf, size);
  if (!symbols) Rf_error("backtrace_symbols() failed to allocate.");

  SEXP out = PROTECT(Rf_allocVector(STRSXP, size));

  for (int i = 0; i < size; ++i) {
    SET_STRING_ELT(out, i, Rf_mkCharCE(symbols[i], CE_UTF8));
  }

  UNPROTECT(1);
  return out;
}
