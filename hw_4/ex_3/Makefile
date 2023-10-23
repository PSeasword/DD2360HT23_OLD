OUT3 = lab3_ex2.out
SRC3 = ../../hw_3/ex_2/lab3_ex2.cu
OUT4P = lab4_ex3_pinned.out
SRC4P = lab4_ex3_pinned.cu
OUT4U = lab4_ex3_unified.out
SRC4U = lab4_ex3_unified.cu

all: $(OUT3) $(OUT4P) $(OUT4U)

$(OUT3): $(SRC3)
	nvcc -arch=sm_60 --default-stream per-thread $< -o $@

$(OUT4P): $(SRC4P)
	nvcc -arch=sm_60 --default-stream per-thread $< -o $@

$(OUT4U): $(SRC4U)
	nvcc -arch=sm_60 --default-stream per-thread $< -o $@

clean:
	rm -f $(OUT3)
	rm -f $(OUT4P)
	rm -f $(OUT4U)
