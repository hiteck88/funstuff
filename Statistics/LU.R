install.packages('optR')
library(optR)
library(Matrix)
library(MASS)
trifactor <- function(a, d, c){
  l <- a
  u <- d
  
  for (i in 1:length(a)){
    l[i] <- a[i]/u[i]
    u[i+1] <- d[i+1] - l[i]*c[i]
  }
  return(list(l = l, u = u))
  
}

# a is n-1, c is n-1, d is n
a <- c(1, 1)
d <- c(3, 3, 3)
c <- c(1, 1)
res <- trifactor(a = a, d = d, c = d)

l <- res$l
u <- res$u

L <- matrix(c(1, 0, 0, l[1], 1, 0, 0, l[2], 1), 3, 3, byrow = T)
L
U <- matrix(c(u[1], c[1], 0, 0, u[2], c[2], 0, 0, u[3]), 3, 3, byrow = T)
U
L*U



A <- matrix(c(3, 1, 0, 1, 3, 1, 0, 1, 3), 3, 3, byrow = T)
?lu
expand(lu(A))$L * expand(lu(A))$U
?ginv
ginv(A)
?solve


