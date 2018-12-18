setwd('/Users/andrea/Documents/Programming/R/TimeSeries')
library(astsa)

?cmort   # cardiovascular mortality from LA pollution study
# average weekly cardiovascular mortality, 508
cmort
plot(cmort)  # seems to have a trend, and very periodical

# --------------------   1. MA smoother
# 5 point MA, a monthly smoother
ma5 = filter(cmort, sides = 2, rep(1, 5)/5)
plot(cmort, type = 'p', ylab = 'mortality')
lines(ma5, col = 'red')

# 53 point MA, a yearly smoother
ma53 = filter(cmort, sides = 2, rep(1, 53)/53)
plot(cmort, type = 'p', ylab = 'mortality')
lines(ma53, col = 'red')


# -------------- 2. polynomial and periodic regression

mean(time(cmort))
wk = time(cmort) - mean(time(cmort))
wk2 = wk^2
wk3 = wk^3
cs = cos(2*pi*wk)
sn = sin(2*pi*wk)

# cubic smoother
reg1 = lm(cmort ~ wk + wk2 + wk3, na.action = NULL)
plot(cmort, type = 'p', ylab = 'mortality')
lines(fitted(reg1), col = 'red')

# with a periodic regre
reg2 = lm(cmort ~ wk + wk2 + wk3 + cs + sn, na.action = NULL)
lines(fitted(reg2), col = 'blue')



?ksmooth





