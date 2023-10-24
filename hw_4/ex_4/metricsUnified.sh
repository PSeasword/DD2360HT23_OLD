#!/bin/bash

make clean
make

dimX=100000
nsteps=1000

echo "Using dimX $dimX and nsteps $nsteps"

echo "==================== With prefetching ===================="

for i in {1..1}; do
  nvprof --output-profile profileEx3WithPrefetching.nvvp -f ./lab4_ex4.out "$dimX" "$nsteps" 1
  nvprof ./lab4_ex4.out "$dimX" "$nsteps" 1
  echo ""
done

echo ""

echo "==================== Without prefetching ===================="

for i in {1..1}; do
  nvprof --output-profile profileEx3WithoutPrefetching.nvvp -f ./lab4_ex4.out "$dimX" "$nsteps" 0
  nvprof ./lab4_ex4.out "$dimX" "$nsteps" 0
  echo ""
done
