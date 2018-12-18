library(tidyverse)

str_length('x')
x <- c('x')
x

# duplicate

str_dup(x, 5) # this will make one string hierhierhier..



x5 <- replicate(5, x)
length(x5)



x1 <- paste("x", "1", sep=" ")
fake.df <- data.frame(x1 = replicate(3, x), x2 = seq(1:3))
fake.df
fake.df$comb <- do.call(paste, c(fake.df[c("x1", "x2")], sep = ".")) 
str(fake.df)


# separate(fake.df, col = comb, into = c('variable', 'index'))





