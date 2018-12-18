# generate many data
library(ggplot2)
library(dplyr)
dat1 <- rnorm(100, 3, 2)  # with mean 3 and sd 2

hist(dat1)

# compute the mean 

m <- mean(dat1)

# repeat
m <- NULL
CLT <- function(iteration, n, mu, sd){
  
  for (i in 1:iteration){
    dat <- rnorm(n, mu, sd)
    m[i] <- mean(dat)
  }
  m.bar <- mean(m)
  sd <- sqrt(var(m))
  return(list(m, m.bar, sd))
  
}
try1 <- CLT(1000, 100, 3, 2)

# theoretical sd for the mean samples
2/(sqrt(100))

# --------------------- try with other distributions

?rgamma

sqrt(var(rgamma(500, 3, rate = 2)))


m <- NULL
CLT.gamma <- function(iteration, n, shape, rate){
  
  for (i in 1:iteration){
    dat <- rgamma(n, shape, rate)
    m[i] <- mean(dat)
  }
  m.bar <- mean(m)
  sd <- sqrt(var(m))
  return(list(m, m.bar, sd))
  
}
try.gamma <- CLT.gamma(1000, 200, 3, 2)
hist(try.gamma[[1]])

sd.gamma <- sqrt(3/4)
sd.gamma/(sqrt(200))

# so this N is the sample size, not how many times iteration!!




# ================ binomial coin toss trials

# 1. wald interval 
n <- 20  # number of toss of coins
pvals <- seq(0.1, 0.9, by = 0.05)
n.iter <- 10000
coverage <- sapply(pvals, function(p){
  
  # rbinom is the number of success, in all n tosses
  # rbinom/n is the proportion, hence hat(p)
  phat <- rbinom(n.iter, prob = p, size = n)/n  # pval here 
  
  # approximate with the sd of mean(phat)
  ll <- phat - qnorm(0.975) * sqrt(phat * (1-phat)/n)
  ul <- phat + qnorm(0.975) * sqrt(phat * (1-phat)/n)
  # after all 1000 iterations, compute coverage for each p
  mean(ll < p & ul > p)
})

?rbinom
# size is trial numbers 
hist(rbinom(1000, prob = 0.8, size = 20))  # number of success


# plot(coverage, type = 'l')
C <- data.frame(pvals, coverage)
ggplot(C, aes(x = pvals, y = coverage)) + geom_line()



# 2. add two success and 2 failures
coverage2 <- sapply(pvals, function(p){
  
  # rbinom is the number of success, in all n tosses
  # rbinom/n is the proportion, hence hat(p)
  phat <- (rbinom(n.iter, prob = p, size = n)+2)/(n+4)  # pval here 
  
  # approximate with the sd of mean(phat)
  ll <- phat - qnorm(0.975) * sqrt(phat * (1-phat)/n)
  ul <- phat + qnorm(0.975) * sqrt(phat * (1-phat)/n)
  # after all 1000 iterations, compute coverage for each p
  mean(ll < p & ul > p)
})


C %>% mutate(coverage2 = coverage2)

ggplot(C, aes(x = pvals)) + 
  geom_line(aes(y = coverage, color = 'first coverage')) + 
  geom_line(aes(y = coverage2, color = 'second coverage')) + 
  geom_hline(aes(yintercept = 0.95))



# ============== poisson example

# 5 failures, 94.32 days
x <- 5; t <- 94.32
lambda <- x/t  # 0.053
lambda+ c(-1, 1)*qnorm(0.975) * sqrt(lambda/t)


poisson.test(5, T = 94.32)$conf
# 0.017 to 0.124








