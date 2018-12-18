getwd()
setwd('/Users/andrea/Documents/Programming/R/TimeSeries')


# 1. white noise
w = rnorm(500, 0, 1)  # 500 N(0, 1) varaites, gaussian white noise
plot.ts(w, main = 'white noise')
plot(w, type = 'l')   # same





# 2. moving average, also called filter
# v(t) = 1/3(w(t-1) + w(t) + w(t+1))
v = filter(w, sides = 2, rep(1/3, 3))
# method == convolution, MA
# method == recursive, AR
# sides == 1, only past
# sides == 2, centered at lag 0
plot.ts(v, main = 'moving average')




# 3. autoregressive
# x(t) = x(t-1) - 0.5*x(t-2) + w(t)
# give some starting lags to avoid startup problems, say 20
# the second filter here is strange...
x = filter(w, filter = c(1, -0.5), method = 'recursive')[-(1:20)]
plot.ts(x, main = 'autoregressive')



# 4. random walk (with drift)
# x(t) = delta + x(t-1) + w(t)
# delta == 0, random walk (markov chain, wiener process if normal)
w2 = rnorm(300, 0, 1)
x2 = cumsum(w2)

delta = 0.1
wd = w2 + delta
xd = cumsum(wd)
plot.ts(xd, main = 'random walk', ylim = c(-20, 50))
lines(x2, col = 'red')
lines(0.1*(1:300), lty = 'dashed')

# ok it is REALLY random




