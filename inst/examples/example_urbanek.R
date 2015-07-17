# Run Urbanek benchmark
# Set low scale.factor to reduce time to run on CRAN
# For actual testing, use the default, i.e. scale.factor = 1
urbanek2.5(threads = c(4, 8), scale.factor = 0.1)
