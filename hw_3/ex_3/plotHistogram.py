import matplotlib.pyplot as plt
import numpy as np
from google.colab import files

binsString = []
bins = []

with open("output.txt", "r") as file:
    for line in file:
      if "Bins:" in line:
        binsString = line.split(":")[1].strip().split(", ")

for bin in binsString:
  bins.append(float(bin))

plt.bar(range(1, 4097), bins, width=1)
plt.xlabel("Bin")
plt.ylabel("Number of Occurrences")
plt.xlim([1, 4096])
plt.title("Histogram of Input Values")
plt.grid(True)
plt.savefig("ex3_histogram.svg", format="svg")
plt.show()

files.download("ex3_histogram.svg")
