
#' Generate palette suitable for coloring a set
#'
#' Takes a simple palette and expands / oscillates
#' it for use with Mandelbrot sets.
#'
#' @examples
#' blues <- RColorBrewer::brewer.pal("Blues", 9)
#' cols <- mandelbrot_palette(blues, in_set = "grey70")
#'
#' spectral <- RColorBrewer::brewer.pal("Spectral", 11)
#' cols <- mandelbrot_palette(spectral)
#'
#' view <- mandelbrot(x = c(-0.8438146, -0.8226294),
#'   y = c(0.1963144, 0.2174996), iter = 500)
#' image(-1/frac$z, col = spectral)
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
#' @export
plot.mandelbrot <- function(mandelbrot,
  col = mandelbrot_palette(c("white", grey.colors(50))),
  transform = c("none", "inverse", "log")) {

  transform <- match.arg(transform)
  old_par <- par()

  par(mar = rep(1, 4))

  image(mandelbrot, col = col, axes = FALSE)

  par <- old_par
}
