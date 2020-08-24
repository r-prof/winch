#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#include <backtrace.h>

void* buf[10000];

extern void* backtrace_state;

SEXP winch_trace_back() {
  backtrace_print(backtrace_state, 0, stderr);
  return R_NilValue;
}
