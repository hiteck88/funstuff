# simulate poisson process so I understand it better


# 1. poisson distribution (discrete)
# models counts
# lambda is the average counts of events in a interval. 
# the bigger, the more flat pmf will be because more values could be taken 
# the smaller, the more pmf is concentrated at 0. 

?poisson
x <- seq(0, 10, 1)  # this should take integer value

lambda <- 2      # both mean and variance
# density, pmf
plot(dpois(x, lambda))

# verify mean and variance, both should be equal to lambda
meanpoi <- sum(x*dpois(x, lambda)) 
varpoi <- sum((x^2)*dpois(x, lambda)) - (meanpoi)^2 

# cdf
plot(ppois(x, lambda))

# 2. exponential distribution (continuous)
# models waiting time. the higher the rate is, the more sharp
# indicating shorter waiting time until the next event. 
?pexp
rate <- 0.5
plot(dexp(x, rate))


# 3. poisson process
# each arrival has indep, exponential waiting time

lambda <- 2
tMax <- 100

## find the number 'n' of exponential r.vs required by imposing that
## Pr{N(t) <= n} <= 1 - eps for a small 'eps'
n <- qpois(1 - 1e-8, lambda = lambda * tMax)  # lambda here is 50
# 94 points needed, these are the 94 events 


## simulate exponential interarrivals, 94 points
X <- rexp(n = n, rate = lambda)

plot(X)
hist(X)

S <- c(0, cumsum(X))
plot(x = S, y = 0:n, type = "s", xlim = c(0, tMax))  

## several paths?
nSamp <- 50
## simulate exponential interarrivals
X <- matrix(rexp(n * nSamp, rate = lambda), ncol = nSamp,
            dimnames = list(paste("S", 1:n, sep = ""), paste("samp", 1:nSamp)))
## compute arrivals, and add a fictive arrival 'T0' for t = 0
S <- apply(X, 2, cumsum)
S <- rbind("T0" = rep(0, nSamp), S)
head(S)
## plot using steps
matplot(x = S, y = 0:n, type = "s", col = "darkgray",
        xlim = c(0, tMax),
        main = "Homogeneous Poisson Process paths", xlab = "t", ylab = "N(t)")


# so the yaxis is how many events have happend at time t, N(t)
# between each single event, the waiting time between them is exponentially distributed
# with rate parameter lambda*t. 
# bigger lambda, more events happen in the interval
# bigger t, longer time 
# both would increase the total number of events. naturally, the one with bigger lambda is higher
# at the same time point









