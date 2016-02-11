## ----init, include=FALSE-------------------------------------------------
library("version.compare")
library("knitr")

## ------------------------------------------------------------------------
scale.factor <- 0.5

## ----benchmark, echo=FALSE-----------------------------------------------
r <- findRscript(version = "3.2.3.*x64")
test.results <- RevoMultiBenchmark(rVersions = r, threads = c(1, 4), scale.factor = scale.factor)

## ----compare-results, echo=FALSE-----------------------------------------
kable(test.results)

## ----performance-speed-up, echo=FALSE------------------------------------
kable(urbanekPerformance(test.results), digits = 2)

## ----plot-results, echo = FALSE, fig.width=6, fig.height=3, out.width="800px", dpi=600----
plot(test.results, theme_size=10)

