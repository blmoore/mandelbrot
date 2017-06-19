#######################################################################

#' Calculate the Mandelbrot set
#'
#' Generates a view on the Mandelbrot set
#' using an underlying C function
#'
#' Original code by Mario dos Reis, September 2003.
#'
#' @param xlim limits of x axis (real part)
#' @param ylim limits of y axis (imaginary part)
#' @param x_res resolution in x
#' @param y_res resolution in y
#' @param iterations maximum number of iterations to
#'   evaluate each case
#'
#' @author Mario dos Reis
#'
#' @references \url{http://people.cryst.bbk.ac.uk/~fdosr01/Rfractals/index.html}
#'
#' @useDynLib mandelbrot mandelbrot_
#'
#' @export
mandelbrot <- function(xlim = c(-3, 1), ylim = c(-1.8, 1.8),
  x_res = 600, y_res = 600, iterations = 20) {

  if(is.list(xlim)) {
    ylim <- range(xlim$y)
    xlim <- range(xlim$x)
  }

  if (!is.numeric(xlim) | !is.numeric(ylim)) {
    stop("xlim and ylim must be numeric")
  }

  x_coord <- seq(xlim[1], xlim[2], len = x_res)
  y_coord <- seq(ylim[1], ylim[2], len = y_res)
  set <- numeric(x_res * y_res)

  # This is the call to the C function itself
  this_set <- .C("mandelbrot_",
    xcoo = as.double(x_coord),
    ycoo = as.double(y_coord),
    nx = as.integer(x_res),
    ny = as.integer(y_res),
    set = as.integer(set),
    iter = as.integer(iterations))$set

  # Create a list with elements x, y and z,
  # suitable for image(), persp(), etc. and return it.
  structure(
    list(x = x_coord, y = y_coord,
      z = matrix(this_set, ncol = y_res, byrow = T)
    ),
    class = "mandelbrot"
  )
}
