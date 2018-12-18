library(readr)
library(rpart)   # recursive partitioning for trees
library(rpart.plot)
library(caret)   # provides confusion matrix 
install.packages('Metrics')
library(Metrics)


credit <- read_csv("data/credit.csv")
head(credit)
dim(credit)  # 1000 rows by 17 col
colnames(credit)

credit_model <- rpart(formula = default ~ ., 
                      data = credit, 
                      method = "class")

# Display the results
rpart.plot(x = credit_model, yesno = 2, type = 0, extra = 0)


# implement train/test split 
n <- nrow(credit)

# Number of rows for the training set (80% of the dataset)
n_train <- round(0.8 * n) 

# Create a vector of indices which is an 80% random sample
set.seed(123)
train_indices <- sample(1:n, n_train)

credit_train <- credit[train_indices, ]  
credit_test <- credit[-train_indices, ]  

?confusionMatrix


# Generate predicted classes using the model object
class_prediction <- predict(object = credit_model,  
                            newdata = credit_test,   
                            type = "class")  

# Calculate the confusion matrix for the test set
confusionMatrix(data = class_prediction,       
                reference = credit_test$default)  

?ce   # classification error 
# Train a gini-based model
credit_model1 <- rpart(formula = default ~ ., 
                       data = credit_train, 
                       method = "class",
                       parms = list(split = 'gini'))

# Train an information-based model
credit_model2 <- rpart(formula = default ~ ., 
                       data = credit_train, 
                       method = "class",
                       parms = list(split = 'information'))

# Generate predictions on the validation set using the gini model
pred1 <- predict(object = credit_model1, 
                 newdata = credit_test,
                 type = 'class')    

# Generate predictions on the validation set using the information model
pred2 <- predict(object = credit_model2, 
                 newdata = credit_test,
                 type = 'class')

# Compare classification error
ce(actual = credit_test$default, 
   predicted = pred1)
ce(actual = credit_test$default, 
   predicted = pred2)  




