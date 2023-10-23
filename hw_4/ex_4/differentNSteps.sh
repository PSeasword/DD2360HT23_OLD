#!/bin/bash

make clean
make

outputFile="outputDifferentNSteps.txt"

> "$outputFile"

dimX=128

echo "Printing to $outputFile"
echo "Using dimX $dimX"

for nsteps in {100..10000..100}; do
  echo "Running nsteps $nsteps"
  ./lab4_ex4.out "$dimX" "$nsteps" >> "$outputFile"
done
