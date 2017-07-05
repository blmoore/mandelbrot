#include <stdio.h>

/***********************************************************
 *  Function to evaluate a series of complex numbers that  *
 *  form a subset of the Argand plane, to see if           *
 *  they belong to the Mandelbrot set.                     *
 *  This function has been written with the intention of   *
 *  linking it to some R code in order to create a         *
 *  practical way to play with the set.                    *
 *                                                         *
 *  Written by Mario dos Reis. September 2003              *
 *                                                         *
 ***********************************************************/

void mandelbrot_(double *xcoo, double *ycoo, int *nx,
  int *ny, int *set, int *iter)

  /* 'xcoo' and 'ycoo' are the x and y coordinates respectively
   *  of all the points to be evaluated.
   * 'nx' and 'ny' number of divisions along the x and y axes
   * 'set' will store the practical output of the function
   * 'iter' is the maximun number of iterations
   */

{
  int i, j, k;
  double z[2], c[2], oldz[2];

  for(i = 0; i < *nx; i++) {

    for(j = 0; j < *ny; j++) {

      /* initialise the complex point to be tested
       * c[0] (or z[0]) is the real part
       * c[1] (or z[1]) is the imaginary part
       */
      c[0] = xcoo[i]; c[1] = ycoo[j];
      z[0] = 0;       z[1] = 0;

      for(k = 1; k < *iter + 1; k++) {

        oldz[0] = z[0]; oldz[1] = z[1];

        // the mandelbrot mapping z -> z^2 + c
        z[0] = oldz[0]*oldz[0] - oldz[1]*oldz[1] + c[0];
        z[1] = 2 * oldz[0]*oldz[1] + c[1];

        if((z[0]*z[0] + z[1]*z[1]) > 4) {
          break;
        }
      }

      /* fills the set vector
       * notice the trick 'i * (*ny) + j' to find
       * the appropiate position of the output in the
       * vector set. The R function will take care of
       * transforming this vector into a suitable matrix
       * for plotting, etc.
       */
      set[i * (*ny) + j] = k;
    }
  }
  return;
}

/* Alt interface to above that generates set data in
 * a more convenient shape for fast reformatting
 */
void mandelbrot_alt(double *xcoo, double *ycoo, int *nx,
  int *ny, int *set, int *iter)

{
  int i, j, k;
  double z[2], c[2], oldz[2];

  for(i = 0; i < *nx; i++) {

    for(j = 0; j < *ny; j++) {

      c[0] = xcoo[i]; c[1] = ycoo[j];
      z[0] = 0;       z[1] = 0;

      for(k = 1; k < *iter + 1; k++) {

        oldz[0] = z[0]; oldz[1] = z[1];

        // the mandelbrot mapping z -> z^2 + c
        z[0] = oldz[0]*oldz[0] - oldz[1]*oldz[1] + c[0];
        z[1] = 2 * oldz[0]*oldz[1] + c[1];

        if((z[0]*z[0] + z[1]*z[1]) > 4) {
          break;
        }
      }

      set[j * (*nx) + i] = k;
    }
  }
  return;
}

