# ------------ Titanic data

import numpy as np
import pandas as pd

titanic = pd.read_csv('titanic_all_numeric.csv')

print (list(titanic.columns.values))  # print out the column names
# print (titanic.describe())
# print (titanic.head())

# print (titanic['age'].max())

# -------------- start training

import keras
from keras.layers import Dense
from keras.models import Sequential
from keras.utils import to_categorical



titanic.survived = titanic['survived']
predictors = titanic[titanic.columns[1:11]]
target = to_categorical(titanic.survived)    # Convert the target to categorical: target
n_cols = predictors.shape[1]

# Set up the model
model = Sequential()

# Add the first layer
model.add(Dense(32, activation = 'relu', input_shape = (n_cols, )))

# Add the output layer
model.add(Dense(2, activation = 'softmax'))

# Compile the model
model.compile(optimizer = 'sgd', loss = 'categorical_crossentropy', metrics = ['accuracy'])

# Fit the model
model.fit(predictors, target)

'''
predictions = model.predict(pred_data)   # when we have new data

# Calculate predicted probability of survival: predicted_prob_true
predicted_prob_true = predictions[:, 1]



hist = model.fit(predictors, target, validation_split = 0.3)  # with validation 

# ------------ early stopping 

from keras.callbacks import EarlyStopping

# Define early_stopping_monitor
early_stopping_monitor = EarlyStopping(patience =2)

# Fit the model
model.fit(predictors, target, validation_split = 0.3, epochs = 30, callbacks = [early_stopping_monitor]) 


'''




