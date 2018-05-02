using DataFrames

# Read in raw data and
# calculate log-prices
raw = readtable("nymex.csv")
cl = log(raw[:CL])
ho = log(raw[:HO])


# Calculate log-basis
s = ho - cl
