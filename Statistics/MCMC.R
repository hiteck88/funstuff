setwd('/Users/chizhang/Documents/Programming/R')

# Monte Carlo - generate sampling of a specific distribution

# 1. Markov Chain, f(t+1) only depends on f(t)

N = 10000
signal = vector(length = N)
signal[1] = 0
for (i in 2:N){
  # random select one offset (from [-1,1]) to signal[i-1]
  signal[i] = signal[i-1] + sample(c(-1,1),1)   # only choose from -1, 1
}

plot( signal, type = 'l',col = 'red')




# 2. Random Walk, is the 2-D MC
N = 100
x = vector(length = N)
y = vector(length = N)
x[1] = 0
y[1] = 0
for (i in 2:N){
  x[i] = x[i-1] + rnorm(1)  # random noise
  y[i] = y[i-1] + rnorm(1)
}


plot(x,y,type = 'l', col='red')



# 3. MCMC - MH algorithm
# raised by Metroplis, then improved by Hastings
# Gibbs sampler is a special case of MH
# detailed balance equation: pi(x)*P(y|x) = pi(y)*P(x|y)
# p is a distribution, P is prob



# initialise
N = 5000 
x = vector(length = N)  
x[1] = 0  

# uniform variable: u  
u = runif(N)  
m_sd = 5  
freedom = 5  

for (i in 2:N)  
{ 
  # generate proposal y from q(y|xn)
  # here all xn is the previous 1 x
  y = rnorm(1,mean = x[i-1],sd = m_sd)   # use the previous x
  print(y)  
  #y = rt(1,df = freedom)  
  
  
  
  # rho = q(xn|y)p(y) / q(y|xn)p(xn) ^ 1 (minimum of these two)
  # post/old
  p_accept = dnorm(x[i-1],mean = y,sd = abs(2*y+1)) / dnorm(y, mean = x[i-1],sd = abs(2*x[i-1]+1))  
    
  
  if ((u[i] <= p_accept))   # if u is lower than accept prob, u < min(p_accept, 1)
  {  
    x[i] = y  
    print("accept")  
  }  
  else  
  {  
    x[i] = x[i-1]     # otherwise still use the previous x
    print("reject")  
  }  
}  

plot(x,type = 'l')  
dev.new()   # return the return value of the device opened
hist(x)  


# dnorm is density
# pnorm is the cdf, prob at x
# qnorm is given quantile, find value x







