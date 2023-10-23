#!/bin/bash

mainDir="$(pwd)"

cd "$mainDir"/rodinia_3.1/openmp/lud
make
cd "$mainDir"/rodinia_3.1/cuda/lud
make

echo "========== lud =========="
echo "===== OpenMP ====="
cd "$mainDir"/rodinia_3.1/openmp/lud
./omp/lud_omp -s 8000
echo "===== CUDA ====="
cd "$mainDir"/rodinia_3.1/cuda/lud
nvprof --profile-child-processes ./cuda/lud_cuda -s 8000
