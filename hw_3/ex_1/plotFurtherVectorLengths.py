import matplotlib.pyplot as plt
import numpy as np
from google.colab import files

inputLengths = []
hostToDevice = []
kernel = []
deviceToHost = []

with open("output_vector_lengths.txt", "r") as file:
    for line in file:
      if "The input length is" in line:
        inputLengths.append(line.split("is")[1].strip())
      elif "cudaMemcpy (host to device) time (s):" in line:
        hostToDevice.append(float(line.split(":")[1].strip()))
      elif "vecAdd kernel time (s):" in line:
        kernel.append(float(line.split(":")[1].strip()))
      elif "cudaMemcpy (device to host) time (s):" in line:
        deviceToHost.append(float(line.split(":")[1].strip()))

hostToDevice = np.array(hostToDevice)
kernel = np.array(kernel)
deviceToHost = np.array(deviceToHost)

plt.bar(inputLengths, hostToDevice)
plt.bar(inputLengths, kernel, bottom=hostToDevice)
plt.bar(inputLengths, deviceToHost, bottom=hostToDevice+kernel)
plt.xlabel("Vector Length")
plt.ylabel("Execution Time [s]")
plt.xticks(inputLengths, rotation=45, ha='right')
plt.title("Execution Time for cudaMemcpy and vecAdd Kernel")
plt.legend(["Host to Device", "vecAdd Kernel", "Device to Host"])
plt.grid(True)
plt.savefig("ex1_stacked.svg", format="svg")
plt.show()

files.download("ex1_stacked.svg")
