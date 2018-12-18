library(MASS)

# generate random data
beta0 <- 3
beta <- c(rep(2, 5), rep(1, 5), rep(0, 5))
beta
length(beta)

sigmae <- 5

sigmaX <- toeplitz(c(1, rep(0.8, 14)))
X.train <- mvrnorm(n = 20, rep(0, 15), sigmaX)
X.train2 <- mvrnorm(n = 100, rep(0, 15), sigmaX)
X.train3 <- mvrnorm(n = 500, rep(0, 15), sigmaX)
X.test <- mvrnorm(n = 1000, rep(0, 15), sigmaX)

corrplot(cor(X.test), method="circle")
dim(X.test)    

# generate response data
generate <- function(input, beta0, beta, errorsd){
  size <- nrow(input)
  output <- beta0 + input %*% beta + rnorm(size, 0, errorsd)
  return (output)
}

### a function to store estimated coef
estimate.coef <- function(t, trainingdata) {

  p <- 16
  beta.store <- matrix(, nrow = p, ncol = t)
  pre.test.store <- matrix(, nrow = 1000, ncol = t)
  error.test.store <- matrix(, nrow = 1000, ncol = t)
  mse.beta <- rep(0, p)
  expec.beta <- rep(0, p)
  bias.beta <- rep(0, p)
  var.beta <- rep(0, p)
  
  for (i in 1:t){
    Y.train <- generate(trainingdata, beta0, beta, sigmae)
    Y.test <- generate(X.test, beta0, beta, sigmae)
  
    train <- data.frame(Y.train, trainingdata)
    test <- data.frame(Y.test, X.test)

# estimate beta
    lm <- lm(Y.train~., data = train)
    beta.store[,i] <- as.numeric(lm$coefficients) 

# predict on testing data
    pre.test.store[,i] <- predict(lm, test[, -1])
    error.test.store[, i] <- pre.test.store[, i] - Y.test
  }
  
# calculate MSE, variance and bias for betas
  mse.beta <- apply((beta.store - c(beta0, beta))^2, 1, mean)
  expec.beta <- apply(beta.store, 1, mean)
  var.beta <- apply((beta.store - expec.beta)^2, 1, mean)
  bias.beta <- (expec.beta - c(beta0, beta))^2
  mse.mean <- mean(mse.beta)
  
return(list(MSE = mse.beta, MEAN = mse.mean, VAR = var.beta, BIAS = bias.beta))
}

# verify
round(mse.beta - var.beta - bias.beta, 2) # correct



# try to calculate mean MSE
# change training data (X.train, X.train3...)
# the more training data there are the smaller MSE
m <- rep(0, 30)
for (i in 1:50){
  m[i] <- estimate.coef(5, X.train3)$MEAN
}
m




