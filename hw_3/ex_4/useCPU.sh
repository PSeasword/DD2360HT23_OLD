#!/bin/bash

mainDir="$(pwd)"

mkdir -p data
mkdir -p dataCPU

cd sputniPIC-DD2360
make clean
make

echo "===== Running CPU and saving result in data/dataCPU ====="
cd "$mainDir"
./sputniPIC-DD2360/bin/sputniPIC.out sputniPIC-DD2360/inputfiles/GEM_2D.inp
cp data/* dataCPU/
