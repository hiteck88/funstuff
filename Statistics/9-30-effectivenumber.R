setwd('/Users/andrea/Documents/Programming/R')
install.packages('psych')
library(psych)
library(mvtnorm)
library(MASS)

# generate random data
beta0 <- 3
beta <- c(rep(2, 5), rep(1, 5), rep(0, 5))
sigmae <- 5

sigmaX <- toeplitz(c(1, rep(0.8, 14)))

X <- mvrnorm(n = 20, rep(0, 15), sigmaX) # 20*15
S <- X %*% (solve(t(X) %*% X)) %*% t(X)
tr(S)    # effective number of parameters

# try another thing
generate <- function(input, beta0, beta, errorsd){
  size <- nrow(input)
  output <- beta0 + input %*% beta + rnorm(size, 0, errorsd)
  return (output)
}
Y <- generate(X, beta0, beta, sigmae) #20*1


data <- data.frame(Y, X)

mod <- lm(Y~., data = data)
summary(mod)
Y.new <- predict(mod, new = data[, -1])


err <- sum((Y - Y.new)^2)/(20)  # error estimation
df <- cov(Y, Y.new)/6.918^2  # effective df


# ----------------- try more data

X2 <- mvrnorm(n = 200, rep(0, 15), sigmaX) # 20*15
S2 <- X2 %*% (solve(t(X2) %*% X2)) %*% t(X2)
tr(S2)
Y2 <- generate(X2, beta0, beta, sigmae)
data2 <- data.frame(Y2, X2)
dim(data2)
mod2 <- lm(Y2~., data = data2)
summary(mod2)
Y.new2 <- predict(mod2, new = data2[, -1])


err2 <- sum((Y2 - Y.new2)^2)/(200)  # error estimation
df2 <- cov(Y2, Y.new2)/4.667^2  # effective df
df2


### --------another data set
X3 <- mvrnorm(n = 1000, rep(0, 15), sigmaX) # 20*15
S3 <- X3 %*% (solve(t(X3) %*% X3)) %*% t(X3)
tr(S3)
Y3 <- generate(X3, beta0, beta, sigmae)
data3 <- data.frame(Y3, X3)
dim(data3)
mod3 <- lm(Y3~., data = data3)
summary(mod3)
Y.new3 <- predict(mod3, new = data3[, -1])


err3 <- sum((Y3 - Y.new3)^2)/(1000)  # error estimation
df3 <- cov(Y3, Y.new3)/err3  # effective df
df3

cov(Y3, Y.new3)/4.939^2




