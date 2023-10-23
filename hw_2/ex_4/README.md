# Exercise 4 - Rodinia CUDA Benchmarks and Profiling

Run

```
setup.sh
```

to download and unpack the Rodinia benchmark suite, automatically replacing the Makefile for hotspot3D with

```
hotspot3DUpdatedMakefile.txt
```

so that the correct path is used. More precisely, changing `~/rodinia_3.0/common/make.config`to `../../../rodinia_3.1/common/make.config`. Running the scripts

```
hotspot3D.sh
lud.sh
nw.sh
```

will automatically run the OpenMP and CUDA implementation of each respective benchmark with the same parameters.
