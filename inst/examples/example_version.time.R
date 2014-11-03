# Find installed versions of Rscript

rscript <- findRscript()


# Configure which installed version to use

rscript <- switch(
  Sys.info()[["sysname"]],
  Windows = c(
    "c:/program files/RRO/R-3.1.1/bin/x64/Rscript.exe",
    "c:/program files/R/R-3.1.1/bin/x64/Rscript.exe"
  ),
  Linux = c(
    "/usr/lib64/RRO-8.0/R-3.1.1/lib/R/bin/Rscript",
    "/usr/lib/R/bin/Rscript"
  )
)

# Compute vector mean in different R installations

version.time({
  foo <- rnorm(1e6)
  mean(foo)
} , rscript)


# Compute matrix cross product in different R installations

version.time({
  m <- matrix(runif(100), nrow=10)
  crossprod(m)
} , rscript)
