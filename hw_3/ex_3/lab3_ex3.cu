#include <stdio.h>
#include <sys/time.h>
#include <random>

#define NUM_BINS 4096
#define THREADS_PER_BLOCK_HISTOGRAM 1024
#define THREADS_PER_BLOCK_CONVERT 64
#define INPUT_VALUES_PER_THREAD 8
#define SHARED_MEMORY_BINS_PER_THREAD 4

struct timeval startTime;

void startTimer() {
  // Used "Tutorial: Timing your Kernel - CPU Timer & nvprof" for reference
  gettimeofday(&startTime, NULL);
}

double getTimerSeconds() {
  // Used "Tutorial: Timing your Kernel - CPU Timer & nvprof" for reference
  struct timeval endTime;
  gettimeofday(&endTime, NULL);
  return ((double)endTime.tv_sec + (double)endTime.tv_usec * 1.e-6) - ((double)startTime.tv_sec + (double)startTime.tv_usec * 1.e-6);
}

__global__ void histogram_kernel(unsigned int *input, unsigned int *bins, unsigned int num_elements, unsigned int num_bins) {
  //@@ Insert code below to compute histogram of input using shared memory and atomics
  const int id = blockIdx.x * blockDim.x + threadIdx.x;

  // Shared memory stores bins corresponding to this block
  __shared__ unsigned int binsInShared[NUM_BINS];

  // All bins this thread should initialize to 0
  const int startSharedBin = threadIdx.x * SHARED_MEMORY_BINS_PER_THREAD;
  const int endSharedBin = (threadIdx.x + 1) * SHARED_MEMORY_BINS_PER_THREAD;

  // All input values this thread should process
  const int startInputValue = id * INPUT_VALUES_PER_THREAD;
  const int endInputValue = (id + 1) * INPUT_VALUES_PER_THREAD;

  // Set shared memory to 0
  if (startSharedBin < NUM_BINS) {
    // Do not go outside existing bins
    if (endSharedBin > NUM_BINS) {
      endSharedBin = NUM_BINS;
    }

    // Thread sets its bins to 0
    for (int i = startSharedBin; i < endSharedBin; ++i) {
      binsInShared[i] = 0;
    }
  }

  __syncthreads();

  // Add this threads input values to corresponding bins in shared memory
  if (startInputValue < num_elements) {
    // Do not go outside existing input values
    if (endInputValue > num_elements) {
      endInputValue = num_elements;
    }

    // Thread adds its input values to the shared bins
    for (int i = startInputValue; i < endInputValue; ++i) {
      atomicAdd(&binsInShared[input[i]], 1);
    }
  }

  __syncthreads();

  // Merge bins from the different shared memories (blocks) to global memory
  if (startSharedBin < NUM_BINS) {
    // Thread adds the values of its shared bins to the global bins
    for (int i = startSharedBin; i < endSharedBin; ++i) {
      if (binsInShared[i] != 0) {
        atomicAdd(&bins[i], binsInShared[i]);
      }
    }
  }
}

__global__ void convert_kernel(unsigned int *bins, unsigned int num_bins) {
  //@@ Insert code below to clean up bins that saturate at 127
  const int id = blockIdx.x * blockDim.x + threadIdx.x;

  // Each thread checks one bin
  if (id < num_bins) {
    if (bins[id] > 127) {
      bins[id] = 127;
    }
  }
}


