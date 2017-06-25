#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
 Check these declarations against the C/Fortran source code.
 */

/* .C calls */
extern void mandelbrot_(void *, void *, void *, void *, void *, void *);
extern void mandelbrot_alt(void *, void *, void *, void *, void *, void *);

static const R_CMethodDef CEntries[] = {
  {"mandelbrot_",    (DL_FUNC) &mandelbrot_,    6},
  {"mandelbrot_alt", (DL_FUNC) &mandelbrot_alt, 6},
  {NULL, NULL, 0}
};

void R_init_mandelbrot(DllInfo *dll)
{
  R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
