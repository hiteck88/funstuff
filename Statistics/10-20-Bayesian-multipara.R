setwd('/Users/andrea/Documents/Programming/R')
install.packages('MCMCpack')  # dirichlet
library(MCMCpack)
# multinomial sampling dist with Dirichlet prior
# american presidential election

n <- 911 # total voters
y1 <- 392 # clinton
y2 <- 364 # trump
y3 <- 155 # other


# non informative prior, p = 1/3
prior <- rdirichlet(500, c(1, 1, 1)) # each row sums up to 1
apply(prior, 1, sum)
plot(density(prior[,1]))  # looks like beta

# ------------ posterior
para <- cbind(y1, y2, y3) + 1  # posterior parameters
post <- rdirichlet(1000, para)
head(post)

# find the ratio of clinton vs trump
post.ratio <- post[, 1]/post[, 2]
hist(post.ratio, breaks = 20)
abline(v = mean(post.ratio), col = 'red')

abline(v = quantile(post.ratio, c(0.05, 0.95)), col = 'blue')

plot(post[, 1], post[, 2])
# can do a contour plot



#2016 US presidential election poll from 29 September 2016. 
#911 representative, likely voters were asked which 
#candidate they prefer in the 2016 US presidential election. 
#y_1=392 answered Clinton, y_2=364 answered Trump, and y_3=155
#preferred other candidates or had no opinion
n <- 911
clinton<- 392
trump <- 364
other <- 155

#Noninformative Dirichlet prior with alpha=alpha_1=alpha_2=alpha_3
alpha <- 1
alpha.post <- alpha+c(clinton,trump,other)
library(MASS)
library(lattice)
post.sample <- rdirichlet(10000,alpha.post)
colnames(post.sample) <- c("Clinton","Trump","Other")
#The simulated posterior distribution of theta.clinton/theta.trump:
hist(post.sample[,1]/post.sample[,2],freq=F,main="",xlab=expression(theta["Clinton"]/theta["Trump"]))

#Plot the simulations from the exact posterior distribution
par(mfrow=c(2,2))
plot(post.sample[,1],post.sample[,2],pch=20,xlab="Clinton",ylab="Trump",main="Plot of simulations from the exact posterior")
post.sample.kde <- kde2d(post.sample[,1],post.sample[,2])
# 2-d kernel density estimation, interesting....

#Corresponding contour-plot
contour(post.sample.kde,levels=seq(0.05,0.95,0.1)*max(post.sample.kde$z),drawlabels=F,xlab="Clinton",ylab="Trump",main="Contour plot of simulations from the exact posterior")

#Normal approximation:
thetahat <- c(clinton,trump,other)/sum(c(clinton,trump,other))
J.hat.inv <- ginv(n*rbind(c(1/thetahat[1]+1/thetahat[3],1/thetahat[3]),c(1/thetahat[3],1/thetahat[2]+1/thetahat[3])))

normal.approx <- mvrnorm(10000, mu = thetahat[1:2], Sigma = J.hat.inv)

# now we do a kernel density estimate
normal.approx.kde <- kde2d(normal.approx[,1], normal.approx[,2])

# now plot your results
contour(normal.approx.kde,levels=seq(0.05,0.95,0.1)*max(normal.approx.kde$z),drawlabels=F,xlab="Clinton",ylab="Trump",main="Contour plot of the bivariate normal approximation")















