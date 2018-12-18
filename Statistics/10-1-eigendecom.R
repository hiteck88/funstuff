# -------------- eigen decomposition
# X = U D U(t)

mat <- cbind(c(1,-1), c(-1,1))
  

# decompose
decom <- eigen(mat)
decom$values
U <- decom$vectors
D <- diag(decom$values)

U %*% D %*% t(U)   # this gives the original matrix
  


# --------------- singular value decomposition
# X = U D V(t)

svdecom <- svd(mat)
D2 <- diag(svdecom$d)
U2 <- svdecom$u
V <- svdecom$v

U2 %*% D2 %*% t(V)

# note -------------- for symmetrical mat, singular = eigen

# 2 -------------- example for non-square matrix
# but ED doesn't exist for non-square mat
mat2 <- matrix(seq(1, 12, by = 1), 4, 3) # 4*3
mat2
t(mat2) %*% mat2  # 3*3
eigenvalue <- eigen(t(mat2) %*% mat2)$values

sinvalue <- svd(mat2)$d
round(sinvalue^2 - eigenvalue, 3)
# verified. singular value of N*p matrix X == sqrt of eigenvalue of t(X)%*%X






