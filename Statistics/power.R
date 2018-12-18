library(purrr)
library(dplyr)
library(ggplot2)
# 


mu0 <- 30
mua <- 32
sigma <- 4
n <- 16

alpha <- 0.05
z <- qnorm(1-alpha)  # 1.64, the 0.95 quantile

# this is the null hypo, prob after 30+1.64*sigma/sqrt(n)
# also the alpha. note that this is the blue curve! 
pnorm(mu0 + z*sigma/sqrt(n), 
      mean = mu0, 
      sd = sigma/sqrt(n), 
      lower.tail = FALSE)


# probability of detecting mean equal or greater than 30

# these are the alternative hypo
# when mean_alt is 30, it's the same as null, hence power (area on the right)
# is the same as alpha (0.05)
# then as mean alt grows, the more right it shifts
# area on the right (power) grows too, not 0.05 anymore 
# when null and alt completely separate, power = 1
Mua <- seq(30, 36, by = 0.5)
N <- c(8, 16, 32, 64, 128)

map_dbl(Mua, ~ pnorm(mu0 + z*sigma/sqrt(n), 
                     mean = .x, 
                     sd = sigma/sqrt(n), 
                     lower.tail = FALSE))
res <- matrix(rep(0, 5*13), 13, 5)
for(i in 1:5){
  res[, i] <- map_dbl(Mua, ~ pnorm(mu0 + z*sigma/sqrt(N[i]), 
                       mean = .x, 
                       # note that the position of null is unchanged
                       # only the whole distribution of alt changes
                       sd = sigma/sqrt(N[i]), 
                       lower.tail = FALSE))
}
res <- data.frame(res)
colnames(res) <- c('n8', 'n16', 'n32', 'n64', 'n128')

res <- res %>% mutate(mua = Mua)
ggplot(res, aes(x = mua)) +
  geom_line(aes(y = n8, color = 'n8')) + 
  geom_line(aes(y = n16, color = 'n16')) + 
  geom_line(aes(y = n32, color = 'n32')) + 
  geom_line(aes(y = n64, color = 'n64')) + 
  geom_line(aes(y = n128, color = 'n128')) 

