import numpy as np
import pandas as pd

import keras
from keras.layers import Dense
from keras.models import Sequential
from keras.utils import to_categorical

mnist = pd.read_csv('mnist.csv')
X = mnist[mnist.columns[1:785]]
y = mnist[mnist.columns[0]]


# Create the model: model
model = Sequential()

# Add the first hidden layer
model.add(Dense(50, activation = 'relu', input_shape = (784, )))

# Add the second hidden layer
model.add(Dense(50, activation = 'relu', input_shape = (784, )))

# Add the output layer
model.add(Dense(10, activation = 'softmax'))   # here it's problematic because we don't have enough classses in teh data set!


# Compile the model
model.compile(optimizer = 'adam', loss = 'categorical_crossentropy', metrics = ['accuracy'])


# Fit the model
model.fit(X, y, validation_split = 0.3)


