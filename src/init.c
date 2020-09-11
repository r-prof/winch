#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

// Compile with `-fvisibility=hidden -DHAVE_VISIBILITY_ATTRIBUTE` if you link to this library
#include <R_ext/Visibility.h>
#define export attribute_visible extern

extern SEXP winch_init_library();
extern SEXP winch_trace_back();
extern SEXP winch_trace_back_default_method();
extern SEXP winch_call(SEXP function, SEXP env);
extern SEXP winch_context();
extern SEXP winch_stop(SEXP message);

static const R_CallMethodDef CallEntries[] = {
  {"winch_c_init_library",                 (DL_FUNC) &winch_init_library, 2},
  {"winch_c_trace_back",                   (DL_FUNC) &winch_trace_back, 1},
  {"winch_c_trace_back_default_method",    (DL_FUNC) &winch_trace_back_default_method},
  {"winch_c_call",                         (DL_FUNC) &winch_call, 2},
  {"winch_c_context",                      (DL_FUNC) &winch_context, 0},
  {"winch_c_stop",                         (DL_FUNC) &winch_stop, 1},

  {NULL, NULL, 0}
};

extern SEXP init_backtrace(const char* argv0, int force);

export void R_init_winch(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}

SEXP winch_init_library(SEXP argv0, SEXP force) {
  const char* c_argv0 = CHAR(STRING_ELT(argv0, 0));
  int c_force = INTEGER(force)[0];
  return init_backtrace(c_argv0, c_force);
}
