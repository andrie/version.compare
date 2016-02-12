## ----init, include=FALSE-------------------------------------------------
library("version.compare")
library("knitr")

## ------------------------------------------------------------------------
scale.factor <- 0.5

## ----benchmark, echo=FALSE-----------------------------------------------
r <- findRscript(version = "3.2.3.*x64")
test.results <- RevoMultiBenchmark(rVersions = r, threads = c(1, 4), scale.factor = scale.factor)

## ----compare-results, echo = FALSE, fig.width=6, fig.height=3, out.width="800px", dpi=1200----
kable(test.results)
plot(test.results, theme_size=8, main = "Elapsed time")

## ----performance-speed-up, echo = FALSE, fig.width=6, fig.height=3, out.width="800px", dpi=1200----
kable(urbanekPerformance(test.results), digits = 2)
plot(urbanekPerformance(test.results), theme_size=8, main = "Relative Performance")

