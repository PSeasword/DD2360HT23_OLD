# Exercise 2 - CUDA Streams

To compare the use of streams to without streams with and without pinned memory, run

```
./compareToPrevious.sh
```

where `plotCompareToPrevious.py`is used to plot the results. Run

```
./createFileNVVP.sh
```

to collect traces for NVIDIA Visual Profiler. To get output data for different segment sizes, using 4 streams or a varying number of streams so that each stream only performs one round of transfers, run

```
./differentSegmentSizes.sh
```

where `plotDifferentSegmentSizes.py` is used to plot the results.
