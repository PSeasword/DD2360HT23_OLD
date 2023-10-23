#include <stdio.h>
#include <sys/time.h>

#define DataType double
#define MAXIMUM_RANDOM_VALUE 1000
#define TOLERANCE 0.001 // For double
// #define TOLERANCE 1000 // For float

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

// Compute C = A * B
__global__ void gemm(DataType *A, DataType *B, DataType *C, int numARows, int numAColumns, int numBRows, int numBColumns){
  //@@ Insert code to implement matrix multiplication here
  const int rowC = blockIdx.y;
  const int colC = blockIdx.x;

  const int rowA = rowC;
  const int colA = threadIdx.x;

  const int rowB = threadIdx.x;
  const int colB = colC;

  if (rowA < numARows && colA < numAColumns && colB < numBColumns) {
    atomicAdd(&C[colC + rowC * numBColumns], A[colA + rowA * numAColumns] * B[colB + rowB * numBColumns]);
  }
}

int main(int argc, char **argv) {
  DataType *unifiedA; // The A matrix
  DataType *unifiedB; // The B matrix
  DataType *unifiedC; // The output C matrix
  DataType *resultRef; // The reference result
  int numARows;    // number of rows in the matrix A
  int numAColumns; // number of columns in the matrix A
  int numBRows;    // number of rows in the matrix B
  int numBColumns; // number of columns in the matrix B
  int numCRows;
  int numCColumns;
  double timeTotal;
  int prefetching = 0;

  //@@ Insert code below to read in numARows, numAColumns, numBColumns from args
  if (argc != 4 && argc != 5) {
    printf("Incorrect number of arguments.\nUsage: ./lab4_ex3_unified.out <numARows> <numAColumns> <numBColumns> [<prefetching>]\n");
    return -1;
  }

  numARows = atoi(argv[1]);
  numAColumns = atoi(argv[2]);

  numBRows = numAColumns;
  numBColumns = atoi(argv[3]);

  numCRows = numARows;
  numCColumns = numBColumns;

  if (argc == 5) {
    prefetching = atoi(argv[4]);
  }

  printf("Input matrix dim (%d x %d) (%d x %d) (%d x %d)\n", numARows, numAColumns, numBRows, numBColumns, numCRows, numCColumns);
  printf("Prefetching: %i\n", prefetching);

  //@@ Insert code below to allocate memory here
  cudaMallocManaged(&unifiedA, numARows * numAColumns * sizeof(DataType));
  cudaMallocManaged(&unifiedB, numBRows * numBColumns * sizeof(DataType));
  cudaMallocManaged(&unifiedC, numCRows * numCColumns * sizeof(DataType));
  resultRef = (DataType*) calloc(numCRows * numCColumns, numCRows * numCColumns * sizeof(DataType));

  // Prefetch unified memory to host
  if (prefetching == 1) {
    cudaMemPrefetchAsync(unifiedA, numARows * numAColumns * sizeof(DataType), cudaCpuDeviceId);
    cudaMemPrefetchAsync(unifiedB, numBRows * numBColumns * sizeof(DataType), cudaCpuDeviceId);
  }

  //@@ Insert code below to initialize hostA and hostB to random numbers, and create reference result in CPU
  srand(time(NULL));

  for (int i = 0; i < numARows * numAColumns; ++i) {
    unifiedA[i] = ((DataType)rand() / (DataType)RAND_MAX) * MAXIMUM_RANDOM_VALUE;
  }

  for (int i = 0; i < numBRows * numBColumns; ++i) {
    unifiedB[i] = ((DataType)rand() / (DataType)RAND_MAX) * MAXIMUM_RANDOM_VALUE;
  }

  // Traverse each column
  for (int y = 0; y < numCRows; ++y) {
    // Traverse each row
    for (int x = 0; x < numCColumns; ++x) {
      // Elements to multiply
      for (int i = 0; i < numAColumns; ++i) {
        resultRef[x + y * numCColumns] += unifiedA[i + y * numAColumns] * unifiedB[x + i * numBColumns];
      }
    }
  }

  // Prefetch unified memory to device
  if (prefetching == 1) {
    cudaMemPrefetchAsync(unifiedA, numARows * numAColumns * sizeof(DataType), 0);
    cudaMemPrefetchAsync(unifiedB, numBRows * numBColumns * sizeof(DataType), 0);
    cudaMemPrefetchAsync(unifiedC, numCRows * numCColumns * sizeof(DataType), 0);
  }

  //@@ Initialize the grid and block dimensions here
  dim3 block(numAColumns); // One thread for each multiplication (1D)
  dim3 grid(numCColumns, numCRows); // One block for each element in the C matrix (2D)

  startTimer();

  //@@ Launch the GPU Kernel here
  gemm<<<grid, block>>>(unifiedA, unifiedB, unifiedC, numARows, numAColumns, numBRows, numBColumns);
  cudaDeviceSynchronize();

  timeTotal = getTimerSeconds();

  // Prefetch unified memory to host
  if (prefetching == 1) {
    cudaMemPrefetchAsync(unifiedC, numCRows * numCColumns * sizeof(DataType), cudaCpuDeviceId);
  }

  //@@ Insert code below to compare the output with the reference
  int diffs = 0;

  for (int i = 0; i < numCRows * numCColumns; ++i) {
    // Not correct
    if (abs(unifiedC[i] - resultRef[i]) > TOLERANCE) {
      int x = i % numCColumns;
      int y = i / numCColumns;

      printf("Elements (%i, %i) differentiates, found %f instead of %f\n", x, y, unifiedC[i], resultRef[i]);
      diffs++;
    }
  }

  printf("Total time (s): %f\n", timeTotal);

  printf("Number of errors: %d/%d\n", diffs, numCRows * numCColumns);

  //@@ Free the Unified memory here
  cudaFree(unifiedA);
  cudaFree(unifiedB);
  cudaFree(unifiedC);
  free(resultRef);

  printf("Done.\n");

  return 0;
}
