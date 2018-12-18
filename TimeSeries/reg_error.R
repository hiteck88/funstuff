setwd('/Users/andrea/Documents/Programming/R/TimeSeries')
library(astsa)
# use two datasets
?part # particulate levels from LA pollution study, 508
?cmort  # cardiovascular mortality from LA pollution study
?tempr  # temperatures 

par(mfrow = c(1, 1))
plot(part, ylim = c(20, 130))
lines(cmort, col = 'red')
lines(tempr, col = 'blue')



trend <- time(cmort)
trend
tempr
temp <- tempr - mean(tempr)
temp2 <- temp^2

# fit a model of form
# M_t = b1 + b2t + b3T_t + b4T_t^2 + b5P_t + x_t
# x_t could be correlated

# step 1. do a linear regression as if non correlated
fit <- lm(cmort ~ trend + temp + temp2 + part, na.action = NULL)
lines(fitted(fit), col = 'green')

# step 2. check residual with arma
acf2(resid(fit), 52) # indicates AR2

# step 3. fit with arima 
fit2 <- arima(cmort, order = c(2, 0, 0), 
              xreg = cbind(trend, temp, temp2, part))
fit2
acf2(resid(fit2), 52) # no obvious departure from whiteness

# step 4. other checks
?Box.test
# null: independence of time series
Q1 <- Box.test(resid(fit),12, type = 'Ljung')
Q1$p.value   

Q2 <- Box.test(resid(fit2), 12, type = 'Ljung')
Q2$p.value   # not significant
# why need fitdf? number of df to be subtracted if x is residuals






