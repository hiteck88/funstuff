# some example of MCMC from online

# ---------------- 1 ----------------- #
# generate some data
trueA <- 5
trueB <- 0
trueSd <- 10
sampleSize <- 31

# create independent x-values 
x <- (-(sampleSize-1)/2):((sampleSize-1)/2)
# from -15 to 15

# create dependent values according to ax + b + N(0,sd)
y <-  trueA * x + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd)

plot(x,y, main="Test Data")

# ---------------- 2 ----------------- #
# model parameter A, B, Sd

likelihood <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  
  pred = a*x + b
  singlelikelihoods = dnorm(y, mean = pred, sd = sd, log = T)
  # as it should be scattered around the predicted value
  # use the log so next use sum
  
  sumll = sum(singlelikelihoods)
  return(sumll)   
}

# plot some density

dnorm(0, 0, 1)
plot(sapply(seq(-5, 5, by = 0.1), function(i) dnorm(i, 0, 1)))
plot(sapply(seq(-5, 5, by = 0.1), function(i) dunif(i, 0, 1)))
plot(sapply(seq(0.1, 5, by = 0.1), function(i) dgamma(i, 1, 2)))
plot(sapply(seq(0.1, 5, by = 0.1), function(i) dexp(i, 1)))


# Example: plot the likelihood profile of the slope a
slopevalues <- function(x)
{return(likelihood(c(x, trueB, trueSd)))}   # only change the intercept

slopelikelihoods <- lapply(seq(3, 7, by=.05), slopevalues)
plot (seq(3, 7, by=.05), slopelikelihoods , type="l", xlab = "values of slope parameter a", ylab = "Log likelihood")


# ---------------- 3 ----------------- #
# Prior distribution
prior <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  aprior = dunif(a, min=0, max=10, log = T)
  bprior = dnorm(b, sd = 5, log = T)
  sdprior = dunif(sd, min=0, max=30, log = T)
  return(aprior+bprior+sdprior)
}
### why add them?



# ---------------- 4 ----------------- #
# posterior distribution

posterior <- function(param){
  return (likelihood(param) + prior(param))
}
### ? why just add them? 

# ---------------- 5 ----------------- #

# MH algorithm
# the aim of this algorithm is to jump around in parameter space, 
# but in a way that the probability to be at a point is proportional 
# to the function we sample from



proposalfunction <- function(param){
  return(rnorm(3,mean = param, sd= c(0.1,0.5,0.3)))
}
# generates 3 random normal values, with mean at given but fixed sd



run_metropolis_MCMC <- function(startvalue, iterations){
  chain = array(dim = c(iterations+1,3))  
  # a matrix of length 20+1 by 3
  
  # 1. Starting at a random parameter value
  chain[1,] = startvalue
  for (i in 1:iterations){
    
    # 2. Choosing a new parameter value close to the old value based on some 
    # probability density that is called the proposal function
    
    proposal = proposalfunction(chain[i,]) 
    # proposed values, close to starting value (4, 0, 10)
    
    probab = exp(posterior(proposal) - posterior(chain[i,]))
    # use posterior
    # this is where parameters are connected to data y
    # specifically, posterior = likelihood + prior
    # where likelihood connects to data y
    # above is equivalent to P(prop)/P(current)
    
    
    # 3. Jumping to this new point with a probability p(new)/p(old), where p 
    # is the target function, and p>1 means jumping as well
    
    if (runif(1) < probab){
      chain[i+1,] = proposal    # accept
    }else{
      chain[i+1,] = chain[i,]   # keep the current
    }
  }
  return(chain)
}

startvalue = c(4,0,10)
# recall the true is 5, 0, 10
chain = run_metropolis_MCMC(startvalue, 10000)


# COMMENT: in order to run MCMC, need to define: 
# 1. loglikelihood function, as a sum of loglik of data y as a function close to 
# a normal distribution, with expectation computed with parameters

# 2. prior function, as (sum of density) of each parameter with a given interval
# specified by some hyperparameters

# 3. posterior function, as a sum of loglikelihood and prior

# 4. proposal function, generate one (list of) normal values given the current value (as mean)
# and some fixed sd

# 5. MH algorithm, integrate all above together. 


######------------- ######
iterations <- 20
chain1 <- startvalue
proposalfunction(chain1)
# start value of intercept is 4, then with the given normal proposal, 
# the proposed value is 4.0036

rnorm(3,mean = param, sd= c(0.1,0.5,0.3)) 
######------------- ######


burnIn = 5000
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))




par(mfrow = c(2,3))
hist(chain[-(1:burnIn),1],nclass=30, , main="Posterior of a", xlab="True value = red line" )
abline(v = mean(chain[-(1:burnIn),1]))
abline(v = trueA, col="red" )
hist(chain[-(1:burnIn),2],nclass=30, main="Posterior of b", xlab="True value = red line")
abline(v = mean(chain[-(1:burnIn),2]))
abline(v = trueB, col="red" )
hist(chain[-(1:burnIn),3],nclass=30, main="Posterior of sd", xlab="True value = red line")
abline(v = mean(chain[-(1:burnIn),3]) )
abline(v = trueSd, col="red" )
plot(chain[-(1:burnIn),1], type = "l", xlab="True value = red line" , main = "Chain values of a", )
abline(h = trueA, col="red" )
plot(chain[-(1:burnIn),2], type = "l", xlab="True value = red line" , main = "Chain values of b", )
abline(h = trueB, col="red" )
plot(chain[-(1:burnIn),3], type = "l", xlab="True value = red line" , main = "Chain values of sd", )
abline(h = trueSd, col="red" )

# for comparison:
summary(lm(y~x))





