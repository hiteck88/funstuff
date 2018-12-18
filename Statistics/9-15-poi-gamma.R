# Bayesian 



# note when choosing beta, use of rate/scale depends on expec
# larger RATE is, lower variability (low variance)
# see how gamma density looks like
alpha <- 0.1
beta <- 0.1
data <- rgamma(200, alpha, beta)

d <- density(data)
plot(d)
mean(data) # verify
var(data)

# after data
poi <- c(6, 8, 7, 6, 7, 4, 11, 8, 6, 3)

# try to do it automatically
prior <- rgamma(500, alpha, beta)
plot(density(prior), xlim = c(0, 20), col = 'red', 
     main = 'Prior information')

# be careful when calculating alpha
fun.cum <- function(vec){    ## must exist a simple function
  vec.new <- rep(0, length(vec))
  vec.new[1] <- vec[1]
  for (i in 2:length(vec.new)){
    vec.new[i] <- sum(vec[1:i])
  }
  print (vec.new)
}

cumsum(poi)     # fuck you


alpha.n <- alpha + fun.cum(poi)
beta.n <- beta + c(1:10)
post.1 <- rgamma(500, alpha.n[1], beta.n[1])
plot(density(post.1), ylim = c(0, 0.6))

for (i in 2:length(poi)){
  cat ('Press to display next:')
  line <- readline()   # this can be useful!
  
  post <- rgamma(500, alpha.n[i], beta.n[i])
  density(post)
  lines(density(post))
  
}

# posterior mean
mean(post.1)
mean(post)


# another approach, could be simpler
# it's more smooth

x <- seq(0.01, 5, 0.01)
length(x)

# basically dgamma is density of gamma on each point of x
plot(dgamma(x, alpha.n[5], beta.n[[5]]), type = 'l')
plot(dgamma(x, alpha, beta), type = 'l')




