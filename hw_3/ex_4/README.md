# Exercise 4 - A Particle Simulation Application

Run

```
setup.sh
```

to clone the repository https://github.com/KTH-HPC/sputniPIC-DD2360.git and replace the Makefile with `updatedMakefile.txt` where `ARCH=sm_30` in the original has been changed to `ARCH=sm_60`. Run the scripts

```
useCPU.sh
useGPU.sh
```

to use the CPU and GPU, respectively, when running the program. Then run

```
plotOutputValues.py
```

to plot and be able to compare the output data of the two implementations.
