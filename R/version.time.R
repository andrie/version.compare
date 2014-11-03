#' Run script in different versions of R and capture system time.
#'
#' @param expr Expression
#' @param rVersions Character vector containing path to Rscript in different installations of R
#' @export
#'
#' @example \inst\examples\example_version.time.R
version.time <- function(expr, rVersions){
  scriptfile <- tempfile(fileext = ".R")
  on.exit(unlink(scriptfile))
  write(paste(deparse(expr)), file=scriptfile)
  lapply(rVersions, runWithRscript, testscriptPath = scriptfile)
}



runWithRscript <- function(rscriptPath, testscriptPath, message=TRUE){
  cmd <- paste(
    shQuote(rscriptPath),
    shQuote(testscriptPath)
  )
  if(message) message(rscriptPath)
  time <- system.time({ result <- system(cmd) })
  list(time = time, result = result)
}


