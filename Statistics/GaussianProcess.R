# some examples from Rasmussen and Williams book, chapter 2
# GP regression 

require(MASS)
require(reshape2)
require(ggplot2)

set.seed(123)

x_predict <- seq(-5,5,len=20)  # some x data
l <- 2  # scale para for covariance
# this parameter controls how wide the covariance band is, the larger, the wider
# i.e. the more x will be correlated

# idea: f(x1), ... f(xn) are jointly Gaussian
# let n = 3, treat each one as a point with 50 dimensions, or, each one a function with 50 inputs
# x1, x2, x3 each has 50 observations


# use squared exponential (SE, or radial basis)
# this is a function for outputs f(x), not directly for input x
# but somehow it's defined through input x. 
SE <- function(Xi, Xj, l) exp(-0.5 * (Xi - Xj) ^ 2 / l ^ 2)  

cov <- function(X, Y) outer(X, Y, SE, l)   # if it's inner product, only 1 value will print out 

## equivalently, Sigma[i,j] <- exp(-0.5/l*(abs(X1[i]-X2[j]))^2)
# in this way there are 50 by 50.
# a value from sample1 

COV <- cov(x_predict, x_predict)    # ?why use this vector as the base? 
corrplot::corrplot(COV)



# generate some functions for the process
# mean: vector of 50 values
# var: defined above
values <- mvrnorm(30, rep(0, length=length(x_predict)), COV)
dim(values)

sample1 <- values[1, ]
sample2 <- values[2, ]
sample3 <- values[3, ]
plot(sample1)
hist(sample1)
hist(sample2)
hist(sample3)


# each sample itself isn't normally distributed
# each column (feature, predictor) is normal
hist(values[, 20])

corrplot::corrplot(cor(values)) 

corrplot::corrplot(cor(t(values)))   # this has no meaning

# as the sample size increases, these 50 points will be more correlated 
# according to designed. 
# in fact I think it's quite misleading to plot each sample (50 features), it is 
# as meaningless as plotting values of 50 points for any linear regression

# the generation from multivariate normal is the same as what we usually do, 
# for 10 covariates we generate 10 values with a specified 10 by 10 cov-matrix
# the difference is the way of specifying covariance


# actually it might be wrong to think these 50 points are a features
# they are 1 outcome (for 50 different x from -5 to 5) scenarios. it's one y
cov(sample1, sample2)



### compare with the usual way of generating X given some correlation structure
sig <- toeplitz()
mvrnorm(200, rep(0, length=length(x_predict)), COV)


sigmaX <- toeplitz(c(1, rep(0.2, 14)))
X <- mvrnorm(n = 100, rep(0, 15), sigmaX) # 20*15
corrplot::corrplot(cor(X))
hist(X[1, ])
hist(X[, 1])
plot(X[1, ])

# --------------------- posterior dist given some data

obs <- data.frame(x = c(-4, -3, -1,  0,  2),
                  y = c(-2,  0,  1,  2, -1))

plot(obs)   # very non-linear relationship between x and y
# so there are 5 observations now, seems x is univariate (instead of 20)
# then what are those 20 points corresponding to each observation? 
# the points 20 are arbitrary. just to show the function f(x) is smooth
# although that means we need to evaluate larger cov matrix
# the range of x in the prior is more important than the 20 points


cov_xx_inv <- solve(cov(obs$x, obs$x))
Ef <- cov(x_predict, obs$x) %*% cov_xx_inv %*% obs$y   # 20 by 1
Cf <- cov(x_predict, x_predict) - cov(x_predict, obs$x)  %*% cov_xx_inv %*% cov(obs$x, x_predict)


# here K(xp, xobs) is 20 by 5. if we make more points in the prior, K will be larger


corrplot::corrplot(Cf)   # interesting, most covariance disappeared

values <- mvrnorm(3, Ef, Cf)
values
sample1 <- values[1, ]
sample2 <- values[2, ]
sample3 <- values[3, ]
plot(sample1)
points(sample2, type = 'l', col = 'blue')
points(sample3, type = 'l', col = 'red')












