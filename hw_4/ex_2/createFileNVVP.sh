#!/bin/bash

make clean
make lab4_ex2.out

nvprof --output-profile profileEx2.nvvp -f ./lab4_ex2.out 100000000 - 4
