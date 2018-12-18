install.packages('kernlab')
library(kernlab)


kfunction <- function(linear =0, quadratic=0){
  k <- function (x,y)  {
    linear*sum((x)*(y)) + quadratic*sum((x^2)*(y^2))
  }
  class(k) <- "kernel"
  k
}


# ------------- linear separable 
n = 25
a1 = rnorm(n)
a2 = 1 - a1 + 2* runif(n)
b1 = rnorm(n)
b2 = -1 - b1 - 2*runif(n)
x = rbind(matrix(cbind(a1,a2),,2),matrix(cbind(b1,b2),,2))
# y is the classes 0, 1
y <- matrix(c(rep(1,n),rep(-1,n)))


svp <- ksvm(x, y, type="C-svc", C = 100, kernel=kfunction(1,0),scaled=c())
plot(c(min(x[,1]), max(x[,1])),c(min(x[,2]), max(x[,2])),type='n',xlab='x1',ylab='x2')
title(main='Linear Separable Features')

ymat <- ymatrix(svp)  # response

# SVindex is the index of support vectors
points(x[-SVindex(svp),1], x[-SVindex(svp),2], pch = ifelse(ymat[-SVindex(svp)] < 0, 2, 1))
points(x[SVindex(svp),1], x[SVindex(svp),2], pch = ifelse(ymat[SVindex(svp)] < 0, 17, 16))

# Extract w and b from the model   
w <- colSums(coef(svp)[[1]] * x[SVindex(svp),])   # x[] is some points important, black on plot
b <- b(svp)  # resulting offset

# Draw the lines
abline(b/w[2],-w[1]/w[2], col = 'red')
abline((b+1)/w[2],-w[1]/w[2],lty=2)
abline((b-1)/w[2],-w[1]/w[2],lty=2)





# -------------- non separable

n = 20
r = runif(n)
a = 2*pi*runif(n)
a1 = r*sin(a)
a2 = r*cos(a)
r = 2+runif(n)
a = 2*pi*runif(n)
b1 = r*sin(a)
b2 = r*cos(a)
x = rbind(matrix(cbind(a1,a2),,2),matrix(cbind(b1,b2),,2))
y <- matrix(c(rep(1,n),rep(-1,n)))

# try to see how to deal with this
plot(x[21:40,], col = 'red')
points(x[1:20,], col = 'blue')


# first method
svp <- ksvm(x,y,type="C-svc",C = 100, kernel=kfunction(0,1),scaled=c())
par(mfrow=c(1,2))
plot(c(min(x[,1]), max(x[,1])),c(min(x[,2]), max(x[,2])),type='n',xlab='x1',ylab='x2')
title(main='Feature Space')
ymat <- ymatrix(svp)
points(x[-SVindex(svp),1], x[-SVindex(svp),2], pch = ifelse(ymat[-SVindex(svp)] < 0, 2, 1))
points(x[SVindex(svp),1], x[SVindex(svp),2], pch = ifelse(ymat[SVindex(svp)] < 0, 17, 16))

# Extract w and b from the model   
w2 <- colSums(coef(svp)[[1]] * x[SVindex(svp),]^2)
b <- b(svp)

x1 = seq(min(x[,1]),max(x[,1]),0.01)
x2 = seq(min(x[,2]),max(x[,2]),0.01)

points(-sqrt((b-w2[1]*x2^2)/w2[2]), x2, pch = 16 , cex = .1 )
points(sqrt((b-w2[1]*x2^2)/w2[2]), x2, pch = 16 , cex = .1 )
points(x1, sqrt((b-w2[2]*x1^2)/w2[1]), pch = 16 , cex = .1 )
points(x1,  -sqrt((b-w2[2]*x1^2)/w2[1]), pch = 16, cex = .1 )

points(-sqrt((1+ b-w2[1]*x2^2)/w2[2]) , x2, pch = 16 , cex = .1 )
points( sqrt((1 + b-w2[1]*x2^2)/w2[2]) , x2,  pch = 16 , cex = .1 )
points( x1 , sqrt(( 1 + b -w2[2]*x1^2)/w2[1]), pch = 16 , cex = .1 )
points( x1 , -sqrt(( 1 + b -w2[2]*x1^2)/w2[1]), pch = 16, cex = .1 )

points(-sqrt((-1+ b-w2[1]*x2^2)/w2[2]) , x2, pch = 16 , cex = .1 )
points( sqrt((-1 + b-w2[1]*x2^2)/w2[2]) , x2,  pch = 16 , cex = .1 )
points( x1 , sqrt(( -1 + b -w2[2]*x1^2)/w2[1]), pch = 16 , cex = .1 )
points( x1 , -sqrt(( -1 + b -w2[2]*x1^2)/w2[1]), pch = 16, cex = .1 )


# use quadratic kernel
xsq <- x^2
svp <- ksvm(xsq,y,type="C-svc",C = 100, kernel=kfunction(1,0),scaled=c())

plot(c(min(xsq[,1]), max(xsq[,1])),c(min(xsq[,2]), max(xsq[,2])),type='n',xlab='x1^2',ylab='x2^2')
title(main='Quadratic Kernel Space')
ymat <- ymatrix(svp)
points(xsq[-SVindex(svp),1], xsq[-SVindex(svp),2], pch = ifelse(ymat[-SVindex(svp)] < 0, 2, 1))
points(xsq[SVindex(svp),1], xsq[SVindex(svp),2], pch = ifelse(ymat[SVindex(svp)] < 0, 17, 16))

# Extract w and b from the model   
w <- colSums(coef(svp)[[1]] * xsq[SVindex(svp),])
b <- b(svp)

# Draw the lines
abline(b/w[2],-w[1]/w[2])
abline((b+1)/w[2],-w[1]/w[2],lty=2)
abline((b-1)/w[2],-w[1]/w[2],lty=2)








