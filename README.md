<!-- README.md is generated from README.Rmd. Please edit that file -->
mandelbrot
==========

Probably you just want to draw pretty pictures.

Install with:

``` r
devtools::install_github("blmoore/mandelbrot")
```

Examples
--------

``` r
library(mandelbrot)

mb <- mandelbrot()
plot(mb)
```

![](README-b_n_w-1.png)

Trippy colours

``` r
mb <- mandelbrot(xlim = c(-0.8438146, -0.8226294),
                 ylim = c(0.1963144, 0.2174996), 
                 iterations = 500)

cols <- mandelbrot_palette(RColorBrewer::brewer.pal(11, "Spectral"))
plot(mb, col = cols)
```

![](README-trip-1.png)

Credits
-------

Straight wrapping of R / C code by Mario dos Reis.
