OUT3 = lab3_ex1.out
SRC3 = ../../hw_3/ex_1/lab3_ex1.cu
OUT3P = lab3_ex1_pinned.out
SRC3P = lab3_ex1_pinned.cu
OUT4P = lab4_ex2.out
SRC4P = lab4_ex2.cu

all: $(OUT3) $(OUT3P) $(OUT4P)

$(OUT3): $(SRC3)
	nvcc -arch=sm_60 --default-stream per-thread $< -o $@

$(OUT3P): $(SRC3P)
	nvcc -arch=sm_60 --default-stream per-thread $< -o $@

$(OUT4P): $(SRC4P)
	nvcc -arch=sm_60 --default-stream per-thread $< -o $@

clean:
	rm -f $(OUT3)
	rm -f $(OUT3P)
	rm -f $(OUT4P)
