#!/bin/bash

git clone https://github.com/NVIDIA/cuda-samples.git
cp -rf cuda-samples/Samples/1_Utilities/deviceQuery ./deviceQuery

nvcc -Icuda-samples/Common deviceQuery/deviceQuery.cpp -o deviceQuery/deviceQuery.out
./deviceQuery/deviceQuery.out
