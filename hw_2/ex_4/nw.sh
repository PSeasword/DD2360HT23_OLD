#!/bin/bash

mainDir="$(pwd)"

cd "$mainDir"/rodinia_3.1/openmp/nw
make
cd "$mainDir"/rodinia_3.1/cuda/nw
make

echo "========== nw =========="
echo "===== OpenMP ====="
cd "$mainDir"/rodinia_3.1/openmp/nw
./needle 16384 10 2
echo "===== CUDA ====="
cd "$mainDir"/rodinia_3.1/cuda/nw
nvprof --profile-child-processes ./needle 16384 10
