setwd('/Users/andrea/Documents/Programming/R')

x <- seq(-10, 10, 0.1)
plot(dcauchy(x, 0, 1))

# prior is uniform
prior <- seq(0.001, 1, 0.001)   # 1000 points
plot(dunif(prior, 0, 1))

# sampling data
y <- c(-2, -1, 0, 1.5, 2.5)   
points(dcauchy(y, 0, 1))
plot(dcauchy(x, 0.5, 1), type = 'l')


# posterior

post <- rep(0, length(prior))
for (i in 1:length(prior)){
  fun <- function(y) {
    1/((y - prior[i])^2)} 
  post[i] <- prod(sapply(y, fun))
}


sample <- sample(post, 1000, replace = T)

plot(sample)
hist(sample(post, 1000), breaks = 50)





