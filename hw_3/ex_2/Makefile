OUT = lab3_ex2.out
SRC = lab3_ex2.cu

all:
	nvcc -arch=sm_60 $(SRC) -o $(OUT)

clean:
	rm -f $(OUT) output_matrix_sizes.txt table.txt
