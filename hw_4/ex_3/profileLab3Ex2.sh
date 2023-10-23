#!/bin/bash

make clean
make lab3_ex2.out

inputDims1=(100 450 800)
inputDim2=1024
inputDim3=4150

for inputDim1 in "${inputDims1[@]}"; do
  echo "========== $inputDim1 $inputDim2 $inputDim3 =========="
  nvprof ./lab3_ex2.out $inputDim1 $inputDim2 $inputDim3
done
