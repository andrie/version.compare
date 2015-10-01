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
  mres[["results"]] <- lapply(result.tempfiles, readRDS)

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


