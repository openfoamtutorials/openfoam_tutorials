#!/usr/bin/python

"""
This extracts the sigmaEq field from the log file.
"""

log_file = "log"
sigma_file = "sigmaEq"

with open(sigma_file, 'w') as wf:
  with open(log_file, 'r') as rf:
    for line in rf:
      # format of line is: Max sigmaEq = 5.22596e+06
      if "sigmaEq" in line:
        value = line.strip().split()[3]
        wf.write(value+"\n")
