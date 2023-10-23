#!/bin/bash

make clean
make lab4_ex3_unified.out

inputDims1=(100 450 800)
inputDim2=1024
inputDim3=4150

echo "==================== Prefetching ===================="

for inputDim1 in "${inputDims1[@]}"; do
  echo "========== $inputDim1 $inputDim2 $inputDim3 =========="
  nvprof ./lab4_ex3_unified.out $inputDim1 $inputDim2 $inputDim3 1
done
