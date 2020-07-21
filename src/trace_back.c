#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#include <execinfo.h>

void* buf[10000];

SEXP winch_trace_back() {
  int size = backtrace(buf, sizeof(buf) / sizeof(*buf));
  backtrace_symbols_fd(buf, size, 2);
  return R_NilValue;
}
