setwd('/Users/andrea/Documents/Programming/R')
# try a mixed model

library(MASS)
library(nlme)
data("oats")
oats
# data from oats field trial

# B: blocks, 1,2, ... 6
# V: varieties, 3
# N: nitrogen treatment, 4 levels
# Y: yield (response)
names(oats) <- c('block', 'variety', 'nitrogen', 'yield')


plot(oats$block, oats$yield)
plot(oats$variety, oats$yield)
plot(oats$nitrogen, oats$yield)

?lme
m <- lme(yield ~ variety +nitrogen, 
         random = ~ 1|variety, data = oats)
m
summary(m)





