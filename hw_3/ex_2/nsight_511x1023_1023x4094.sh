#!/bin/bash

make clean
make

/usr/local/cuda-11/bin/nv-nsight-cu-cli ./lab3_ex2.out 511 1023 4094
