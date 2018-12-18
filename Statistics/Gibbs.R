
# http://blog.csdn.net/abcjennifer/article/details/25908495

# define Gauss Posterior Distribution
# bivariate normal dist, f(x|y), f(y|x) (check online)

p_ygivenx <- function(x,m1,m2,s1,s2)
{
  return (rnorm(1,m2+rho*s2/s1*(x-m1),sqrt(1-rho^2)*s2 ))
}

p_xgiveny <- function(y,m1,m2,s1,s2)
{
  return 	(rnorm(1,m1+rho*s1/s2*(y-m2),sqrt(1-rho^2)*s1 ))
}


N = 5000
K = 20         #iteration in each sampling
x_res = vector(length = N)
y_res = vector(length = N)
m1 = 10; m2 = -5; s1 = 5; s2 = 2
rho = 0.5
y = m2

for (i in 1:N)
{
  for(j in 1:K)
  {
    x = p_xgiveny(y, m1,m2,s1,s2)
    y = p_ygivenx(x, m1,m2,s1,s2)
    # print(x)
    x_res[i] = x;
    y_res[i] = y;
  }
}

hist(x_res,freq = 1)
dev.new()
plot(x_res,y_res)
library(MASS)
valid_range = seq(from = N/2, to = N, by = 1)
MVN.kdensity <- kde2d(x_res[valid_range], y_res[valid_range], h = 10) #estimate kernel density
plot(x_res[valid_range], y_res[valid_range], col = "blue", xlab = "x", ylab = "y") 
contour(MVN.kdensity, add = TRUE) #bivariate contour plot

# real distribution
# real = mvrnorm(N,c(m1,m2),diag(c(s1,s2)))
# dev.new()
# plot(real[1:N,1],real[1:N,2])
