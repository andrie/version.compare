# Copyright (c) 2015, Andrie de Vries
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# Combines results from Urbanek tests
urbanekCombine <- function(x){
  z <- do.call(cbind, x)
  z <- z[, order(colSums(z), decreasing = TRUE)]
  class(z) <- c("RevoBenchmark", "matrix")
  z
}


to.data.frame <- function(x){
  if(is.data.frame(x)) return(x)
  dat <- cbind(test = rownames(x), data.frame(as.matrix(x), stringsAsFactors = FALSE, check.names = FALSE))
  rownames(dat) <- seq_len(nrow(dat))
  dat
}

#' Computes urbanek performance improvement.
#'
#' @param x RevoBenchmark object
#' @export
urbanekPerformance <- function(x){
  # if(!is.data.frame(x)) x <- urbanekCombine(x)
  # 1 / (x / x[, 1]) - 1
  1 / (x / x[, 1])

}




#' Create plot of RevoBenchmark results.
#'
#' @inheritParams urbanekPerformance
#' @param ... Not used
#' @param theme_size Passed to \code{\link[ggplot2]{theme_bw}}.
#'
#' @import ggplot2
#' @importFrom reshape2 melt
#' @export
plot.RevoBenchmark <- function(x, theme_size=16, main = "Elapsed time in seconds", ...){
  dat <- to.data.frame(x)
  minmax <- if(ncol(dat) > 2){
    data.frame(
      test = dat[, "test"],
      min = apply(dat[, -1], 1, min),
      max = apply(dat[, -1], 1, max)
    )
  } else {
    data.frame(
      test = dat[, "test"],
      min = dat[, -1],
      max = dat[, -1]
    )

  }
  mdat <- reshape2::melt(dat, id.var = "test")
  ggplot2::ggplot(mdat, aes_string(x = "test")) +
    geom_linerange(data = minmax,
                   aes_string(ymin = "min", ymax = "max")
    ) +
    geom_crossbar(data = mdat,
                  aes_string(y = "value", ymin = "value", ymax = "value", col = "variable"),
                  size = 0.3
    ) +
    geom_point(data = mdat,
               aes_string(y = "value", col = "variable"),
               stat = "identity",
               size = 3
    ) +
    coord_flip() +
    xlab(NULL) +
    ylab(NULL) +
    ggtitle(main) +
    scale_color_discrete("R version") +
    theme_bw(theme_size)
}
