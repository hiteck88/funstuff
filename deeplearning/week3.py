# ------------------- load the data

import numpy as np
import pandas as pd

df = pd.read_csv('hourly_wages.csv')

print (list(df.columns.values))  # print out the column names
print (df.describe())

'''
type(df)   # data frame
df.iloc[0:5:, 0]  # one way to select the columns without giving the names 
df.head(n = 5)
'''

# numpy_matrix = df.values()
response = df.iloc[:, 0]
type(response)
type(response.values)  # here converted to numpy array

Predictors = df[df.columns[1:10]]  # predictors.head(n = 5)
predictors = Predictors.values  # the same as np.asarray(predictors)







# ---------------- Import necessary modules
import keras
from keras.layers import Dense        # layer constructor
from keras.models import Sequential   # model constructor



# the predictors are a numpy matrix
# outcome is also a numpy matrix
# Save the number of columns in predictors: n_cols
n_cols = predictors.shape[1]  # 534 by 9

# Set up the model: model
model = Sequential()

# Add the first layer
# Dense means each node is connected to each one
model.add(Dense(50, activation='relu', input_shape=(n_cols, )))  # n_col items in each row of data

model.add(Dense(32, activation='relu', input_shape=(n_cols, )))  # Add the second layer

model.add(Dense(1))  # Add the output layer

# print (model)  # this is a keras engine sequential object

# Compile and fit the model
model.compile(optimizer = 'adam', loss = 'mean_squared_error')

model.fit(predictors, response)




