#!/bin/bash

make clean
make

outputFile="outputDifferentDimX.txt"

> "$outputFile"

dimXVals=(10 100 1000 10000 100000)
nstepsVals=(10 100 1000)

echo "Printing to $outputFile"

for nsteps in "${nstepsVals[@]}"; do
  for dimX in "${dimXVals[@]}"; do
    echo "Running dimX $dimX and nsteps $nsteps"
    ./lab4_ex4.out "$dimX" "$nsteps" >> "$outputFile"
  done
done
