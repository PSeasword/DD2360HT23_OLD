#!/bin/bash

make clean
make

variantsLab3=("lab3_ex1" "lab3_ex1_pinned")
variantsLab4=("lab4_ex2")
inputLengths=(10000 100000 1000000 10000000 20000000 40000000 60000000 80000000 100000000)

for toRun in "${variantsLab3[@]}"; do
  echo "Running $toRun.out, saving to output_$toRun.txt"
  > "output_$toRun.txt"

  for inputLength in "${inputLengths[@]}"; do
    ./"$toRun.out" "$inputLength" >> "output_$toRun.txt"
  done
done

for toRun in "${variantsLab4[@]}"; do
  echo "Running $toRun.out, saving to output_$toRun.txt"
  > "output_$toRun.txt"

  for inputLength in "${inputLengths[@]}"; do
    ./"$toRun.out" "$inputLength" - 4 >> "output_$toRun.txt"
  done
done