int main(int argc, char **argv) {
  int inputLength;
  unsigned int *hostInput;
  unsigned int *hostBins;
  unsigned int *resultRef;
  unsigned int *deviceInput;
  unsigned int *deviceBins;

  //@@ Insert code below to read in inputLength from args
  if (argc != 2) {
    printf("Incorrect number of arguments.\nUsage: ./lab3_ex3.out <inputLength>\n");
    return -1;
  }

  inputLength = atoi(argv[1]);

  printf("The input length is %d\n", inputLength);

  //@@ Insert code below to allocate Host memory for input and output
  hostInput = (unsigned int*) malloc(inputLength * sizeof(unsigned int));
  hostBins = (unsigned int*) malloc(NUM_BINS * sizeof(unsigned int));
  resultRef = (unsigned int*) calloc(NUM_BINS, NUM_BINS * sizeof(unsigned int));

  //@@ Insert code below to initialize hostInput to random numbers whose values range from 0 to (NUM_BINS - 1)
  srand(time(NULL));

  for (int i = 0; i < inputLength; ++i) {
    hostInput[i] = (unsigned int)(((double)rand() / (double)RAND_MAX) * NUM_BINS);
  }

  //@@ Insert code below to create reference result in CPU
  for (int i = 0; i < inputLength; ++i) {
    int binNum = hostInput[i];

    if (resultRef[binNum] < 127) {
      resultRef[binNum]++;
    }
  }

  //@@ Insert code below to allocate GPU memory here
  cudaMalloc(&deviceInput, inputLength * sizeof(unsigned int));
  cudaMalloc(&deviceBins, NUM_BINS * sizeof(unsigned int));

  //@@ Insert code to Copy memory to the GPU here
  cudaMemcpy(deviceInput, hostInput, inputLength * sizeof(unsigned int), cudaMemcpyHostToDevice);

  //@@ Insert code to initialize GPU results
  cudaMemset(deviceBins, 0, NUM_BINS * sizeof(unsigned int));

  //@@ Initialize the grid and block dimensions here
  dim3 blockHistogram(THREADS_PER_BLOCK_HISTOGRAM);
  dim3 gridHistogram(((inputLength / INPUT_VALUES_PER_THREAD) + THREADS_PER_BLOCK_HISTOGRAM - 1) / THREADS_PER_BLOCK_HISTOGRAM);

  printf("Threads per Block (histogram_kernel): %i\nBlocks (histogram_kernel): %i\n", THREADS_PER_BLOCK_HISTOGRAM, ((inputLength / INPUT_VALUES_PER_THREAD) + THREADS_PER_BLOCK_HISTOGRAM - 1) / THREADS_PER_BLOCK_HISTOGRAM);

  startTimer();

  //@@ Launch the GPU Kernel here
  histogram_kernel<<<gridHistogram, blockHistogram>>>(deviceInput, deviceBins, inputLength, NUM_BINS);
  cudaDeviceSynchronize();

  double timeHistogram = getTimerSeconds();

  //@@ Initialize the second grid and block dimensions here
  dim3 blockConvert(THREADS_PER_BLOCK_CONVERT);
  dim3 gridConvert((NUM_BINS + THREADS_PER_BLOCK_CONVERT - 1) / THREADS_PER_BLOCK_CONVERT);

  printf("Threads per Block (convert_kernel): %i\nBlocks (convert_kernel): %i\n", THREADS_PER_BLOCK_CONVERT, (NUM_BINS + THREADS_PER_BLOCK_CONVERT - 1) / THREADS_PER_BLOCK_CONVERT);

  startTimer();

  //@@ Launch the second GPU Kernel here
  convert_kernel<<<gridConvert, blockConvert>>>(deviceBins, NUM_BINS);
  cudaDeviceSynchronize();

  double timeConvert = getTimerSeconds();

  //@@ Copy the GPU memory back to the CPU here
  cudaMemcpy(hostBins, deviceBins, NUM_BINS * sizeof(unsigned int), cudaMemcpyDeviceToHost);

  printf("Bins: ");
  int diffs = 0;

  //@@ Insert code below to compare the output with the reference
  for (int i = 0; i < NUM_BINS; ++i) {
    if (hostBins[i] != resultRef[i]) {
      diffs++;
      printf("Bins %i differentiates, found %i instead of %i\n", i, hostBins[i], resultRef[i]);
    }

    // Print the values of all bins on a single line
    if (i < NUM_BINS - 1) {
      printf("%i, ", hostBins[i]);
    }
    else {
      printf("%i\n", hostBins[i]);
    }
  }

  printf("Number of errors: %i/%i\n", diffs, NUM_BINS);

  //@@ Free the GPU memory here
  cudaFree(deviceInput);
  cudaFree(deviceBins);

  //@@ Free the CPU memory here
  free(hostInput);
  free(hostBins);
  free(resultRef);

  printf("histogram_kernel: %f\nconvert_kernel: %f\nTotal: %f\n", timeHistogram, timeConvert, timeHistogram+timeConvert);

  printf("Done.\n");

  return 0;
}
