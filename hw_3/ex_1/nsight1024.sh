#!/bin/bash

make clean
make

/usr/local/cuda-11/bin/nv-nsight-cu-cli ./lab3_ex1.out 1024
