#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

int FillProcSelfMaps(char buf[], int size, int* wrote_all);

SEXP winch_get_proc_map() {
  const R_xlen_t SIZE = 1 << 20;

  SEXP buf = PROTECT(Rf_allocVector(RAWSXP, SIZE));
  char* p_buf = (char*)(void*)RAW(buf);

  int wrote_all = 0;

  R_xlen_t bytes_written = FillProcSelfMaps(p_buf, SIZE, &wrote_all);

  // FIXME: Support this case
  if (!wrote_all) Rf_error("winch_get_proc_map(): Buffer too small");

  R_xlen_t n_out = 0;
  for (R_xlen_t i = 0; i < bytes_written; ++i) {
    if (p_buf[i] == '\n') {
      ++n_out;
    }
  }

  SEXP out = PROTECT(Rf_allocVector(STRSXP, n_out));

  R_xlen_t i = 0;
  for (R_xlen_t i_out = 0; i_out < n_out; ++i_out) {
    R_xlen_t len = 0;
    for (len = 0; p_buf[i + len] != '\n'; ++len)
      ;
    SET_STRING_ELT(out, i_out, Rf_mkCharLen(p_buf + i, len));
    i += len + 1;
  }

  UNPROTECT(2);
  return out;
}
