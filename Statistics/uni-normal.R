U1 <- runif(1000)
U2 <- runif(1000)
plot(U1)
plot(U2)
hist(U1)
hist(U2)

# BOX MULLER TRANSFORMATION
# pseudo-random number sampling
# can transform uni(0,1) into standard normal data

Z0 <- sqrt(-2*log(U1))* cos(2*pi * U2)
Z1 <- sqrt(-2*log(U1))* sin(2*pi * U2)
plot(Z0)
plot(Z1)

hist(Z0)
hist(Z1)

