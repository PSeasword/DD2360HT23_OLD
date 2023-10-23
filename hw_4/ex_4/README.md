# Exercise 4 - Heat Equation Using NVIDIA Libraries

Run

```
differentDimX.sh
```

to get the output, such as FLOPS, for different `dimX` and `nsteps` values and then

```
createLaTeXTableFLOPS.py
```

to get the data in a format that can be added to a LaTeX table. Run

```
differentNSteps.sh
```

to get the output for different `nsteps` from 100 to 100000 when `dimX` is 128 and then

```
plotRelativeError.py
```

to plot the relative error for different `nsteps` values. Run

```
comparePrefetching.sh
```

to use `nvprof`, and create files for `nvvp`, when prefetching is enable and disabled and then

```
plotComparePrefetching.py
```

to compare the achieved throughput in FLOPS for different `dimX` and `nsteps` values.
