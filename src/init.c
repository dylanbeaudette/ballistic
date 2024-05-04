#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .Call calls */
extern SEXP bsim_C(SEXP s, SEXP bc, SEXP df, SEXP v, SEXP sh, SEXP angle, SEXP zero, SEXP windspeed, SEXP windangle);

static const R_CallMethodDef CallEntries[] = {
  {"bsim_C", (DL_FUNC) &bsim_C, 1},
  {NULL, NULL, 0}
};

void R_init_addr(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}


