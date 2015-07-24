# Set MKL threads if Revolution R Open or Revolution R Enterprise is available


#' Returns the system time for a modified version of the Urbanek benchmarks.
#'
#' @param threads Number of Intel MKL threads to use if availalbe. Tests for the presence of the packages \code{RevoUtilsMath} or \code{RevoBase} and sets the number of threads using \code{RevoUtilsMath::setMKLthreads}
#' @param show.message If TRUE, shows interim results as console messages
#' @param scale.factor A numeric value that scales the size of the data up or down. The default value of 1 has data sizes that yields a runtime of ~2 seconds per test on an 8-core machine with the MKL available.  For quick and easy testing, reduce the \code{scale.factor} to less than 1. (The primary use case for low \code{scale.factor} is to reduce the unit testing time when testing the package itself on CRAN.) To scale out the test data, use \code{scale.factor} of greater than 1.
#'
#' @export
#' @importFrom MASS lda
RevoBenchmark <- function(threads = 4, show.message = TRUE, scale.factor = 1){

  getMKLthreads <- setMKLthreads <- NULL # Trick to pass R CMD check

  rescale <- function(x){
    round(x * sqrt(scale.factor))
  }



  runUrbanek <- function(threads){
    # if(requireNamespace("RevoUtilsMath", quietly = TRUE) || requireNamespace("RevoBase", quietly = TRUE)){
    # if("RevoUtilsMath" %in% available.packages()[, "Package"]){
    if("package:RevoUtilsMath" %in% search()){
      oldThreads <- getMKLthreads()
      setMKLthreads(threads)
      on.exit(setMKLthreads(oldThreads))
    }

    test.names <- c("Matrix multiplication",
                    "Cholesky factorization",
                    "QR decomposition",
                    "Singular value decomposition",
                    "Principal component analysis",
                    "Linear discriminant analysis")
    elapsed.time <- rep(NA, length(test.names))
    names(elapsed.time) <- test.names

    mssg <- function(i, message = show.message){
      if(message){
        msg <- paste(
          format(test.names[i], width = max(nchar(test.names)) + 3),
          format(elapsed.time[i], signif = 5, width = 7),
          sep = ": "
        )
        message(msg)
      }
    }

    if(show.message) message("\nThreads:", threads)


    # Initialization

    set.seed (1)
    m <- rescale(10000)
    n <-  rescale(5000)
    A <- matrix (runif (m*n),m,n)

    # Matrix multiply
    elapsed.time[1] <- system.time (B <- crossprod(A))[3]
    mssg(1)

    # Cholesky Factorization
    elapsed.time[2] <- system.time (C <- chol(B))[3]
    mssg(2)

    # QR decomposition
    m <- rescale(5000)
    n <-  rescale(1000)
    Q <- matrix (runif (m*n),m,n)
    elapsed.time[3] <- system.time( qr(Q) )[3]
    mssg(3)


    # Singular Value Decomposition
    m <- rescale(10000)
    n <- rescale(2000)
    A <- matrix (runif (m*n), m, n)
    elapsed.time[4] <- system.time (S <- svd (A,nu=0,nv=0))[3]
    mssg(4)

    # Principal Components Analysis
    m <- rescale(2000)
    n <- rescale(2000)
    A <- matrix (runif (m*n), m, n)
    elapsed.time[5] <- system.time (P <- prcomp(A))[3]
    mssg(5)


    # Linear Discriminant Analysis
    g <- 5
    m <- rescale(3000)
    n <- rescale(1000)
    k <- round (m/2)
    A <- matrix (runif (m*n), m, n)
    A <- data.frame (A, fac = sample (LETTERS[1:g], m, replace = TRUE))
    train <- sample(1:m, k)
    elapsed.time[6] <- system.time (L <- MASS::lda(fac ~., data = A, prior = rep(1, g)/g, subset = train))[3]
    mssg(6)

    elapsed.time
  }
  if(!"package:RevoUtilsMath" %in% search()) threads <- threads[1]
  ret <- lapply(threads, runUrbanek)
  ret <- do.call(cbind, ret)
  rVersion <- if(exists("Revo.version")) "RRO" else "R"
  rVersionList <- if(exists("Revo.version")) Revo.version else R.version
  rVersion <- sprintf("%s-%s.%s", rVersion, rVersionList$major, rVersionList$minor)
  colnames(ret) <- sprintf("%s (%s thread%s)", rVersion, threads, ifelse(threads > 1, "s", ""))
  class(ret) <- "RevoBenchmark"
  Revo.version <- NULL # trick to pass R CMD check
  attr(ret, "R.version") <- list(R.version = R.version,
                                 Revo.version = if(exists("Revo.version")) Revo.version else NA
  )
  ret

}


print.RevoBenchmark <- function(x, digits = 2, ...){
  attr(x, "R.version") <- NULL
  x <- unclass(x)
  NextMethod(x, digits = digits)
}



