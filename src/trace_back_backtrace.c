#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#ifdef HAVE_LIBBACKTRACE

#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#include <backtrace.h>
#include "build/libbacktrace/config.h"

void *backtrace_state;

static void backtrace_error_callback_full(void *vdata, const char *msg, int errnum) {
  Rf_error("backtrace failed: %s", msg);
}

#ifdef BACKTRACE_ELF_SIZE
const int init_backtrace_return = 0;
#else
const int init_backtrace_return = 1;
#endif

SEXP init_backtrace(const char* argv0, int force) {
#ifdef BACKTRACE_ELF_SIZE
  if (!force) {
    Rf_ScalarLogical(init_backtrace_return);
  }
#endif

  backtrace_state = backtrace_create_state(
    argv0, 0, backtrace_error_callback_full, NULL
  );
  return Rf_ScalarLogical(init_backtrace_return);
}

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

  if (symname != NULL) {
    SET_STRING_ELT(out_name, pos, Rf_mkCharCE(symname, CE_UTF8));
  }
}

void cb_ignore_name_from_syminfo(void* data, const char *msg, int errnum) {
}

int cb_get_name_ip(void *data, uintptr_t pc,
                   const char *filename, int lineno,
                   const char *function) {

  cb_get_name_ip_t* cb_data = (cb_get_name_ip_t*)data;

  SEXP out = cb_data->out;
  SEXP out_name = VECTOR_ELT(out, 0);
  SEXP out_ip = VECTOR_ELT(out, 1);

  R_xlen_t pos = cb_data->pos;

  char ip_buf[33];
  // Workaround for MINGW UCRT problems:
  snprintf(
    ip_buf,
    33,
    "%.8" PRIx32 "%.8" PRIx32,
    (uint32_t)((uint64_t)pc / 0x100000000),
    (uint32_t)((uint64_t)pc % 0x100000000)
  );
  ip_buf[sizeof(ip_buf) / sizeof(*ip_buf) - 1] = '\0';
  SEXP chr_ip = Rf_mkCharCE(ip_buf, CE_UTF8);
  SET_STRING_ELT(out_ip, pos, chr_ip);

  if (function != NULL) {
    SET_STRING_ELT(out_name, pos, Rf_mkCharCE(function, CE_UTF8));
  } else {
    // Default: string representation of IP
    SET_STRING_ELT(out_name, pos, chr_ip);

    // Best effort
    backtrace_syminfo(
      backtrace_state, pc,
      cb_get_name_from_syminfo, cb_ignore_name_from_syminfo, data
    );
  }

  ++cb_data->pos;
  return 0;
}

SEXP winch_trace_back_backtrace(void) {
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

#else // #ifdef HAVE_LIBBACKTRACE

SEXP init_backtrace(const char* argv0, int force) {
  return R_NilValue;
}

SEXP winch_trace_back_backtrace() {
  Rf_error("libbacktrace not supported on this platform.");
}

#endif // #ifdef HAVE_LIBBACKTRACE
