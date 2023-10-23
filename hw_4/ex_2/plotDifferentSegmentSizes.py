import matplotlib.pyplot as plt
from google.colab import files

outputs = ["output_segment_4.txt", "output_segment_varying.txt"]

vals4 = [[], []]
valsVarying = [[], []]

for output in outputs:
  currentVals = [[], []]

  if output == outputs[0]:
    currentVals = vals4
  elif output == outputs[1]:
    currentVals = valsVarying

  with open(output, "r") as file:
    for line in file:
        if "The segment size is" in line:
          currentVals[0].append(float(line.split("is")[1].strip()))
        elif "Total time (s):" in line:
          currentVals[1].append(float(line.split(":")[1].strip()))

plt.plot(vals4[0], vals4[1], "-o")
plt.plot(valsVarying[0], valsVarying[1], "-x")
plt.xlabel("Segment Size")
plt.ylabel("Total Execution Time [s]")
plt.title("Memory Transfer and Kernel Execution Time")
plt.legend(["4 Streams", "Varying Streams"])
plt.grid(True)
plt.savefig("ex2_segment_sizes.svg", format="svg")
plt.show()

files.download("ex2_segment_sizes.svg")

plt.clf()

plt.plot(vals4[0], vals4[1], "-o")
plt.plot(valsVarying[0], valsVarying[1], "-x")
plt.xlabel("Segment Size")
plt.ylabel("Total Execution Time [s]")
plt.ylim([0.15, 0.2]);
plt.title("Memory Transfer and Kernel Execution Time (Zoomed)")
plt.legend(["4 Streams", "Varying Streams"])
plt.grid(True)
plt.savefig("ex2_segment_sizes_zoomed.svg", format="svg")
plt.show()

files.download("ex2_segment_sizes_zoomed.svg")
