import matplotlib.pyplot as plt
import numpy as np
from google.colab import files

outputs = ["B_10.vtk", "E_10.vtk", "rhoe_10.vtk", "rhoi_10.vtk", "rho_net_10.vtk"]

for output in outputs:
  valsCPU = []
  valsGPU = []

  with open("dataCPU/" + output, "r") as file:
    for line in file:
      try:
        valsCPU.append(float(line.split()[0]))
      except:
        pass

  with open("dataGPU/" + output, "r") as file:
    for line in file:
      try:
        valsGPU.append(float(line.split()[0]))
      except:
        pass

  plt.plot(valsCPU)
  plt.plot(valsGPU)
  plt.xlabel("Sample")
  plt.ylabel("Value")
  plt.title("Output Values for " + output)
  plt.legend(["CPU", "GPU"])
  plt.grid(True)
  plt.savefig("ex4_" + output.replace(".vtk", "") + ".svg", format="svg")
  plt.show()

  files.download("ex4_" + output.replace(".vtk", "") + ".svg")
