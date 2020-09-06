#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#include <backtrace.h>

extern void* backtrace_state;

void cb_error(void* data, const char *msg, int errnum) {
  Rf_error("libbacktrace: %d: %s", errnum, msg);
}

int cb_increment_size(void *data, uintptr_t pc,
                      const char *filename, int lineno,
                      const char *function) {
  R_xlen_t* size = (R_xlen_t*)data;
  ++*size;
  return 0;
}

typedef struct {
  SEXP out;
  R_xlen_t pos;
} cb_get_name_ip_t;

void cb_get_name_from_syminfo(void *data, uintptr_t pc,
                              const char *symname,
                              uintptr_t symval,
                              uintptr_t symsize) {
  cb_get_name_ip_t* cb_data = (cb_get_name_ip_t*)data;

  SEXP out = cb_data->out;
  SEXP out_name = VECTOR_ELT(out, 0);

  R_xlen_t pos = cb_data->pos;

  fprintf(stderr, "pc: %lx\n", pc);
  fprintf(stderr, "symname: %lx\n", symval);

  if (symname != NULL) {
    SET_STRING_ELT(out_name, pos, Rf_mkCharCE(symname, CE_UTF8));
  }
}

void cb_ignore_name_from_syminfo(void* data, const char *msg, int errnum) {
  cb_get_name_ip_t* cb_data = (cb_get_name_ip_t*)data;

  SEXP out = cb_data->out;
  SEXP out_name = VECTOR_ELT(out, 0);

  R_xlen_t pos = cb_data->pos;

  SET_STRING_ELT(out_name, pos, NA_STRING);
}

int cb_get_name_ip(void *data, uintptr_t pc,
                   const char *filename, int lineno,
                   const char *function) {

  cb_get_name_ip_t* cb_data = (cb_get_name_ip_t*)data;

  SEXP out = cb_data->out;
  SEXP out_name = VECTOR_ELT(out, 0);
  SEXP out_ip = VECTOR_ELT(out, 1);

  R_xlen_t pos = cb_data->pos;

  if (function != NULL) {
    SET_STRING_ELT(out_name, pos, Rf_mkCharCE(function, CE_UTF8));
  } else {
    fprintf(stderr, "pc in: %lx\n", pc);
    backtrace_syminfo(
      backtrace_state, pc,
      cb_get_name_from_syminfo, cb_ignore_name_from_syminfo, data
    );
  }

  char ip_buf[33];
  sprintf(ip_buf, "%.16" PRIx64, pc);
  //snprintf(ip_buf, sizeof(ip_buf) / sizeof(buf), "%p", (void*)pi.start_ip);
  ip_buf[sizeof(ip_buf) / sizeof(*ip_buf) - 1] = '\0';
  SET_STRING_ELT(out_ip, pos, Rf_mkCharCE(ip_buf, CE_UTF8));

  ++cb_data->pos;
  return 0;
}

SEXP winch_trace_back_backtrace() {
  backtrace_print(backtrace_state, 1, stderr);

  R_xlen_t size = 0;
  backtrace_full(backtrace_state, 1, cb_increment_size, cb_error, &size);

  SEXP out_name = PROTECT(Rf_allocVector(STRSXP, size));
  SEXP out_ip = PROTECT(Rf_allocVector(STRSXP, size));
  SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
  SET_VECTOR_ELT(out, 0, out_name);
  SET_VECTOR_ELT(out, 1, out_ip);

  cb_get_name_ip_t data;
  data.out = out;
  data.pos = 0;

  backtrace_full(backtrace_state, 1, cb_get_name_ip, cb_error, &data);

  UNPROTECT(3);
  return out;
}
