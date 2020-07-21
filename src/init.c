#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

// Compile with `-fvisibility=hidden -DHAVE_VISIBILITY_ATTRIBUTE` if you link to this library
#include <R_ext/Visibility.h>
#define export attribute_visible extern

extern SEXP winch_trace_back();

static const R_CallMethodDef CallEntries[] = {
  {"winch_trace_back",                   (DL_FUNC) &winch_trace_back, 0},

  {NULL, NULL, 0}
};

export void R_init_winch(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
