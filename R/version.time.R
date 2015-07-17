#' Run script in different versions of R and capture system time.
#'
#' @param expr Expression
#' @param rVersions Character vector containing path to Rscript in different installations of R
#' @export
#'
#' @example \inst\examples\example_version.time.R
version.time <- function(rVersions, expr){
  match <- match.call()
  expr <- match$expr

  scriptfile <- tempfile(fileext = ".R")
  on.exit(unlink(scriptfile))

  # capture system.time of original expression and write results to tempfile
  p1 <- "time <- system.time(result <- local("
  p2 <- "))
    tf <- tempfile(fileext = '.rds', tmpdir = dirname(tempdir()))
    saveRDS(result, file = tf)
    cat(tf)
  "
  new.expr <- sprintf("%s%s%s", p1, paste(deparse(expr), collapse = "\n"), p2)

  # save new expression to file so it can be picked up by clean R session
  write(new.expr, file = scriptfile)

  # run the actual script in each R version
  res <- lapply(rVersions, runWithRscript, testscriptPath = scriptfile)

  # retrieve results stored in tempfiles
  result.tempfiles <- sapply(res, function(x)tail(x$stdout, 1))
  on.exit(unlink(result.tempfiles))
  version.results <- lapply(result.tempfiles, readRDS)

  # append script results to each component
  for(i in seq_along(result.tempfiles)){
    res[[i]]$results <- version.results[[i]]
    res[[i]]$stdout <- head(res[[i]]$stdout, -1)
  }
  res
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


