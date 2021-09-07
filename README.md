# Compare the results of R code running in different installed versions of R


## Objective:

* To compare results (and execution speed) of a script running in different installed versions of R
* This is done by using RScript and diverting output to temp files


## Exported functions

* `findRscript()`
    - Finds installed versions of R on a machine, by searching for `Rscript` in typical installation folders
    
* `version.time()`
    - Similar to `system.time()` in base R, takes an expression as input and runs this expression in multiple installations of R on the same machine
    - Returns results as well as `system.time()` for each installed version.
    

## Example

This example runs a simple script in two different installations of R.

```r
# Find installed versions of Rscript

rscript <- findRscript()


# Configure which installed version to use

rscript <- switch(
  Sys.info()[["sysname"]],
  Windows = c(
    "c:/program files/RRO/R-4.0.2/bin/x64/Rscript.exe",
    "c:/program files/R/R-4.0.2/bin/x64/Rscript.exe"
  ),
  Linux = c(
    "/usr/lib64/RRO-8.0/R-4.0.2/lib/R/bin/Rscript",
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
```

# View the vignette

You can see the package vignette at https://htmlpreview.github.io/?https://github.com/andrie/version.compare/blob/master/inst/doc/version.compare.html
