''' Basics '''

import numpy as np
from scipy import optimize

x = np.arange(3)
y = np.arange(3, 6)  # from 3 to 5

# dot product
x*y  # pointwise product
np.sum(x*y)
# equivalent to
x@y

''' ------------- list comprehension ------------- '''
numbers = [1, 2, 3, 4]
squares = []
for n in numbers:
    squares.append(n**2)

# alternatively,
squares2 = [n**2 for n in numbers]
squares2




''' ------------- optimise ------------- '''
optimize.minimize(np.square, 0).x    # (np.square is the function, 0 is the initial guess, .x extracts x that minimises)

optimize.minimize(np.square, 2).x

''' ---------- linear regression from scratch ------------ '''
# note that X here is a placeholder


def my_loss(w):
    s = 0
    for i in range(y.size):
        # Get the true and predicted target values for example 'i'
        y_i_true = y[i]
        y_i_pred = w@X[i]
        s = s + (y_i_true - y_i_pred)**2
    return s

# Returns the w that makes my_loss(w) smallest
w_fit = minimize(my_loss, X[0]).x
print(w_fit)

# this will give the coefficients

# The logistic loss, summed over training examples
def my_loss(w):
    s = 0
    for i in range(y.size):
        raw_model_output = w@X[i]
        s = s + log_loss(raw_model_output * y[i])
    return s





