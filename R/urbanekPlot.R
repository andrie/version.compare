#' Combines results from Urbanek tests
#'
#' @param x The result of a call to \code{\link{urbanek2.5}}
#' @export
urbanekCombine <- function(x){
  do.call(cbind, x)
}


#' Converts Urbanek tests to data frame.
#'
#' @inheritParams urbanekCombine
#' @export
urbanek2df <- function(x){
  if(!is.data.frame(x)) x <- urbanekCombine(x)
  dat <- cbind(test = rownames(x), as.data.frame(x))
  rownames(dat) <- NULL
  dat
}

#' Computes urbanek performance improvement.
#'
#' @inheritParams urbanekCombine
#' @export
urbanekPerformance <- function(x){
  if(!is.data.frame(x)) x <- urbanekCombine(x)
  1 / (x / x[, 1]) - 1

}


#' Create plot of urbanek test results.
#'
#' @inheritParams urbanekCombine
#' @export
urbanekPlot <- function(x){
  dat <- urbanek2df(z[["results"]])
  mdat <- reshape2::melt(dat, id.var = "test")
  ggplot(mdat, aes(x = test, y = value, fill = variable)) +
    geom_bar(stat = "identity", position = "dodge") +
    coord_flip() +
    xlab(NULL) +
    ylab(NULL) +
    theme_bw(16)
}
