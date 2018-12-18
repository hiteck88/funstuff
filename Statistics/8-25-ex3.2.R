setwd('/Users/andrea/Documents/Programming/R')
install.packages('leaps')
library(leaps)
library(mvtnorm)
library(MASS)


# generate random data
beta0 <- 3
beta <- c(rep(2, 5), rep(1, 5), rep(0, 5))

sigmae <- 5

sigmaX <- toeplitz(c(1, rep(0.8, 14)))




X.train <- mvrnorm(n = 20, rep(0, 15), sigmaX)
X.test <- mvrnorm(n = 1000, rep(0, 15), sigmaX)

# generate response data
generate <- function(input, beta0, beta, errorsd){
  size <- nrow(input)
  output <- beta0 + input %*% beta + rnorm(size, 0, errorsd)
  return (output)
}
Y.train <- generate(X.train, beta0, beta, sigmae)


# ------------- best subset selection using leaps

subset <- leaps(X.train, Y.train, int = T, nbest = 1, method = 'r2')$which
label <- leaps(X.train, Y.train, int = T, nbest = 1, method = 'r2')$label
size <- leaps(X.train, Y.train, int = T, nbest = 1, method = 'r2')$size
r2 <- leaps(X.train, Y.train, int = T, nbest = 1, method = 'r2')$r2

# this has calculated the best subset combination for each size



# create sub training X

X.new <- X.train[, - which(subset[13 ,] == 0)]
data <- data.frame(y = Y.train, X = X.train)
head(data)



### data generator
data.gen <- function(row, input){
  
  if (row == 1){
    X1 <- input[, - which(subset[1 ,] == 0)]
    data <- data.frame(Y.train, X1)
  } else{
    if (row == ncol(input)){
      data <- data.frame(Y.train, input)
    }else{
    data <- data.frame(Y.train, input[, - which(subset[row,] == 0)])
    }
    }
    return(data)
}

# then need to do CV for 18 vs 2 data

mean.rss.1 <- function(kCV, data){

  n <- nrow(data)
  k <- kCV
  for (i in 1:k){
  
   sub.data.test <- data[(n/k*(i-1)+1) : (n/k*i), ]
   sub.data.train <- data[-((n/k*(i-1)+1) : (n/k*i)), ]
   lm <- lm(Y.train ~., data = sub.data.train)
  
   # then predict
   new <- data.frame(X1 = sub.data.test[, -1])
   error <- predict(lm, new) - sub.data.test[,1]
  
   # calculate the rss
   RSS <- mean(sapply(error, function(a) a^2))
  }
  
  return(RSS)
}
mean.rss <- function(kCV, data){
  
  n <- nrow(data)
  k <- kCV
  for (i in 1:k){
    
    sub.data.test <- data[(n/k*(i-1)+1) : (n/k*i), ]
    sub.data.train <- data[-((n/k*(i-1)+1) : (n/k*i)), ]
    lm <- lm(Y.train ~., data = sub.data.train)
    
    # then predict
    new <- data.frame(sub.data.test[, -1])
    error <- predict(lm, new) - sub.data.test[,1]
    
    # calculate the rss
    RSS <- mean(sapply(error, function(a) a^2))
  }
  
  return(RSS)
}

# store RSS
iteration <- 100 


rss.store <- matrix(, 15, iteration)

for (s in c(20, 50, 75, 100, 200))
  
rss.f <- function(size){  
  for (t in (1:iteration)){
    
    X.train <- mvrnorm(n = size, rep(0, 15), sigmaX)
    Y.train <- generate(X.train, beta0, beta, sigmae)
    rss.store[1,t] <- mean.rss.1(10, data.gen(1, X.train))

    for (j in 2:15){
      rss.store[j,t] <- mean.rss(10, data.gen(j, X.train))
    }
    
  rss.final <- apply(rss.store, 1, mean)
  }
  return(rss.final)
}
rss.f(20)  


plot(rss.f(20), type = 'l', xlab = 'number of coef')






