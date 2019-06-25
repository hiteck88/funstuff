''' Logistic regression using sklearn '''

lr = LogisticRegression()
lr.fit(X, y)

# get the 11th output
lr.predict(X)[10]

# from equation: beta * x + beta0
# less than 0: negative
# greater than 0: positive

lr.coef_@X[10] + lr.intercept_


# Mathematical functions for logistic and hinge losses
def log_loss(raw_model_output):
   return np.log(1+np.exp(-raw_model_output))
### note that log loss is different from logistic function!!!
### logistic function: f(XB) = 1/(1+exp(-XB))


def hinge_loss(raw_model_output):
   return np.maximum(0,1-raw_model_output)

# Create a grid of values and plot

import matplotlib.pyplot as plt
grid = np.linspace(-2,2,1000)
plt.plot(grid, log_loss(grid), label='logistic')
plt.plot(grid, hinge_loss(grid), label='hinge')
plt.legend()
plt.show()


''' regularization, lower the training accuracy and improve the test accuracy '''

# not sure what the C represents: inverse regularization strength?

lr_weak_reg = LogisticRegression(C = 100)
lr_strong_reg = LogisticRegression(C = 0.1)

# fit and check score
lr_weak_reg.fit(X_train, y_train)
lr_weak_reg.score(X_train, y_train)


# L1 and L2 reg
lr_L1 = LogisticRegression(penalty = 'l1')  # without specifying, l2 is default



''' --------- carry out a grid search for best C ---------- '''
# Train and validaton errors initialized as empty list
train_errs = list()
valid_errs = list()

# Loop over values of C_value
for C_value in [0.001, 0.01, 0.1, 1, 10, 100, 1000]:
    # Create LogisticRegression object and fit
    lr = LogisticRegression(C=C_value)
    lr.fit(X_train, y_train)

    # Evaluate error rates and append to lists
    train_errs.append(1.0 - lr.score(X_train, y_train))
    valid_errs.append(1.0 - lr.score(X_valid, y_valid))

# Plot results
plt.semilogx(C_values, train_errs, C_values, valid_errs)
plt.legend(("train", "validation"))
plt.show()


''' ------------ with feature selection via lasso ----------- '''
# Specify L1 regularization
lr = LogisticRegression(penalty = 'l1')

# Instantiate the GridSearchCV object and run the search
searcher = GridSearchCV(lr, {'C':[0.001, 0.01, 0.1, 1, 10]})
searcher.fit(X_train, y_train)

# Report the best parameters
print("Best CV params", searcher.best_params_)

# Find the number of nonzero coefficients (selected features)
best_lr = searcher.best_estimator_
coefs = best_lr.coef_
print("Total number of features:", coefs.size)
print("Number of selected features:", np.count_nonzero(coefs))



''' -------------- as probability ------------ '''





''' -------------- multiclass via multinomial (softmax) ------------ '''

lr_mn = LogisticRegression(multi_class = 'multinomial', solver = 'lbfgs')






