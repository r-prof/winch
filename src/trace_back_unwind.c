#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#ifdef HAVE_LIBUNWIND

#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define UNW_LOCAL_ONLY
#include <libunwind.h>

void* buf[10000];

SEXP winch_trace_back_unwind(void) {
  unw_context_t uc;
  memset(&uc, 0, sizeof(uc));

  int unw;
  unw = unw_getcontext(&uc);
  if (unw != 0) Rf_error("unw_getcontext() error: %d", unw);

  unw_cursor_t cursor;
  memset(&cursor, 0, sizeof(cursor));
  unw = unw_init_local(&cursor, &uc);
  if (unw != 0) Rf_error("unw_init_local() error: %d", unw);

  // Two less: ignore our call
  const int size_base = 1 - 2;

  R_xlen_t size = size_base;
  for (unw_cursor_t cursor1 = cursor; ; ++size) {
    unw = unw_step(&cursor1);
    if (unw == 0) {
      break;
    }
    if (unw < 0) Rf_error("unw_step() error: %d", unw);
  }

  if (size < 0) {
    size = 0;
  }

  SEXP out_name = PROTECT(Rf_allocVector(STRSXP, size));
  SEXP out_ip = PROTECT(Rf_allocVector(STRSXP, size));

  R_xlen_t i = size_base;
  // Use another copy of cursor to pacify valgrind
  for (unw_cursor_t cursor2 = cursor; ; ++i) {
    unw = unw_step(&cursor2);
    if (unw == 0) {
      break;
    }
    if (unw < 0) Rf_error("unw_step() error: %d", unw);

    if (i < 0) continue;

    unw_proc_info_t pi;
    unw = unw_get_proc_info(&cursor2, &pi);
    if (unw != 0) Rf_error("unw_get_proc_info() error: %d", unw);

    char buf[1000];
    unw_word_t off;
    unw = unw_get_proc_name(&cursor2, buf, sizeof(buf) / sizeof(*buf), &off);
    if (unw != 0 && unw != -UNW_ENOMEM) {
      snprintf(buf, sizeof(buf) / sizeof(*buf), "<unw_get_proc_name() error: %d>", unw);
    }
    buf[sizeof(buf) / sizeof(*buf) - 1] = '\0';

    SET_STRING_ELT(out_name, i, Rf_mkCharCE(buf, CE_UTF8));

    char ip_buf[33];
    snprintf(ip_buf, 33, "%.16" PRIxPTR, pi.start_ip);
    //snprintf(ip_buf, sizeof(ip_buf) / sizeof(buf), "%p", (void*)pi.start_ip);
    ip_buf[sizeof(ip_buf) / sizeof(*ip_buf) - 1] = '\0';
    SET_STRING_ELT(out_ip, i, Rf_mkCharCE(ip_buf, CE_UTF8));
  }

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
  SET_VECTOR_ELT(out, 0, out_name);
  SET_VECTOR_ELT(out, 1, out_ip);

  // FIXME: Mimic ExtractSymbols() from gperftools -- use or rebuild addr2line

  UNPROTECT(3);
  return out;
}

#else // #ifdef HAVE_LIBUNWIND

SEXP winch_trace_back_unwind(void) {
  Rf_error("libunwind not supported on this platform.");
}

#endif // #ifdef HAVE_LIBUNWIND
