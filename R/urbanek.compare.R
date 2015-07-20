#' Runs Urbanek tests on multiple versions of R and compares results.
#'
#' @inheritParams version.compare
#' @inheritParams urbanek2.5
#'
#' @export
urbanek.compare <- function(rVersions, threads = 4, scale.factor = 1){
  tf <- tempfile(pattern = "urbanek-", fileext = ".r")
  code <- paste("urbanek2.5 <- ", paste(deparse(urbanek2.5), collapse = "\n"))
  fn <- sprintf("urbanek2.5(threads = %s, scale.factor = %s)", threads, scale.factor)
  code <- paste(code, fn, sep = "\n")
  write(code, file = tf)
  on.exit(unlink(tf))
  res <- version.time(rVersions, file = tf)
  res
}
