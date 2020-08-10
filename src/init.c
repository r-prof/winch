#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

// Compile with `-fvisibility=hidden -DHAVE_VISIBILITY_ATTRIBUTE` if you link to this library
#include <R_ext/Visibility.h>
#define export attribute_visible extern

extern SEXP winch_trace_back();
extern SEXP winch_call(SEXP function, SEXP env);
extern SEXP winch_context();
extern SEXP winch_stop(SEXP message);
extern SEXP winch_get_proc_map();

static const R_CallMethodDef CallEntries[] = {
  {"winch_c_trace_back",                   (DL_FUNC) &winch_trace_back, 0},
  {"winch_c_call",                         (DL_FUNC) &winch_call, 2},
  {"winch_c_context",                      (DL_FUNC) &winch_context, 0},
  {"winch_c_stop",                         (DL_FUNC) &winch_stop, 1},
  {"winch_c_get_proc_map",                 (DL_FUNC) &winch_get_proc_map, 0},

  {NULL, NULL, 0}
};

export void R_init_winch(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
