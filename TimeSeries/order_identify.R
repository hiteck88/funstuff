setwd('/Users/andrea/Documents/Programming/R/TimeSeries')

# Try the rules of thumb\


w = rnorm(500, 0, 1)  # 500 N(0, 1) varaites, gaussian white noise
# 1. Moving average
# v(t) = 1/3(w(t-1) + w(t))
v = filter(w, sides = 1, rep(1/3, 2), method = 'convolution')
# method == convolution, MA
# method == recursive, AR
# sides == 1, only past
plot.ts(v, main = 'moving average')
acf(v, type = 'correlation')

?acf

?arima

w <- arima.sim(n = 100, list(ar = c(0.8, -0.4), ma = c(-0.2279, 0.3, 0.1)),
               sd = 1)
plot(w)
acf(w)
pacf(w)
fit1 <- arima(w, c(2, 0, 0))
fit1
acf(fit1$residuals, ci.type = "white")   # cut off, exist ma
pacf(fit1$residuals)



fit2 <- arima(w, c(2, 0, 1))
fit2

fit3 <- arima(w, c(2, 0, 2))
fit3$residuals
acf(fit3$residuals)
pacf(fit3$residuals)

BIC(fit1, fit2, fit3)



require(graphics)
## Examples from Venables & Ripley
acf(lh)
acf(lh, type = "covariance")
pacf(lh)

acf(ldeaths)
acf(ldeaths, ci.type = "ma")
acf(ts.union(mdeaths, fdeaths))
ccf(mdeaths, fdeaths, ylab = "cross-correlation")
# (just the cross-correlations)

presidents # contains missing values
acf(presidents, na.action = na.pass)
pacf(presidents, na.action = na.pass)
# I can't really tell the difference...


