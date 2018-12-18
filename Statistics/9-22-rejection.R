# rejection sampling

# how the target density should look like
x <- seq(0, 1, 0.01)
plot(dbeta(x, 3, 6), type = 'l')


# 
sampled <- data.frame(proposal = runif(1000,0,1))
hist(runif(1000, 0, 1))  


# these values on beta density 
# this is the likelihood that sample comes from target dist
# we get a vector of probabilities, representing prob for each point in sample
# here it's the IMPORTANCE RATIO

# p(theta|y) ----- target   (here is beta,dont worry about y now)
# g(theta) ------- sampling (here is uniform)
# importance ratio is target/sampling, has upper bound M
sampled$targetDensity <- dbeta(sampled$proposal, 3,6) ### KEY
plot(sampled$targetDensity)

# note if we order these random data, 
# they would produce similar thing as in target
ty <- dbeta(sort(sampled$targetDensity), 3,6)
plot(ty)


# accept prop. to target density, find M
# but actually a fast and easy way is to use uniform * highest density
# that would form a rectangular, target will always be under the top line

maxDens = max(sampled$targetDensity, na.rm = T) # max density

# here the runif === to draw with probability = imp.ratio
# imagine a rectangle, lower imp.ratio, less likely to draw
sampled$accepted = ifelse(runif(1000,0,1) < sampled$targetDensity/maxDens , TRUE, FALSE)


table(sampled$accepted)
625/375
plot(sampled$proposal[sampled$accepted])
plot(sort(sampled$targetDensity / maxDens))

hist(sampled$proposal[sampled$accepted], freq = F, col = "grey", breaks = 100)
curve(dbeta(x, 3,6),0,1, add =T, col = "red")




