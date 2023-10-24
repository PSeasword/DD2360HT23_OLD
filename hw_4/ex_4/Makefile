OUT = lab4_ex4.out
SRC = lab4_ex4.cu

all:
	nvcc -arch=sm_60 --default-stream per-thread -lcusparse -lcublas $(SRC) -o $(OUT)

clean:
	rm -f $(OUT)
	rm -f outputPrefetching.txt outputDifferentDimX.txt outputDifferentNSteps.txt
	rm -f profileEx3WithoutPrefetching.nvvp profileEx3WithPrefetching.nvvp
