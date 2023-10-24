# Exercise 4 - Heat Equation Using NVIDIA Libraries

Run

```
./differentDimX.sh
```

to get the output, such as FLOPS, for different `dimX` and `nsteps` values where `createLaTeXTableFLOPS.py` is used to get the data in a format that can be added to a LaTeX table. Run

```
./differentNSteps.sh
```

to get the output for different `nsteps` between 100 and 100000 when `dimX` is 128 where `plotRelativeError.py` is used to plot the resulting relative error. Run

```
./comparePrefetching.sh
```

to profile with `nvprof` and create files for `nvvp`, with prefetching and without prefetching, where `plotComparePrefetching.py` is used to compare the achieved throughput in FLOPS for different `dimX` and `nsteps` values.
