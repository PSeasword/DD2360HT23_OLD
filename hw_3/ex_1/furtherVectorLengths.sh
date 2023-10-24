#!/bin/bash

make clean
make

inputLengths=(200000 400000 600000 800000 1000000 1200000 1400000 1600000 1800000 2000000)

> output_vector_lengths.txt
echo "Writing outputs to output_vector_lengths.txt"

for inputLength in "${inputLengths[@]}"; do
  ./lab3_ex1.out "$inputLength" >> output_vector_lengths.txt
done
