from google.colab import files

microSeconds = 0
countFLOP = 0
row = ""

with open("outputDifferentDimX.txt", "r") as file:
  for line in file:
    if "The X dimension of the grid is" in line:
      row += line.split("is")[1].strip()

    elif "The number of time steps to perform is" in line:
      row += " & " + line.split("is")[1].strip()

    elif "Timing - Computing the SMPV." in line:
      foundMicroSeconds = line.split("Elapsed")[1].split("microseconds")[0].strip()
      microSeconds = int(foundMicroSeconds)
      row += " & " + foundMicroSeconds

    elif "FLOP count in SMPV:" in line:
      foundCountFLOP = line.split(":")[1].strip()
      countFLOP = int(foundCountFLOP)
      resultingMFLOPS = round(countFLOP / microSeconds, 2)
      row += " & " + foundCountFLOP + " & " + str(resultingMFLOPS) + " \\\ \hline"

      print(row)

      microSeconds = 0
      countFLOP = 0
      row = ""
