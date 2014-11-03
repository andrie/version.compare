# vbenchmark - a package to compare system time across versions of R


## Objective:

* To compare execution speed of a script across different versions of R
* This is done by using RScript and diverting output to temp files


## API

Not yet fully implemented

```r
version.time(expr, rVersions, reps=1, inDir, pipeTo)
```

result:

- named list with results of system.time()

side effects: 

- ???
