#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#include <backtrace.h>

extern void* backtrace_state;

SEXP winch_trace_back_backtrace() {
  backtrace_print(backtrace_state, 0, stderr);
  return R_NilValue;
}
