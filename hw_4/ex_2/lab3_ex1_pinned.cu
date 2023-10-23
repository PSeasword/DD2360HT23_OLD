#include <stdio.h>
#include <sys/time.h>

#define DataType double
#define THREADS_PER_BLOCK 64
#define MAXIMUM_RANDOM_VALUE 1000

struct timeval startTime;

__global__ void vecAdd(DataType *in1, DataType *in2, DataType *out, int len) {
  //@@ Insert code to implement vector addition here
  const int id = blockIdx.x * blockDim.x + threadIdx.x;

  if (id < len) {
    out[id] = in1[id] + in2[id];
  }
}

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

int main(int argc, char **argv) {
  int inputLength;
  DataType *hostInput1;
  DataType *hostInput2;
  DataType *hostOutput;
  DataType *resultRef;
  DataType *deviceInput1;
  DataType *deviceInput2;
  DataType *deviceOutput;
  double timeHostToDevice;
  double timeKernel;
  double timeDeviceToHost;

  //@@ Insert code below to read in inputLength from args
  if (argc != 2) {
    printf("Incorrect number of arguments.\nUsage: ./lab3_ex1_pinned.out <inputLength>\n");
    return -1;
  }

  inputLength = atoi(argv[1]);

  printf("The input length is %d\n", inputLength);

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

  startTimer();

  //@@ Insert code to below to Copy memory to the GPU here
  cudaMemcpy(deviceInput1, hostInput1, inputLength * sizeof(DataType), cudaMemcpyHostToDevice);
  cudaMemcpy(deviceInput2, hostInput2, inputLength * sizeof(DataType), cudaMemcpyHostToDevice);

  timeHostToDevice = getTimerSeconds();

  //@@ Initialize the 1D grid and block dimensions here
  dim3 block(THREADS_PER_BLOCK);
  dim3 grid((inputLength + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK);

  printf("Threads per block: %d\nNumber of thread blocks: %d\n", block.x, grid.x);

  startTimer();

  //@@ Launch the GPU Kernel here
  vecAdd<<<grid, block>>>(deviceInput1, deviceInput2, deviceOutput, inputLength);
  cudaDeviceSynchronize();

  timeKernel = getTimerSeconds();
  startTimer();

  //@@ Copy the GPU memory back to the CPU here
  cudaMemcpy(hostOutput, deviceOutput, inputLength * sizeof(DataType), cudaMemcpyDeviceToHost);

  timeDeviceToHost = getTimerSeconds();

  printf("cudaMemcpy (host to device) time (s): %f\nvecAdd kernel time (s): %f\ncudaMemcpy (device to host) time (s): %f\nTotal time (s): %f\n", timeHostToDevice, timeKernel, timeDeviceToHost, timeHostToDevice+timeKernel+timeDeviceToHost);

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
