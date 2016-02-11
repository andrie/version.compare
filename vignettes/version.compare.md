---
title: "Run MKL benchmarks"
author: "Andrie de Vries"
date: "2016-02-11"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Run MKL benchmarks}
  %\VignetteEngine{knitr::rmarkdown}
  %\usepackage[utf8]{inputenc}
---

# Running the tests



The package allows you to run benchmark tests on several different installations of R on the same machine.

This vignette scales the test sets down to 10% of standard size, to speed up the process for sake of illustration. For a full-scale test, adjust the tests by setting `scale.factor = 1`.








