
data = matrix(rnorm(100, 5, 10), 50, 2)
data
s <- scale(data)    # each column centered at 0

var(s)
cov(s)

var(data)   # if there's no correlation, var == cov
cov(data)

apply(data, 2, mean)
apply(data, 2, var)

apply(s, 2, mean)  # 0
apply(s, 2, var)   # 1


plot(data)
plot(s)
