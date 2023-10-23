#!/bin/bash

wget http://www.cs.virginia.edu/~skadron/lava/Rodinia/Packages/rodinia_3.1.tar.bz2
tar -xf rodinia_3.1.tar.bz2

mv -f hotspot3DUpdatedMakefile.txt rodinia_3.1/cuda/hotspot3D/Makefile
