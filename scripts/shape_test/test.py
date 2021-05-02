import numpy as np
import math
import matplotlib.pyplot as plt

MAX_VAL = 16777215
TICKS = 20000

## reads the file, determines the period, then assemble
## sqr, sin and tri waves 
def plot_distortion(file_name, mode, period):
  f = open(file_name, "r")
  sqr_wave = []
  sin_wave = []
  tri_wave = []
  for i in range(period):
    l = f.readline()
    tmp = l.split()
    sin = int(tmp[0])
    sqr = int(tmp[1])
    tri = int(tmp[2])
    sqr_wave.append(sqr)
    tri_wave.append(tri)
    sin_wave.append(sin)
  time = np.arange(0, math.pi, math.pi/period)
  ref_sin = reference_sin(period, MAX_VAL)
  ref_sqr = reference_sqr(period, MAX_VAL)
  ref_tri = reference_tri(period, MAX_VAL)
  if mode == "sin":
    plt.plot(time, sin_wave, label="sin")
    plt.plot(time, ref_sin, label="sin_ref")
    plt.legend(["reference waveform", "actual waveform"])
    plt.savefig("sin" + str(period) + ".png")
    plt.show()
    diff = 0
    for i in range(period):
      diff += abs(ref_sin[i]-sin_wave[i])/MAX_VAL
    print("sin" + str(period) + ": " + str(100*diff/period) + "%")
  elif mode == "tri":
    print(ref_tri, tri_wave)
    plt.plot(time, tri_wave, label="tri")
    plt.plot(time, ref_tri, label="tri_ref")
    plt.legend(["reference waveform", "actual waveform"])
    plt.savefig("tri" + str(period) + ".png")
    plt.show()
    diff = 0
    for i in range(period):
      diff += abs(ref_tri[i]-tri_wave[i])/MAX_VAL
    print("tri" + str(period) + ": " + str(100*diff/period) + "%")
  else:
    print(ref_sqr, sqr_wave)
    plt.plot(time, sqr_wave, label="sqr")
    plt.plot(time, ref_sqr, label="sqr_ref")
    plt.legend(["reference waveform", "actual waveform"])
    plt.savefig("sqr" + str(period) + ".png")
    plt.show()
    diff = 0
    for i in range(period):
      diff += abs(ref_sqr[i]-sqr_wave[i])/MAX_VAL
    print("sqr" + str(period) + ": " + str(100*diff/period) + "%")

def reference_sin(period, amplitude):
  time2 = np.arange(math.pi, 3*math.pi, math.pi/(0.5*period))
  ref_sin = MAX_VAL/2 * np.cos(time2)
  tmp = [i+MAX_VAL/2 for i in ref_sin]
  res = tmp[1:]
  res += [tmp[0]]
  return res

def reference_sqr(period, amplitude):
  half = period//2
  res = []
  for i in range(half-1):
    res.append(0)
  res += [amplitude] * (period - len(res)-1)
  res += [0]
  return res

def reference_tri(period, amplitude):
  half = period // 2
  step = amplitude / (half)
  acc = 0
  res = []
  for i in range(half):
    acc += step
    res.append(acc)
  for i in range(period-half):
    acc -= step
    res.append(acc)
  return res

if __name__ == "__main__":
  # plot_distortion("distortion_p=50", "sin", 50)
  # plot_distortion("distortion_p=50", "tri", 50)
  # plot_distortion("distortion_p=50", "sqr", 50)
  plot_distortion("distortion_p=500", "sin", 500)
  plot_distortion("distortion_p=500", "tri", 500)
  plot_distortion("distortion_p=500", "sqr", 500)
  plot_distortion("distortion_p=5000", "sin", 5000)
  plot_distortion("distortion_p=5000", "tri", 5000)
  plot_distortion("distortion_p=5000", "sqr", 5000)