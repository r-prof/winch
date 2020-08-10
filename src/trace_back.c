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

  unw_proc_info_t pi;
  unw = unw_get_proc_info(&cursor, &pi);
  if (unw != 0) Rf_error("unw_get_proc_info() error: %d", unw);

  char buf[1000];
  unw_word_t off;
  unw = unw_get_proc_name(&cursor, buf, sizeof(buf) / sizeof(*buf), &off);
  buf[sizeof(buf) / sizeof(*buf) - 1] = '\0';
  if (unw != 0 && unw != -UNW_ENOMEM) Rf_error("unw_get_proc_name() error: %d", unw);

  int size = 1;

  // One less: ignore our call
  SEXP out_name = PROTECT(Rf_allocVector(STRSXP, size));
  SET_STRING_ELT(out_name, 0, Rf_mkCharCE(buf, CE_UTF8));

  SEXP out_ip = PROTECT(Rf_allocVector(STRSXP, size));
  char ip_buf[20];
  sprintf(ip_buf, "%.16lx", pi.start_ip);
  //snprintf(ip_buf, sizeof(ip_buf) / sizeof(buf), "%p", (void*)pi.start_ip);
  ip_buf[sizeof(ip_buf) / sizeof(*ip_buf) - 1] = '\0';
  SET_STRING_ELT(out_ip, 0, Rf_mkCharCE(ip_buf, CE_UTF8));

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
  SET_VECTOR_ELT(out, 0, out_name);
  SET_VECTOR_ELT(out, 1, out_ip);

  // FIXME: Read /proc/self/maps, map IP to library

  // FIXME: Mimic ExtractSymbols() from gperftools -- use or rebuild addr2line

  UNPROTECT(3);
  return out;
}
