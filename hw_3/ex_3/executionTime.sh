#!/bin/bash

lowValue=1000
highValue=1000000

make clean
make

echo "===== $lowValue ====="
./lab3_ex3.out "$lowValue"

echo "===== $highValue ====="
./lab3_ex3.out "$highValue"
