import matplotlib.pyplot as plt
import numpy as np
from google.colab import files

dataType = "double"

matrixDims = []
hostToDevice = []
kernel = []
deviceToHost = []

table = ""

with open("output.txt", "r") as file:
    for line in file:
      if "Input matrix dim" in line:
        dim = line.split("dim")[1].strip()
        matrixDims.append(dim)
        table += dim
      elif "cudaMemcpy (host to device) time (s):" in line:
        time = line.split(":")[1].strip()
        hostToDevice.append(float(time))
        table += " & " + time
      elif "gemm kernel time (s):" in line:
        time = line.split(":")[1].strip()
        kernel.append(float(time))
        table += " & " + time
      elif "cudaMemcpy (device to host) time (s):" in line:
        time = line.split(":")[1].strip()
        deviceToHost.append(float(time))
        table += " & " + time + " \\\ \hline \n"

with open("table.txt", "w") as file:
  file.write(table)

print("Exact values for LaTeX can be found in table.txt")

hostToDevice = np.array(hostToDevice)
kernel = np.array(kernel)
deviceToHost = np.array(deviceToHost)

plt.bar(matrixDims, hostToDevice)
plt.bar(matrixDims, kernel, bottom=hostToDevice)
plt.bar(matrixDims, deviceToHost, bottom=hostToDevice+kernel)
plt.xlabel("Matrix Dimensions")
plt.ylabel("Execution Time [s]")
plt.xticks(matrixDims, rotation=45, ha='right')
plt.title("Execution Time for cudaMemcpy and gemm Kernel (" + dataType + ")")
plt.legend(["Host to Device", "gemm Kernel", "Device to Host"])
plt.grid(True)
plt.savefig("ex2_stacked_" + dataType + ".svg", format="svg")
plt.show()

files.download("ex2_stacked_" + dataType + ".svg")
