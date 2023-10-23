import matplotlib.pyplot as plt
import numpy as np
from google.colab import files

outputs = ["output_lab3_ex1.txt", "output_lab3_ex1_pinned.txt", "output_lab4_ex2.txt"]

valsLab3Ex1 = [[], []]
valsLab3Ex1Pinned = [[], []]
valsLab4Ex2 = [[], []]

for output in outputs:
  currentVals = [[], []]

  if output == outputs[0]:
    currentVals = valsLab3Ex1
  elif output == outputs[1]:
    currentVals = valsLab3Ex1Pinned
  elif output == outputs[2]:
    currentVals = valsLab4Ex2

  with open(output, "r") as file:
    for line in file:
        if "The input length is" in line:
          currentVals[0].append(float(line.split("is")[1].strip()))
        elif "Total time (s):" in line:
          currentVals[1].append(float(line.split(":")[1].strip()))

plt.plot(valsLab3Ex1[0], valsLab3Ex1[1], "-o")
plt.plot(valsLab3Ex1Pinned[0], valsLab3Ex1Pinned[1], "-x")
plt.plot(valsLab4Ex2[0], valsLab4Ex2[1], "-*")
plt.xlabel("Input Length")
plt.ylabel("Total Execution Time [s]")
plt.title("Memory Transfer and Kernel Execution Time")
plt.legend(["vecAdd", "vecAdd Pinned", "vecAdd Pinned and Asynchronous"])
plt.grid(True)
plt.savefig("ex2_comparison.svg", format="svg")
plt.show()

files.download("ex2_comparison.svg")
