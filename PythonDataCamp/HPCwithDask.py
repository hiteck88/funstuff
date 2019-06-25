''' high performance computing with dask '''
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from dask import delayed

dataPath = '/Users/andrea/Documents/Data/pyDataCamp/'


''' --------------- 1. chunk data --------------- '''
wdiData = pd.read_csv(dataPath + 'WDI.csv')
wdiData.shape  # 91048, 7
wdiData.head()
list(wdiData)  # colnames: country name, country code, indicator name, indicator code, year, value, region

wdiData['Indicator Name'][:5]

# ---------- check the chunked subset type and shapes  ------------ #
# should be mostly chunksize * ncol, apart from the last one

for chunk in pd.read_csv(dataPath + 'WDI.csv', chunksize = 1000):
    print ('type: %s shape %s' % (type(chunk), chunk.shape))


# ----------- filter by chunk -------------- #
dfs = []

# create 2 vectors of whether the corresponding indicators are true
for chunk in pd.read_csv(dataPath + 'WDI.csv', chunksize = 1000):
    # Create the first Series
    # so this 'chunk' is the corresponding smaller subset of WDI data
    is_urban = chunk['Indicator Name']=='Urban population (% of total)'
    # Create the second Series
    is_AUS = chunk['Country Code']=='AUS'

    filtered = chunk.loc[is_urban & is_AUS]

    # Append the filtered chunk to the list dfs
    dfs.append(filtered)

len(dfs)  # 92, and many are empty
# concatenate
df = pd.concat(dfs)
len(df)   # 36 now
df
# plot it
df.plot.line(x='Year', y='value')
plt.ylabel('% Urban population')

# Call plt.show()
plt.show()


''' ============== 2. filter and summing with generators =============== '''
# get how many true
a = pd.Series([True, False, True])
a.sum()

### this is how to use formatted strings

name = 'bob'
'Hello, {}'.format(name)
month = 1
'flightdelays/flightdelays-2016-{}.csv'.format(month)


flightdelayData = pd.read_csv(dataPath + 'flightdelays/flightdelays-2016-1.csv')
flightdelayData[:1]
list(flightdelayData)
(flightdelayData['DEP_DELAY']>0).sum()
flightdelayData.shape

# ---------- function for percentage delayed ---------- #
def pct_delayed(df):
    # Compute number of delayed flights: n_delayed
    n_delayed = (df['DEP_DELAY'] > 0).sum()
    # Return percentage of delayed flights
    return n_delayed  * 100 / len(df)

# ---------- apply the same function to a list of dataframes ---------- #

# automatically generate 5 months
template = dataPath + 'flightdelays/flightdelays-2016-{}.csv'

# generator object, similar to list comprehension
filenames = (template.format(i) for i in range(1, 6))  # from 1 to 5

filenames  # it won't print directly, use a loop
for fname in filenames:
    print (fname)

# alternatively, use the list comprehension
filenameList = [template.format(i) for i in range(1, 6)]

filenameList[1] ###### this is a generator object, can't subscribe

next(filenames)
print (filenames)
pd.read_csv(filenames[1])

names = []



# Define the generator: dataframes
dataframes = (pd.read_csv(file) for file in filenames)
dataframes  # this will be a generator object
for df in dataframes:
    print (df)


# Create the list comprehension: monthly_delayed
monthly_delayed = [pct_delayed(df) for df in dataframes]



''' ============== 3. with dask ============ '''

# ------------ 1. define delayed functions -------------- #
# first decorated function using decorator function 'delayed' from dask
# read csv on a single file
@delayed
def read_one(filename):
    return pd.read_csv(filename)

# Define count_flights
@delayed
def count_flights(df):
    return len(df)

# Define count_delayed
@delayed
def count_delayed(df):
    return (df['DEP_DELAY']>0).sum()

# Define pct_delayed
@delayed
def pct_delayed(n_delayed, n_flights):
    return 100 * sum(n_delayed) / sum(n_flights)



# ------------ 2. construct the pipeline ------------- #

filenameList = [template.format(i) for i in range(1, 6)]
filenameList[0]


n_delayed = []
n_flights = []

# Loop over the provided filenames list and call read_one: df
for file in filenameList:
    df = read_one(file)

    # Append to n_delayed and n_flights
    n_delayed.append(count_delayed(df))
    n_flights.append(count_flights(df))

# Call pct_delayed with n_delayed and n_flights: result
result = pct_delayed(n_delayed, n_flights)

# Print the output of result.compute()
print(result.compute())

result.visualize()

from IPython.display import display, Image
display(result.visualize())

