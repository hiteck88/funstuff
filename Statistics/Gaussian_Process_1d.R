# GAUSSIAN PROCESSES IN 1 DIMENSION

require(MASS)     # mvrnorm
require(reshape2) # function melt to stack different columns under eachother
require(ggplot2)


set.seed(123)

# Calculates the covariance matrix sigma using a
# simplified version of the squared exponential function.


##### Stationary and isotropic cov fun: squared-exponential in 1-dim
# Arguments of the function:
#  X1, X2 = vectors
#      l  = the length-scale parameter
# Returns:
# 	a covariance matrix
computeSigma <- function(X1,X2,l=1) {
  Sigma <- matrix(rep(0, length(X1)*length(X2)), nrow=length(X1))
  for (i in 1:nrow(Sigma)) {
    for (j in 1:ncol(Sigma)) {
      Sigma[i,j] <- exp(-0.5/l*(abs(X1[i]-X2[j]))^2)
      # could add signal and noise variances (see page 19 book, eq 2.31)
      
    }
  }
  return(Sigma)
}

# 1. Plot some sample functions from the Gaussian process
# as shown in Figure 2.2(a)

# Define the points at which we want to define the functions
x.star <- seq(-6,6,len=60)

# Calculate the covariance matrix 50x50
sigma <- computeSigma(x.star,x.star)
dim(sigma)

# Generate a number of functions from the process
n.samples <- 3
values <- matrix(rep(0,length(x.star)*n.samples), ncol=n.samples)   # fi
# this makes a matrix of size 50 by 3, 3 functions

for (i in 1:n.samples) {
  # Each column represents a sample from a multivariate normal distribution
  # with zero mean and covariance sigma
  values[,i] <- mvrnorm(1, rep(0, length(x.star)), sigma)
}
# n = 1. this is very important, as you cant compute the variance for one point
# yet if you make 2 points, it's gonna work. 
s <- mvrnorm(2, rep(0, length(x.star)), sigma)
var(s)  # it doesnt work anymore

Sigma <- matrix(c(10,3,3,2),2,2)
Sigma
s2 <- mvrnorm(n = 1, rep(0, 2), Sigma)
var(s2)





values2 <- cbind(x=x.star,as.data.frame(values))
values3 <- melt(values2,id="x")   # pile different columns onto eachother
values <- values3  # update

# Plot
fig2a <- ggplot(values,aes(x=x,y=value)) +
  geom_rect(xmin=-Inf, xmax=Inf, ymin=-2, ymax=2, fill="grey80") +
  geom_line(aes(group=variable)) +
  theme_bw() +
  scale_y_continuous(lim=c(-2.5,2.5), name="Output values f(x)") +
  xlab("Input values x")
fig2a
#pdf(file = "gp1dmater.pdf", width=7.6, height=5.57)
par(mar=c(5,4,2,2)+0.1)
plot(values2[,1], values2[,2], type="l", col=2, ylim=c(-2,2), lwd=2, lty=2,
     xlab="Input values x", ylab="Output values f(x)")
# plot x, f_1

lines(values2[,1], values2[,3], lty=4, col=3, lwd=2)
lines(values2[,1], values2[,4], lty=5, col=1, lwd=2)
mean(values2[1, ])
mean(values2[, 3])
mean(values2[, 4])


# 2. Now we have some known data points;
# Figure 2.2(b). In the book, the notation 'f'
# is used for f$y below.
f <- data.frame(x=c(-4,-2.3,-1,1.6,3.3),
                y=c(-1.1,0,1,-0.5,1))

# Calculate the covariance matrices using the same x.star values as above
x <- f$x  #  5 x 1
x.star    # 50 x 1
k.xx <- computeSigma(x,x)              # 5  x 5
k.xxs <- computeSigma(x,x.star)        # 5  x 50
k.xsx <- computeSigma(x.star,x)        # 50 x 5
k.xsxs <- computeSigma(x.star,x.star)  # 50 x 50

# These matrix calculations correspond to equation (2.19) in the book
# or (20) and (21) of the paper by Williams (1997)
f.star.bar <- k.xsx%*%solve(k.xx)%*%f$y                # !!!!!!!!!!!!!!!!!!!
cov.f.star <- k.xsxs - k.xsx%*%solve(k.xx)%*%k.xxs     # !!!!!!!!!!!!!!!!!!!

y <- f$y
plot(x, y, ylim = c(-3, 8), xlim=c(-5,5), pch=16, col=1,
     xlab="Input values x", ylab="Output values f(x)")
lines(x.star, f.star.bar + 1.96*(sqrt(diag(cov.f.star))), col="red", lty=5, lwd=2)
lines(x.star, f.star.bar - 1.96*(sqrt(diag(cov.f.star))), col="red", lty=5, lwd=2)
lines(x.star, f.star.bar, col="blue", lwd=1)




# This time we'll plot more samples
# We could of course simply plot a +/- 2 standard deviation confidence interval as in the book but I want to show the samples explicitly here.
n.samples <- 50
values <- matrix(rep(0,length(x.star)*n.samples), ncol=n.samples)
for (i in 1:n.samples) {
  values[,i] <- mvrnorm(1, f.star.bar, cov.f.star)
}
values <- cbind(x=x.star,as.data.frame(values))
values <- melt(values,id="x")

# Plot the results including the mean function
# and constraining data points
fig2b <- ggplot(values,aes(x=x,y=value)) +
  geom_line(aes(group=variable), colour="grey80") +
  geom_line(data=NULL,aes(x=x.star,y=f.star.bar),colour="red", size=1) + 
  geom_point(data=f,aes(x=x,y=y)) +
  theme_bw() +
  scale_y_continuous(lim=c(-3,3), name="Output values f(x)") +
  xlab("Input values x")

#pdf("noisegp.pdf", width=6.35, height=4.53)
fig2b
dev.off()







######## THIS IS THE LIKELIHOOD: noise within the data
# 3. Now assume that each of the observed data points have some
# normally-distributed noise.

# The standard deviation of the noise
sigma.n <- 0.2
# ONLY DIFFERENCE FROM BEFORE IS SIGMA.N IN THE 2 FORMULAS BELOW

# Recalculate the mean and covariance functions adding the noise to the diagonal
f.bar.star <- k.xsx%*%solve(k.xx + sigma.n^2*diag(1, ncol(k.xx)))%*%f$y
cov.f.star <- k.xsxs - k.xsx%*%solve(k.xx + sigma.n^2*diag(1, ncol(k.xx)))%*%k.xxs

# Recalulate the sample functions
values <- matrix(rep(0,length(x.star)*n.samples), ncol=n.samples)
for (i in 1:n.samples) {
  values[,i] <- mvrnorm(1, f.bar.star, cov.f.star)
}
values <- cbind(x=x.star,as.data.frame(values))
values <- melt(values,id="x")

# Plot the result, including error bars on the observed points
gg <- ggplot(values, aes(x=x,y=value)) + 
  geom_line(aes(group=variable), colour="grey80") +
  geom_line(data=NULL,aes(x=x.star,y=f.bar.star),colour="red", size=1) + 
  geom_errorbar(data=f,aes(x=x,y=NULL,ymin=y-2*sigma.n, ymax=y+2*sigma.n), width=0.2) +
  geom_point(data=f,aes(x=x,y=y)) +
  theme_bw() +
  scale_y_continuous(lim=c(-3,3), name="Output values f(x)") +
  xlab("Input values x")
gg
