setwd('/Users/andrea/Documents/Programming/R')


# estimate a rate of Poisson data
# theta is the true asthma mortality rape per 100000 persons per year
# sampling dist is poi (2*theta)

alpha <- 3
beta <- 5
data <- rgamma(1000, alpha, beta)
quantile(data, 0.975)
abline(v = quantile(data, 0.975))

# another way of plotting 
x <- seq(0.01, 3, 0.01)
plot(dgamma(x, alpha, beta), type = 'l')
lines(dgamma(x, 1.2, 2), col = 'red')

# these two are the same position on the plot
qgamma(0.98, alpha, beta)  # 0.98 quantile corresponding value
pgamma(1.5, alpha, beta)   # cumulative density below 1.5

pgamma(1.5, 1.2, 2) # given another set of para, prob of data below 1.5 changes
# this one is flatter



d <- density(data)
plot(d)
mean(data) # verify
var(data)

# --------------------- posterior
# gamma(alpha + sum(death), beta + sum(exposure))
death <- 30
exposure <- 20
lines(dgamma(x, alpha + death, beta + exposure), col = 'blue')
lines(dgamma(x, 1.2 + death, 2+exposure), col = 'yellow')




