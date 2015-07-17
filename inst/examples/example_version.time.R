# Find installed versions of Rscript

rversion <- paste(R.version$major, R.version$minor, sep = ".")
rscript <- findRscript(version = rversion)


# Configure which installed version to use

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
