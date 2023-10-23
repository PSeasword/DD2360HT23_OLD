#!/bin/bash

mainDir="$(pwd)"

cd "$mainDir"/rodinia_3.1/openmp/hotspot3D
make
cd "$mainDir"/rodinia_3.1/cuda/hotspot3D
make

echo "========== hotspot3D =========="
echo "===== OpenMP ====="
cd "$mainDir"/rodinia_3.1/openmp/hotspot3D
./3D 512 8 1000 ../../data/hotspot3D/power_512x8 ../../data/hotspot3D/temp_512x8 output.out
echo "===== CUDA ====="
cd "$mainDir"/rodinia_3.1/cuda/hotspot3D
nvprof --profile-child-processes ./3D 512 8 1000 ../../data/hotspot3D/power_512x8 ../../data/hotspot3D/temp_512x8 output.out
