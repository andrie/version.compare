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


# Searches windows registry for installed versions of R
findRinRegistry <- function(){
  readOnce <- function(ptn){
    x <- readRegistry(ptn, maxdepth = 3)
    if(length(x)){
      y <- unlist(x, recursive = TRUE)
      unname(y[grep(".InstallPath", names(y))])
    } else NULL
  }
  patterns <- c("SOFTWARE\\Revolution", "SOFTWARE\\R-core")
  unique(unname(unlist(sapply(patterns, readOnce))))
}



#' Returns list of R installation paths.
#'
#' Given a vector of search paths, returns all instances of R installations.
#'
#'
#' @details
#' This function is a wrapper around \code{list.files} setting the search pattern to \code{Rscript.exe}.
#'
#' @param path Character vector of search paths. Passed to \code{\link{list.files}}. If not specified (the default) then the search path contains typical installation paths for different operating systems.
#' @param executable Regular expression that defines the name of the Rscript executable. Defaults to a regular expression that finds \code{Rscript} on linux machines and \code{Rscript.exe} on Windows
#' @param pattern regular expression.  Passed to \code{\link{list.files}}
#' @param version Additional regular expression, e.g. "3.2.1" to limit the results list to a specific version of R
#'
#' @export
findRscript <- function(path, executable = "(Rscript$|Rscript.exe)", pattern, version){

  foo <- function(path, executable, recursive){
    # message("Now searching ", path)
    list.files(path=path, pattern=executable, full.names=TRUE, include.dirs=TRUE, recursive=recursive)
  }

  if(missing(path) || is.null(path)){
    path <- switch(Sys.info()[["sysname"]],
                   Linux = c("/usr/lib64", "/usr/lib"),
                   # Windows = c("c:/program files", "c:/program files (x86)", "c:/R", "c:/revolution", "c:/rro"),
                   Windows = sort(unique(dirname(findRinRegistry()))),
                   c("/Library/Frameworks/")
    )
  }

  if(missing(executable) || is.null(executable)){
    executable <- switch(Sys.info()[["sysname"]],
                      Linux = "Rscript$",
                      Windows = "Rscript.exe$",
                      "Rscript$"
    )
  }

  ret <- lapply(path, foo, executable=executable, recursive=TRUE)
  ret <- unname(unlist(ret))
  if(!missing("version") && !is.null(version)) ret <- ret[grepl(version, ret)]
  normalizePath(ret)
}
