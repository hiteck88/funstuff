setwd('/Users/andrea/Documents/Programming/R/TimeSeries')
library(astsa)

# state model
# mu_t = mu_t-1 + w_t
# observation model
# y_t = mu_t + v_t


# generate 50 data
set.seed(1)
n <- 50
w <- rnorm(n + 1, 0, 1)   # why n+1?
v <- rnorm(n, 0, 1)

# state: mu[0], mu[1]... mu[50], 51 in total
mu <- cumsum(w)
plot(mu, type = 'l')

# observation: y[1]...y[50]
y <- mu[-1] + v   # remove mu[0]
lines(y, col = 'red')

# -------- filter and smooth
?Ksmooth0
# kalman filter and smoother, time invariant model without inputs
# (number of obs, data, time invariate obs matrix, 
#  initla state mean vector, cov mat, state transition mat
#  cholesky type decomp of state error cov Q, R)

mu0 <- 0
sigma0 <- 1
phi <- 1
cQ <- 1
cR <- 1
ks <- Ksmooth0(n, y, 1, mu0, sigma0, phi, cQ, cR)
ks$xs

par(mfrow = c(2, 1))
Time <- 1:n

pred <- ks$xp # one step ahead pred of the state
err <- ks$Pp  # mean square prediction error
plot(Time, mu[-1], main = 'prediction', ylim = c(-5, 10))
lines(pred)
lines(pred + 2*sqrt(err), lty = 'dashed', col = 'blue')
lines(pred - 2*sqrt(err), lty = 'dashed', col = 'blue')


fil <- ks$xf
ferr <- ks$Pf
plot(Time, mu[-1], main = 'filter', ylim = c(-5, 10))
lines(fil)
lines(fil + 2*sqrt(ferr), lty = 'dashed', col = 'blue')
lines(fil - 2*sqrt(ferr), lty = 'dashed', col = 'blue')


smo <- ks$xs
serr <- ks$Ps
plot(Time, mu[-1], main = 'smooth', ylim = c(-5, 10))
lines(smo)
lines(smo + 2*sqrt(serr), lty = 'dashed', col = 'blue')
lines(smo - 2*sqrt(serr), lty = 'dashed', col = 'blue')







