# -------------------- chpt 2 ex 8
ybar <- 150
sigma <- 20
mu0 <- 180
tau0 <- 40

n <- 10
# posterior para
prior.pre <- 1/(tau0 ^2)
data.pre <- n/(sigma ^2)
post.pre <- prior.pre + data.pre

mu.n <- (mu0 * prior.pre + ybar * data.pre)/post.pre
tau.n <- sqrt(1/post.pre)



x <- seq(0, 400, 1)
# plot prior
lines(dnorm(x, mu0, tau0), type = 'l')
plot(dnorm(x, mu.n, tau.n), type = 'l', col = 'red')

# posterior interval
lower <- qnorm(c(0.025, 0.975), mu.n, tau.n)[1]
upper <- qnorm(c(0.025, 0.975), mu.n, tau.n)[2]
abline(v = qnorm(c(0.025, 0.975), mu.n, tau.n), col = 'blue')




# ------------------ ex 9
dat <- rbeta(200, 1, 2/3)
mean(dat)
sd(dat)
# yay
x2 <- seq(0, 1, 0.01)
plot(dbeta(x2, 1, 2/3), type = 'l')
# alpha beta define the shape of theta

# use curve function to plot density
curve(dbeta(x, 1, 2/3), 0, 1)
curve(dbeta(x, 3,6), 0, 1) # wth is x????



plot(dbeta(x2, 2, 8), type = 'l')
plot(dbeta(x2, 8, 2), type = 'l')  # symmetrical

# plot density of a mixture model of beta dist
index <- sample(1:2,prob=c(0.5, 0.5),size=10000,replace=TRUE)
alphas <- c(2, 8)
betas <- c(8, 2)

data <- rbeta(n=10000, alphas[index], betas[index])
plot(density(data))



