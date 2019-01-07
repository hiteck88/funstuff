# Newton Raphson for eg.6-3

set.seed(999)
num <- 100; N <- num+1
x <- arima.sim(n = N, list(ar = 0.8, sd = 1))
x
y <- ts(x[-1] + rnorm(num, 0, 1))
y

# --------- initial estimates
?ts.intersect  # bind ts with a common frequency. essentially my shifting scheme
u <- ts.intersect(y, lag(y, -1), lag(y, -2))

varu <- var(u)  # same as cov(u), the covariance matrice
coru <- cor(u)  # correlation


phi <- coru[1, 3]/coru[1, 2]  # cor(t, t-2)/cor(t, t-1), essentially varu[1, 3]/varu[1, 2]  

q <- (1-phi^2)*varu[1,2]/phi  # initial Q, variance of state noise
r <- varu[1, 1] - q/(1-phi^2) # initial R, variance of obs noise 

init.par <- c(phi, sqrt(q), sqrt(r))    # 0.908, 0.51, 1.02
init.par


# --------- likelihood
Linn <- function(para){
  phi <- para[1]
  sigw <- para[2]
  sigv <- para[3]
  
  Sigma0 <- (sigw^2)/(1-phi^2)  # xinit ~ N(0, sigw^2/(1-phi^2)), based on autocovariance of AR1
  Sigma0[Sigma0<0] <- 0
  
  kf <- Kfilter0(num, y, 1, mu0 = 0, Sigma0, phi, sigw, sigv)
  return(kf$like)
  
}


# ---------- estimation
?optim   # BFGS is the quasi newton method 

est <- optim(init.par, Linn, gr = NULL, method = 'BFGS', hessian = T)
estimate <- est$par
estimate
SE <- sqrt(diag(solve(est$hessian)))   # for phi, sigw, sigv
SE




Kfilter0




