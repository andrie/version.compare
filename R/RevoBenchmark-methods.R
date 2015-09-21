# Combines results from Urbanek tests
urbanekCombine <- function(x){
  z <- do.call(cbind, x)
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
  1 / (x / x[, 1]) - 1

}




#' Create plot of urbanek test results.
#'
#' @inheritParams urbanekPerformance
#' @param ... Not used
#'
#' @import ggplot2
#' @importFrom reshape2 melt
#' @export
plot.RevoBenchmark <- function(x, ...){
  dat <- to.data.frame(x)
  mdat <- reshape2::melt(dat, id.var = "test")
  ggplot2::ggplot(mdat, aes_string(x = "test", y = "value", fill = "variable")) +
    geom_bar(stat = "identity", position = "dodge") +
    coord_flip() +
    xlab(NULL) +
    ylab(NULL) +
    ggtitle("Elapsed time in seconds") +
    scale_fill_brewer("R version") +
    theme_bw(16)
}
