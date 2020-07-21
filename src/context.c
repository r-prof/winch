#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>


#include <setjmp.h>


#ifdef HAVE_POSIX_SETJMP
# define JMP_BUF sigjmp_buf
#else
# define JMP_BUF jmp_buf
#endif

typedef struct {
  int tag;
  int flags;
  union {
    int ival;
    double dval;
    SEXP sxpval;
  } u;
} R_bcstack_t;

typedef struct RCNTXT {
  struct RCNTXT *nextcontext;	/* The next context up the chain */
  int callflag;		/* The context "type" */
  JMP_BUF cjmpbuf;		/* C stack and register information */
  int cstacktop;		/* Top of the pointer protection stack */
  int evaldepth;	        /* evaluation depth at inception */
  SEXP promargs;		/* Promises supplied to closure */
  SEXP callfun;		/* The closure called */
  SEXP sysparent;		/* environment the closure was called from */
  SEXP call;			/* The call that effected this context*/
  SEXP cloenv;		/* The environment */
  SEXP conexit;		/* Interpreted "on.exit" code */
  void (*cend)(void *);	/* C "on.exit" thunk */
  void *cenddata;		/* data for C "on.exit" thunk */
  void *vmax;		        /* top of R_alloc stack */
  int intsusp;                /* interrupts are suspended */
  int gcenabled;		/* R_GCEnabled value */
  int bcintactive;            /* R_BCIntActive value */
  SEXP bcbody;                /* R_BCbody value */
  void* bcpc;                 /* R_BCpc value */
  SEXP handlerstack;          /* condition handler stack */
  SEXP restartstack;          /* stack of available restarts */
  struct RPRSTACK *prstack;   /* stack of pending promises */
  R_bcstack_t *nodestack;
  R_bcstack_t *bcprottop;
  SEXP srcref;	        /* The source line in effect */
  int browserfinish;          /* should browser finish this context without
 stopping */
  SEXP returnValue;           /* only set during on.exit calls */
  struct RCNTXT *jumptarget;	/* target for a continuing jump */
  int jumpmask;               /* associated LONGJMP argument */
} RCNTXT;

extern RCNTXT* R_GlobalContext;

// Not exported
//extern SEXP R_findBCInterpreterSrcref(RCNTXT*);

SEXP winch_context() {
  R_xlen_t len = 0;

  for (RCNTXT* context = R_GlobalContext; context != context->nextcontext && context != NULL && context->callflag != 0; context = context->nextcontext) {
    ++len;
  }

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 5));
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 5));
  Rf_setAttrib(out, R_NamesSymbol, names);

  SEXP callfun = PROTECT(Rf_allocVector(VECSXP, len));
  SET_STRING_ELT(names, 0, Rf_mkChar("callfun"));
  SET_VECTOR_ELT(out, 0, callfun);

  SEXP sysparent = PROTECT(Rf_allocVector(VECSXP, len));
  SET_STRING_ELT(names, 1, Rf_mkChar("sysparent"));
  SET_VECTOR_ELT(out, 1, sysparent);

  SEXP call = PROTECT(Rf_allocVector(VECSXP, len));
  SET_STRING_ELT(names, 2, Rf_mkChar("call"));
  SET_VECTOR_ELT(out, 2, call);

  SEXP cloenv = PROTECT(Rf_allocVector(VECSXP, len));
  SET_STRING_ELT(names, 3, Rf_mkChar("cloenv"));
  SET_VECTOR_ELT(out, 3, cloenv);

  SEXP srcref = PROTECT(Rf_allocVector(VECSXP, len));
  SET_STRING_ELT(names, 4, Rf_mkChar("srcref"));
  SET_VECTOR_ELT(out, 4, srcref);

  RCNTXT* context = R_GlobalContext;
  for (R_xlen_t i = 0; i < len; context = context->nextcontext, ++i) {
    SET_VECTOR_ELT(callfun, i, context->callfun);
    SET_VECTOR_ELT(sysparent, i, context->sysparent);
    SET_VECTOR_ELT(call, i, context->call);
    SET_VECTOR_ELT(cloenv, i, context->cloenv);

    SEXP current_srcref = context->srcref;
    if (current_srcref == R_InBCInterpreter) {
      // not exported
      //current_srcref = R_findBCInterpreterSrcref(context);
    }

    SET_VECTOR_ELT(srcref, i, current_srcref);
  }

  UNPROTECT(5 + 2);
  return out;
}
