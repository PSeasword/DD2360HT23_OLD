#!/bin/bash

make clean
make lab4_ex2_pinned.out

output4Streams="output_segment_4.txt"
outputVaryingStreams="output_segment_varying.txt"

inputLength=100000000
segmentSizes=(10000 100000 1000000 10000000 20000000 40000000 60000000 80000000 100000000)

echo "Running lab4_ex2_pinned.out with 4 streams, saving to $output4Streams"
> $output4Streams

for segmentSize in "${segmentSizes[@]}"; do
  ./lab4_ex2_pinned.out "$inputLength" "$segmentSize" 4 >> "$output4Streams"
done

echo "Running lab4_ex2_pinned.out with varying number of streams, saving to $outputVaryingStreams"
> $outputVaryingStreams

for segmentSize in "${segmentSizes[@]}"; do
  ./lab4_ex2_pinned.out "$inputLength" "$segmentSize" - >> "$outputVaryingStreams"
done
