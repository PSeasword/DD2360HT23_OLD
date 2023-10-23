#include <stdio.h>
#include <sys/time.h>

#define DataType double
#define THREADS_PER_BLOCK 64
#define MAXIMUM_RANDOM_VALUE 1000

struct timeval startTime;

//@@ Insert code to implement timer start
void startTimer() {
  // Used "Tutorial: Timing your Kernel - CPU Timer & nvprof" for reference
  gettimeofday(&startTime, NULL);
}

//@@ Insert code to implement timer stop
double getTimerSeconds() {
  // Used "Tutorial: Timing your Kernel - CPU Timer & nvprof" for reference
  struct timeval endTime;
  gettimeofday(&endTime, NULL);
  return ((double)endTime.tv_sec + (double)endTime.tv_usec * 1.e-6) - ((double)startTime.tv_sec + (double)startTime.tv_usec * 1.e-6);
}

__global__ void vecAdd(DataType *in1, DataType *in2, DataType *out, int len) {
  //@@ Insert code to implement vector addition here
  const int id = blockIdx.x * blockDim.x + threadIdx.x;

  if (id < len) {
    out[id] = in1[id] + in2[id];
  }
}

int main(int argc, char **argv) {
  int inputLength;
  int numStreams;
  int segmentSize; // S_seg
  DataType *hostInput1;
  DataType *hostInput2;
  DataType *hostOutput;
  DataType *resultRef;
  DataType *deviceInput1;
  DataType *deviceInput2;
  DataType *deviceOutput;

  //@@ Insert code below to read in inputLength from args
  if (argc != 4 || (argv[2] == "-" && argv[3] == "-")) {
    printf("Incorrect number of arguments.\nUsage (use - to autofill either segmentSize or numStreams): ./lab4_ex2.out <inputLength> <segmentSize> <numStreams>\n");
    return -1;
  }

  inputLength = atoi(argv[1]);

  // Automatically fill segmentSize
  if (strcmp(argv[2], "-") == 0) {
    numStreams = atoi(argv[3]);
    segmentSize = (inputLength + numStreams - 1) / numStreams;
  }
  // Automatically fill numStreams
  else if (strcmp(argv[3], "-") == 0) {
    segmentSize = atoi(argv[2]);
    numStreams = (inputLength + segmentSize - 1) / segmentSize;
  }
  // Both segmentSize and numStreams were specified
  else {
    segmentSize = atoi(argv[2]);
    numStreams = atoi(argv[3]);
  }

  printf("The input length is %i\nThe segment size is %i\nThe number of streams are %i\n", inputLength, segmentSize, numStreams);

  //@@ Insert code below to allocate Host memory for input and output
  cudaHostAlloc(&hostInput1, inputLength * sizeof(DataType), cudaHostAllocDefault);
  cudaHostAlloc(&hostInput2, inputLength * sizeof(DataType), cudaHostAllocDefault);
  cudaHostAlloc(&hostOutput, inputLength * sizeof(DataType), cudaHostAllocDefault);
  cudaHostAlloc(&resultRef, inputLength * sizeof(DataType), cudaHostAllocDefault);

  //@@ Insert code below to initialize hostInput1 and hostInput2 to random numbers, and create reference result in CPU
  srand(time(NULL));

  for (int i = 0; i < inputLength; ++i) {
    hostInput1[i] = ((float)rand() / (float)RAND_MAX) * MAXIMUM_RANDOM_VALUE;
    hostInput2[i] = ((float)rand() / (float)RAND_MAX) * MAXIMUM_RANDOM_VALUE;
    resultRef[i] = hostInput1[i] + hostInput2[i];
  }

  //@@ Insert code below to allocate GPU memory here
  cudaMalloc(&deviceInput1, inputLength * sizeof(DataType));
  cudaMalloc(&deviceInput2, inputLength * sizeof(DataType));
  cudaMalloc(&deviceOutput, inputLength * sizeof(DataType));

  //@@ Initialize the 1D grid and block dimensions here
  dim3 block(THREADS_PER_BLOCK);
  dim3 grid((segmentSize + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK);

  startTimer();

  // Create streams
  cudaStream_t streams[numStreams];

  for (int i = 0; i < numStreams; ++i) {
    cudaStreamCreate(&streams[i]);
  }

  int processedInputValues = 0; // Number of input values out of inputLength that has been processed so far

  while (processedInputValues < inputLength) {
    for (int i = 0; i < numStreams; ++i) {
      int offset = processedInputValues; // Start of current segment
      int valuesInSegment = segmentSize; // Number of values in this segment

      // Do not process more values than there was in the input
      if (offset + valuesInSegment >= inputLength) {
        valuesInSegment = inputLength - offset;
      }

      //@@ Insert code to below to Copy memory to the GPU here
      cudaMemcpyAsync(&deviceInput1[offset], &hostInput1[offset], valuesInSegment * sizeof(DataType), cudaMemcpyHostToDevice, streams[i]);
      cudaMemcpyAsync(&deviceInput2[offset], &hostInput2[offset], valuesInSegment * sizeof(DataType), cudaMemcpyHostToDevice, streams[i]);

      //@@ Launch the GPU Kernel here
      vecAdd<<<grid, block, 0, streams[i]>>>(&deviceInput1[offset], &deviceInput2[offset], &deviceOutput[offset], valuesInSegment);

      //@@ Copy the GPU memory back to the CPU here
      cudaMemcpyAsync(&hostOutput[offset], &deviceOutput[offset], valuesInSegment * sizeof(DataType), cudaMemcpyDeviceToHost, streams[i]);

      processedInputValues += valuesInSegment;

      // Already processed all values
      if (processedInputValues >= inputLength) {
        break;
      }
    }
  }

  cudaDeviceSynchronize();

  // Destroy streams
  for (int i = 0; i < numStreams; ++i) {
    cudaStreamDestroy(streams[i]);
  }

  printf("Total time (s): %f\n", getTimerSeconds());

  //@@ Insert code below to compare the output with the reference
  int diffs = 0;

  // Loops through vectors to check that the addition was correct
  for (int i = 0; i < inputLength; ++i) {
    // Not correct
    if (abs(hostOutput[i] - resultRef[i]) > 0.00001) {
      printf("Elements %i differentiates, found %f instead of %f\n", i, hostOutput[i], resultRef[i]);
      diffs++;
    }
  }

  printf("Number of errors: %d/%d\n", diffs, inputLength);

  //@@ Free the GPU memory here
  cudaFree(deviceInput1);
  cudaFree(deviceInput2);
  cudaFree(deviceOutput);

  //@@ Free the CPU memory here
  cudaFreeHost(hostInput1);
  cudaFreeHost(hostInput2);
  cudaFreeHost(hostOutput);
  cudaFreeHost(resultRef);

  printf("Done.\n");

  return 0;
}
