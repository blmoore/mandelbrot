
#' Generate palette suitable for coloring a set
#'
#' Takes a simple palette and expands / oscillates
#' it for use with Mandelbrot sets.
#'
#' @examples
#' view <- mandelbrot(xlim = c(-0.8438146, -0.8226294),
#'   ylim = c(0.1963144, 0.2174996), iter = 500)
#'
#' blues <- RColorBrewer::brewer.pal(9, "Blues")
#' cols <- mandelbrot_palette(blues, in_set = "white")
#' image(log(view$z), col = cols, axes = FALSE)
#'
#' spectral <- RColorBrewer::brewer.pal(11, "Spectral")
#' cols <- mandelbrot_palette(spectral)
#' image(-1/view$z, col = cols, axes = FALSE)
#'
#' @export
mandelbrot_palette <- function(palette, in_set = "black") {
  if (length(palette) < 50) {
    palette <- colorRampPalette(palette)(50)
  }
  c(rep(c(palette, rev(palette)), 2), in_set)
}

#' Plot a Mandelbrot set using base graphics
#'
#' Draws coloured set membership using \code{image}.
#'
#' @param mandelbrot
#'
#' @export
plot.mandelbrot <- function(mandelbrot,
  col = mandelbrot_palette(c("white", grey.colors(50))),
  transform = c("none", "inverse", "log")) {

  transform <- match.arg(transform)
  old_par <- par()

  par(mar = rep(1, 4))

  if (transform != "none") {
    if (transform == "inverse") {
      mandelbrot$z <- 1/mandelbrot$z
    } else {
      if (transform == "log") {
        mandelbrot$z <- log(mandelbrot$z)
      } else {
        stop("transform not recognised: ", transform)
      }
    }
  }

  image(mandelbrot, col = col, axes = FALSE)

  par <- old_par
}


#' Convert Mandelbrot object to data.frame for plotting
#'
#' Converts objects produced by \code{\link[mandelbrot]{mandelbrot}}
#' to tidy data.frames for use with ggplot and other tidyverse packages.
#'
#' @param mandelbrot a Mandelbrot set object produced by \code{\link[mandelbrot]{mandelbrot}}
#'
#' @return a 3-column \code{data.frame}
#'
#' @examples
#'
#' mb <- mandelbrot()
#' df <- as.data.frame(mb)
#' head(df)
#'
#' @export
as.data.frame.mandelbrot <- function(mandelbrot) {
  df <- reshape2::melt(mandelbrot$z)
  df$x <- mandelbrot$x[df$Var1]
  df$y <- mandelbrot$y[df$Var2]
  df[,c("x", "y", "value")]
}



