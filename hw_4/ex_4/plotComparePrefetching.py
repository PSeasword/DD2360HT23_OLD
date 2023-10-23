import matplotlib.pyplot as plt
from google.colab import files

dimXVals = []
prefetchingVals = []
nstepsVals = []
valsFLOPS = []

microSeconds = 0
countFLOP = 0

with open("outputPrefetching.txt", "r") as file:
  for line in file:
    if "Prefetching is set to" in line:
      prefetchingVals.append(int(line.split("to")[1].strip()))

    elif "The X dimension of the grid is" in line:
      dimXVals.append(int(line.split("is")[1].strip()))

    elif "The number of time steps to perform is" in line:
      nstepsVals.append(int(line.split("is")[1].strip()))

    elif "Timing - Computing the SMPV." in line:
      microSeconds = int(line.split("Elapsed")[1].split("microseconds")[0].strip())

    elif "FLOP count in SMPV:" in line:
      countFLOP = int(line.split(":")[1].strip())
      resultingMFLOPS = round(countFLOP / microSeconds, 2)

      valsFLOPS.append(resultingMFLOPS)

dimXCurrent = []
currentFLOPS = []

entriesLegend = []
currentMarker = 0
markers = ["o", "o", "x", "x", "^", "^", "|", "|"]

for i in range(len(dimXVals)):
  dimXCurrent.append(dimXVals[i])
  currentFLOPS.append(valsFLOPS[i])

  if i == len(dimXVals)-1 or nstepsVals[i+1] != nstepsVals[i] or prefetchingVals[i+1] != prefetchingVals[i]:
    plt.plot(dimXCurrent, currentFLOPS, "-" + markers[currentMarker])
    currentMarker += 1

    if prefetchingVals[i-1] == 0:
      entriesLegend.append(str(nstepsVals[i]) + " nsteps Without Prefetching")
    else:
      entriesLegend.append(str(nstepsVals[i]) + " nsteps With Prefetching")

    dimXCurrent = []
    currentFLOPS = []

plt.xlabel("dimX")
plt.ylabel("Throughput [MFLOPS]")
plt.title("Throughput With and Without Prefetching")
plt.legend(entriesLegend, fontsize="8")
plt.grid(True)
plt.savefig("ex4_prefetching.svg", format="svg")
plt.show()

files.download("ex4_prefetching.svg")
