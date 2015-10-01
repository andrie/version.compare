## ----init, include=FALSE-------------------------------------------------
library("version.compare")
library("knitr")

## ----benchmark, echo=FALSE-----------------------------------------------
r <- findRscript(version = "3.2.2.*x64")
test.results <- RevoMultiBenchmark(rVersions = r, threads = c(1, 4), scale.factor = 0.1)

## ----compare-results, echo=FALSE-----------------------------------------
kable(test.results)

## ----performance-speed-up, echo=FALSE------------------------------------
kable(urbanekPerformance(test.results), digits = 2)

## ----plot-results, echo = FALSE, fig.width=6, fig.height=3, out.width="800px"----
plot(test.results, theme_size=10)

