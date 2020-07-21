#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#define UNW_LOCAL_ONLY
#include <libunwind.h>

void* buf[10000];

SEXP winch_trace_back() {
  unw_context_t uc;

  int unw;
  unw = unw_getcontext(&uc);
  if (unw != 0) Rf_error("unw_getcontext() error: %d", unw);

  unw_cursor_t cursor;
  unw = unw_init_local(&cursor, &uc);
  if (unw != 0) Rf_error("unw_init_local() error: %d", unw);

  char buf[1000];
  unw_word_t off;
  unw = unw_get_proc_name(&cursor, buf, sizeof(buf) / sizeof(*buf), &off);
  buf[sizeof(buf) / sizeof(*buf) - 1] = '\0';
  if (unw != 0 && unw != -UNW_ENOMEM) Rf_error("unw_get_proc_name() error: %d", unw);

  int size = 1;

  // One less: ignore our call
  SEXP out = PROTECT(Rf_allocVector(STRSXP, size - 1));

  SET_STRING_ELT(out, 0, Rf_mkCharCE(buf, CE_UTF8));

  UNPROTECT(1);
  return out;
}
