import matplotlib.pyplot as plt
from google.colab import files

nstepsVals = []
relativeError = []

with open("outputDifferentNSteps.txt", "r") as file:
  for line in file:
    if "The number of time steps to perform is" in line:
      nstepsVals.append(int(line.split("is")[1].strip()))

    elif "The relative error of the approximation is" in line:
      relativeError.append(float(line.split("is")[1].strip()))

plt.plot(nstepsVals, relativeError)
plt.xlabel("nsteps")
plt.ylabel("Relative Error")
plt.title("Relative Error of the Approximation for Different nsteps")
plt.grid(True)
plt.savefig("ex4_nsteps.svg", format="svg")
plt.show()

files.download("ex4_nsteps.svg")
