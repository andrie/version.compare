#' Run script in different versions of R and capture system time.
#'
#' @param rVersions Character vector containing path to Rscript in different installations of R
#' @param expr Expression to evaluate
#' @param file If specified, evaluates the code in the file, rather than \code{expr}
#' @export
#'
#' @example \inst\examples\example_version.time.R
version.time <- function(rVersions, expr, file){
  match <- match.call()
  expr <- match$expr

  # capture system.time of original expression and write results to tempfile
  p0 <- "library('methods')"
  p1 <- "result <- local({"
  p2 <- "})
    tf <- normalizePath(tempfile(fileext = '.rds', tmpdir = dirname(tempdir())), mustWork = FALSE)
    saveRDS(result, file = tf)
    cat(tf)
  "
  scriptfile <- tempfile(fileext = ".R")
  on.exit(unlink(scriptfile))



  if(!missing("file") && !is.null(file)){
    tmp <- paste(readLines(file), collapse = "\n")
  } else {
    tmp <- paste(deparse(expr), collapse = "\n")
  }
  new.expr <- sprintf("%s\n%s\n%s\n%s", p0, p1, tmp, p2)

  # save new expression to file so it can be picked up by clean R session
  write(new.expr, file = scriptfile)

  # cat(readLines(scriptfile), sep = "\n")



  # run the actual script in each R version
  res <- lapply(rVersions, runWithRscript, testscriptPath = scriptfile)
  result.tempfiles = sapply(res, function(x)tail(x[["stdout"]], 1))
  mres <- list(
    time = lapply(res, function(x)x[["time"]]),
    stdout = lapply(res, function(x)head(x[["stdout"]], -1))
  )

  res <- NULL

  # retrieve results stored in tempfiles
  on.exit(unlink(result.tempfiles))
  mres[["version.results"]] <- lapply(result.tempfiles, readRDS)

  mres
}



runWithRscript <- function(rscriptPath, testscriptPath, message=TRUE){
  cmd <- paste(
    shQuote(rscriptPath),
    shQuote(testscriptPath)
  )
  if(message) message(rscriptPath)
  stdout <- NA
  time <- system.time({ stdout <- system(cmd, intern = TRUE) })
  list(time = time, stdout = stdout)
}


