#!/bin/bash

make clean
make lab4_ex3_pinned.out

inputDims1=(100 450 800)
inputDim2=1024
inputDim3=4150

for inputDim1 in "${inputDims1[@]}"; do
  echo "========== $inputDim1 $inputDim2 $inputDim3 =========="
  nvprof ./lab4_ex3_pinned.out $inputDim1 $inputDim2 $inputDim3
done
