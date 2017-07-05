
#' Calculate the Mandelbrot set
#'
#' Generates a view on the Mandelbrot set
#' using an underlying C function.
#'
#' \code{mandelbrot0} is an experimental interface
#' for generating tidy data.frames faster than
#' \code{as.data.frame(mandelbrot())}.
#'
#' @section Mandelbrot set:
#' In brief, the Mandelbrot set contains the complex numbers
#' where the 0 orbit of the following function remains
#' bounded (\eqn{<2}):
#' \deqn{f_{z+1} = z^2 + c}
#'
#' For information and discussion on the Mandelbrot and
#' related sets, one great resource is
#' \href{https://plus.maths.org/content/unveiling-mandelbrot-set}{plus.maths.org}.
#' There's also a popular
#' \href{https://www.youtube.com/watch?v=NGMRB4O922I}{YouTube video by Numberphile}.
#'
#' @section Credits:
#' Wraps original C code by Mario dos Reis, September 2003.
#'
#' @param xlim limits of x axis (real part)
#' @param ylim limits of y axis (imaginary part)
#' @param resolution either an integer \eqn{n} for \eqn{n^2} pixels
#'   or a list with x and y components specifying the resolution
#'   in each direction (e.g. \code{list(x = 500, y = 500)})
#' @param iterations maximum number of iterations to
#'   evaluate each case
#'
#' @return a \code{mandelbrot} structure with components: \code{x} a vector
#'   of the real parts of the x-axis; \code{y} the imaginary parts of each
#'   number (the y-axis); \code{z} a matrix of the number of iterations that
#'   \eqn{|z|<2}
#'
#' @references
#'   \url{https://stat.ethz.ch/pipermail/r-help/2003-October/039773.html}
#'   \url{http://people.cryst.bbk.ac.uk/~fdosr01/Rfractals/index.html}
#'
#' @useDynLib mandelbrot mandelbrot_
#'
#' @export
mandelbrot <- function(xlim = c(-2, 2), ylim = c(-2, 2),
  resolution = 600, iterations = 50) {

  if (is.list(xlim)) {
    ylim <- range(xlim$y)
    xlim <- range(xlim$x)
  }

  if (is.list(resolution)) {
    if (!length(resolution) == 2 | !all(c("x", "y") %in% names(resolution))) {
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
    class = c("mandelbrot", "list")
  )
}

#' @rdname mandelbrot
#'
#' @useDynLib mandelbrot mandelbrot_alt
#'
#' @export
mandelbrot0 <- function(xlim = c(-2, 2), ylim = c(-2, 2),
  resolution = 600, iterations = 50) {

  if (is.list(xlim)) {
    ylim <- range(xlim$y)
    xlim <- range(xlim$x)
  }

  if (is.list(resolution)) {
    stop("mandelbrot0 only works equal x / y resolutions, use mandelbrot() instead")
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
  this_set <- .C("mandelbrot_alt",
    xcoo = as.double(x_coord),
    ycoo = as.double(y_coord),
    nx = as.integer(x_res),
    ny = as.integer(y_res),
    set = as.integer(set),
    iter = as.integer(iterations))$set

  df <- data.frame(expand.grid(x_coord, y_coord), this_set)
  colnames(df) <- c("x", "y", "value")
  df
}
