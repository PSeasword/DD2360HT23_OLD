#!/bin/bash

make clean
make

outputFile="outputPrefetching.txt"

> "$outputFile"

nstepsVals=(10 100 1000 10000)

echo "Printing to $outputFile"

for nsteps in "${nstepsVals[@]}"; do
  for prefetching in {0..1}; do
    for dimX in {100..10000..990}; do
      echo "Running dimX $dimX, nsteps $nsteps, and prefetching $prefetching"
      echo "Prefetching is set to $prefetching" >> "$outputFile"
      ./lab4_ex4.out "$dimX" "$nsteps" "$prefetching" >> "$outputFile"
    done
  done
done
