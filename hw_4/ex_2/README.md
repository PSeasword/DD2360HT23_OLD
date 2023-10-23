# Exercise 2 - CUDA Streams

To compare the use of streams to without streams with and without pinned memory, run

```
compareToPrevious.sh
```

and then

```
plotCompareToPrevious.py
```

to plot the results. Run

```
createFileNVVP.sh
```

to collect traces for NVIDIA Visual Profiler. To get output data for different segment sizes, using 4 streams or varying number of streams so that each stream only performs one round of transfers each, run

```
differentSegmentSizes.sh
```

and then

```
plotDifferentSegmentSizes.py
```

to plot the results.
