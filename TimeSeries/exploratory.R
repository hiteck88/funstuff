getwd()
setwd('/Users/andrea/Documents/Programming/R/TimeSeries')
library(astsa)
gtemp   # global mean land-ocean temperature deviations
        # time series object
time(gtemp)
plot(gtemp)   # increasing trend

# first regress gtemp on time
fit <- lm(gtemp ~ time(gtemp), na.action = NULL)

# the residual is the detrended value?
plot(resid(fit), type = 'o', main = 'detrended')
plot(diff(gtemp), type = 'o', main = 'first difference')

# then plot the acf
acf(gtemp, 48, main = 'gtemp')
acf(resid(fit), 48, main = 'detrended')
acf(diff(gtemp), 48, main = 'first difference')


# detect drift, in case need a random walk with drift
mean(diff(gtemp))




# ------------ another dataset 
# lagged scatterplot matrix
?soi

soi
plot(soi)
length(soi) # 453 data

acf(soi, 48)    # seems to be a seasonal trend
acf(diff(soi))



?lag1.plot  # produces a grid of scatterplots of series vs lagged values
lag1.plot(soi, 12, corr = T)

?diff





