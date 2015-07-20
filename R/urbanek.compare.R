#' Runs Urbanek tests on multiple versions of R and compares results.
#'
#' @inheritParams version.time
#' @inheritParams urbanek2.5
#'
#' @export
urbanek.compare <- function(rVersions, threads = 4, scale.factor = 1){

  paste.deparse <- function(x, collapse = "\n") paste(deparse(x), collapse = collapse)

  tf <- tempfile(pattern = "urbanek-", fileext = ".r")
  code <- paste("urbanek2.5 <- ", paste.deparse(urbanek2.5))
  fn <- sprintf("urbanek2.5(threads = %s, scale.factor = %s)", paste.deparse(threads, collapse = " "), scale.factor)
  code <- paste(code, fn, sep = "\n")
  write(code, file = tf)
  on.exit(unlink(tf))
  version.time(rVersions, file = tf)
}
