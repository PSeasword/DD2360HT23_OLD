#!/bin/bash

make clean
make

inputDims1=(550 600 650 700 750 800 850)
inputDim2=1024
inputDim3=4150

> output.txt
echo "Writing outputs to output.txt"

for inputDim1 in "${inputDims1[@]}"; do
  ./lab3_ex2 "$inputDim1" "$inputDim2" "$inputDim3" >> output.txt
done
