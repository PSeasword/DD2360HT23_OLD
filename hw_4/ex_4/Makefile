OUT = lab4_ex4.out
SRC = lab4_ex4.cu

all:
	nvcc -arch=sm_60 --default-stream per-thread -lcusparse -lcublas $(SRC) -o $(OUT)

clean:
	rm -f $(OUT)
