U <- c(0.3153, 0.6349, 0.3516, 0.2929, 0.4611, 0.2748)
V <- c(0.9468, 0.3219)
sigma <- 156.4358
sigma*U %*% t(V)


size <- sigma * U
size
size * V[1]
size * V[2]
