
#' Returns list of R installation paths.
#'
#' Given a vector of search paths, returns all instances of R installations.
#'
#'
#' @details
#' This function is a wrapper around \code{list.files} setting the search pattern to \code{Rscript.exe}.
#'
#' @param path Character vector of search paths. Passed to \code{\link{list.files}}
#' @param pattern regular expression.  Passed to \code{\link{list.files}}
#'
#' @export
findRscript <- function(path, pattern){
  foo <- function(path, pattern, recursive){
    message("Now searching ", path)
    list.files(path=path, pattern=pattern, full.names=TRUE, include.dirs=TRUE, recursive=recursive)
  }
  switch(Sys.info()[["sysname"]],
         Linux = {
           paths <- c(
             "/usr/lib64",
             "/usr/lib"
           )
           ret <- sapply(paths, foo, pattern="Rscript$", recursive=TRUE)
         },
         Windows = {
           paths <- c("c:/program files", "c:/program files (x86)", "c:/R", "c:/revolution")
           ret <- sapply(paths, foo, pattern="Rscript.exe$", recursive=TRUE)
         },{
           paths <- c(
             "/Library/Frameworks/"
           )
           ret <- sapply(paths, foo, pattern="Rscript.exe$", recursive=TRUE)
         }
  )
  unname(unlist(ret))
}
