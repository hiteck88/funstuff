'''
linear classifiers suggest that the decision boundary is linear (or a hyperplane).
This also explains intuitively why would a non-linear classifier (SVM) overfit.

'''

import sklearn.datasets

newsgroups = sklearn.datasets.fetch_20newsgroups_vectorized()

X, y = newsgroups.data, newsgroups.target

X.shape  # 11314 by 130107
print (X)
y.shape

y[:5]   # this way to print out head is quite neat
# integers
type(y)

''' 
KNN 
'''
# try a classifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split

xTrain, xTest, yTrain, yTest = train_test_split(X, y)


knn = KNeighborsClassifier(n_neighbors= 1)
knn.fit(xTrain, yTrain)

ypred = knn.predict(xTest)
ypred

knn.score(xTest, yTest)



''' logistic regression '''

from sklearn.linear_model import LogisticRegression
lr = LogisticRegression()
lr.fit(X_train, y_train)
lr.predict(X_test)
# lr.predict_proba(data), this will give confidence score (interval??)

lr.score(X_test, y_test)






''' LinearSVC: linear support vector classifier '''

from sklearn.svm import LinearSVC
svm = LinearSVC()
svm.fit(X_train, y_train)
svm.score()


''' (non linear) SVC 
this is supposed to overfit .. '''
from sklearn.svm import SVC

svm = SVC()  # default hyperparameters


# it is possible to write a for loop for these 4 classifiers
classifiers = [LogisticRegression(),
               SVC(),
               LinearSVC(),
               KNeighborsClassifier()]

for c in classifiers:
    c.fit(X, y)

# to plot decision boundary, need to define a separate function
wine = sklearn.datasets.load_wine()



''' -------------- SGD classifier -------------- '''


# We set random_state=0 for reproducibility
linear_classifier = SGDClassifier(random_state=0)

# Instantiate the GridSearchCV object and run the search
parameters = {'alpha':[0.00001, 0.0001, 0.001, 0.01, 0.1, 1],
             'loss':['hinge', 'log'], 'penalty':['l1', 'l2']}
searcher = GridSearchCV(linear_classifier, parameters, cv=10)
searcher.fit(X_train, y_train)

# Report the best parameters and the corresponding score
print("Best CV params", searcher.best_params_)
print("Best CV accuracy", searcher.best_score_)
print("Test accuracy of best grid search hypers:", searcher.score(X_test, y_test))



