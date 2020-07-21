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

SEXP winch_context() {
  return R_NilValue;
}
