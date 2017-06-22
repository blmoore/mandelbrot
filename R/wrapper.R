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
#' @param resolution either an integer \eqn{n} for \eqn{n^2} pixels
#'   or a list with x and y components specifying the resolution
#'   in each direction (e.g. \code{list(x = 500, y = 500)})
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
  resolution = 600, iterations = 50) {

  if (is.list(xlim)) {
    ylim <- range(xlim$y)
    xlim <- range(xlim$x)
  }

  if (is.list(resolution)) {
    if (!length(resolution) == 2 | !c("x", "y") %in% names(resolution)) {
      stop("resolution should be a named list, e.g. list(x = 500, y = 500)")
    } else {
      x_res <- resolution$x
      y_res <- resolution$y
    }
  } else {
    if (is.numeric(resolution) & length(resolution) == 1) {
      resolution <- as.integer(resolution)
      x_res <- resolution
      y_res <- resolution
    } else {
      stop("resolution should be an integer, not ", resolution)
    }
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
