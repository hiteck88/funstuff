# source Kfilter0
?Kfilter0

phi <- init.par[1]
sigw <- init.par[2]
sigv <- init.par[3]

mu0 <- 0
A <- 1
Sigma0 <- (sigw^2)/(1-phi^2)  # xinit ~ N(0, sigw^2/(1-phi^2)), based on autocovariance of AR1
Sigma0[Sigma0<0] <- 0

Phi <- phi
cQ <- sigw
cR <- sigv


# note that this here is only for one set of parameters. apparently when its unknown we need to optimise. 

function (num, y, 
          A,     # time invariant observation matrix
          mu0,   # initial state mean
          Sigma0, 
          Phi,   # state transition matrix
          cQ,    # state error cov
          cR)    # observation error cov
{
  Q = t(cQ) %*% cQ      # variance 
  R = t(cR) %*% cR
  Phi = as.matrix(Phi)
  pdim = nrow(Phi)   # 1
  y = as.matrix(y)
  qdim = ncol(y)     # 1
  xp = array(NA, dim = c(pdim, 1, num))    # 100 NAs, 1 by 1 by 100
  Pp = array(NA, dim = c(pdim, pdim, num))
  xf = array(NA, dim = c(pdim, 1, num))
  Pf = array(NA, dim = c(pdim, pdim, num))
  innov = array(NA, dim = c(qdim, 1, num))
  sig = array(NA, dim = c(qdim, qdim, num))
  
  
  x00 = as.matrix(mu0, nrow = pdim, ncol = 1)    # initial mean
  P00 = as.matrix(Sigma0, nrow = pdim, ncol = pdim)  # initial precision, or sigma
  
  # 1. make a prediction from initial x00, and compute its precision. remember to add the state error Q
  xp[, , 1] = Phi %*% x00    # 6.19          one step ahead state prediction
  Pp[, , 1] = Phi %*% P00 %*% t(Phi) + Q   # 6.20     mean square prediction error
  
  
  # 2. compute variance of innovation epsilon (not appeared, to be used in Kalman gain)
  sigtemp = A %*% Pp[, , 1] %*% t(A) + R    # equa 6.25     
  sig[, , 1] = (t(sigtemp) + sigtemp)/2  # ???? why???
  siginv = solve(sig[, , 1])
  
  # 3. Kalman gain
  K = Pp[, , 1] %*% t(A) %*% siginv   # 6.23
  
  
  # 4. innovation, or prediction error
  innov[, , 1] = y[1, ] - A %*% xp[, , 1]   # 6.24
  
  # 5. update the prediction (aka filter)
  xf[, , 1] = xp[, , 1] + K %*% innov[, , 1]        # 6.21        filter value of state
  Pf[, , 1] = Pp[, , 1] - K %*% A %*% Pp[, , 1]     # 6.22        mean square filter error
  sigmat = as.matrix(sig[, , 1], nrow = qdim, ncol = qdim)
  
  # 6. loglike for one observation
  like = log(det(sigmat)) + t(innov[, , 1]) %*% siginv %*% innov[, , 1]
  
  for (i in 2:num) {
    if (num < 2) 
      break
    xp[, , i] = Phi %*% xf[, , i - 1]
    Pp[, , i] = Phi %*% Pf[, , i - 1] %*% t(Phi) + Q
    sigtemp = A %*% Pp[, , i] %*% t(A) + R
    sig[, , i] = (t(sigtemp) + sigtemp)/2
    siginv = solve(sig[, , i])
    K = Pp[, , i] %*% t(A) %*% siginv
    innov[, , i] = y[i, ] - A %*% xp[, , i]
    xf[, , i] = xp[, , i] + K %*% innov[, , i]
    Pf[, , i] = Pp[, , i] - K %*% A %*% Pp[, , i]
    sigmat = as.matrix(sig[, , i], nrow = qdim, ncol = qdim)
    
    # add from previous loglike
    like = like + log(det(sigmat)) + t(innov[, , i]) %*%        
      siginv %*% innov[, , i]
  }
  like = 0.5 * like    # half sum loglike
  list(xp = xp, Pp = Pp, xf = xf, Pf = Pf, like = like, innov = innov, 
       sig = sig, Kn = K)
}