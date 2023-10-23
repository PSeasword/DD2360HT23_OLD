#!/bin/bash

mainDir="$(pwd)"

mkdir -p data
mkdir -p dataGPU

mv sputniPIC-DD2360/src/Particles.cu ParticlesCPU.cu
mv ParticlesGPU.cu sputniPIC-DD2360/src/Particles.cu

cd sputniPIC-DD2360
make clean
make

echo "===== Running GPU and saving result in data/dataGPU ====="
cd "$mainDir"
./sputniPIC-DD2360/bin/sputniPIC.out sputniPIC-DD2360/inputfiles/GEM_2D.inp
cp data/* dataGPU/

mv sputniPIC-DD2360/src/Particles.cu ParticlesGPU.cu
mv ParticlesCPU.cu sputniPIC-DD2360/src/Particles.cu
