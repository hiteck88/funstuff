# from DataCamp ggplot 3
# boxplots 
library(ggplot2)


ggplot(movies_small, aes(x = rating, y = votes)) +
  geom_point() +
  stat_summary(fun.data = "mean_cl_normal",
               geom = 'crossbar',
               width = 0.2,
               col = 'red') +
  scale_y_log10()

# diamond data
ggplot(diamonds, aes(x = carat, y = price, col = color)) +
  geom_point(alpha = 0.5, size = 0.5, shape = 16) +
  scale_y_log10(expression(log[10](Price)), limits = c(100, 100000)) +
  scale_x_log10(expression(log[10](Carat)), limits = c(0.1, 10)) +
  scale_color_brewer(palette = "YlOrRd") +
  coord_equal() +
  theme_classic()

# stat smooth layer 
ggplot(diamonds, aes(x = carat, y = price, col = color)) +
  stat_smooth(method = "lm", se = FALSE)+
  scale_x_log10(expression(log[10](Carat)), limits = c(0.1,10)) +
  scale_y_log10(expression(log[10](Price)), limits = c(100,100000)) +
  scale_color_brewer(palette = "YlOrRd") +
  coord_equal() +
  theme_classic()

# transform 
d + scale_y_log10()

# Transform the coordinates
d + coord_trans(y = 'log10')

# grouping boxplot 
p <- ggplot(diamonds, aes(x = carat, y = price))
p + geom_boxplot(aes(group = cut_interval(carat, n = 10)))
p + geom_boxplot(aes(group = cut_number(carat, n = 10)))

# Use cut_width
p + geom_boxplot(aes(group = cut_width(carat, width = 0.25)))

?quantile

# ============= density plot
# kernel density estimate KDE
# empirical density plot 
x <- c(0, 1, 1.1, 1.5, 1.9, 2.9, 3.5)

# each one as a center 
?pnorm
pnorm(0, mean = 0, sd = 1)  # 0.5, since it's the middle of cdf
dnorm(0, mean = 0, sd = 1)  # 0.3989
plot(pnorm(seq(-2, 2, by = 0.1), mean = 0, sd = 1), type = 'l') # cdf
plot(dnorm(seq(-2.5, 2.5, by = 0.1), mean = 0, sd = 1), type = 'l') # pdf

pdf <- function(center){
  sequence <- seq((-2.5+center), (2.5+center), by = 0.1)
  density <- dnorm(sequence, 
                   mean = center, sd = 1)
  return(list(density = density, sequence = sequence))
}

library(purrr)


pdfs.of.x <- 1:7 %>% 
  map(function(s) pdf(x[s]))


plot(pdfs.of.x[[1]]$sequence, pdfs.of.x[[1]]$density, 
     xlim = c(-2, 7), type = 'l', ylim = c(0, 3))

for(i in 2:7){
  lines(pdfs.of.x[[i]]$sequence, pdfs.of.x[[i]]$density)
}


which(pdfs.of.x[[1]]$sequence == pdfs.of.x[[2]]$sequence)
pdfs.of.x[[7]]$sequence
pdfs.of.x[[7]]$density


pdfs.of.x[[1]]$density[which(pdfs.of.x[[1]]$sequence == 6)]

ranges <- seq(-2.5, 6, by = 0.1)


value <- function(X){


    val <- sum(pdfs.of.x[[1]]$density[which(round(pdfs.of.x[[1]]$sequence, 2) == X)], 
               pdfs.of.x[[2]]$density[which(round(pdfs.of.x[[2]]$sequence, 2) == X)],
               pdfs.of.x[[3]]$density[which(round(pdfs.of.x[[3]]$sequence, 2) == X)],
               pdfs.of.x[[4]]$density[which(round(pdfs.of.x[[4]]$sequence, 2) == X)],
               pdfs.of.x[[5]]$density[which(round(pdfs.of.x[[5]]$sequence, 2) == X)],
               pdfs.of.x[[6]]$density[which(round(pdfs.of.x[[6]]$sequence, 2) == X)],
               pdfs.of.x[[7]]$density[which(round(pdfs.of.x[[7]]$sequence, 2) == X)])
    

  return(val = val)
}
round(pdfs.of.x[[3]]$sequence, 2)
which(round(pdfs.of.x[[3]]$sequence, 2)== 1.8)

value(ranges[[64]])
class(ranges)
value(3.8)


# ----------------- use ggplot
# ues test data rnorm(0, 1)

test_data <- data.frame(norm = rnorm(100, 0, 1))
d <- density(test_data$norm)

# Use which.max() to calculate mode
mode <- d$x[which.max(d$y)]  # highest density

# Finish the ggplot call
ggplot(test_data, aes(x = norm)) +
  geom_rug() +  # gives the denstiy below xaxis 
  geom_density() +
  geom_vline(xintercept = mode, col = "red")

# ---- compare with a theoretical pdf and histogram
fun_args <- list(mean = mean(test_data$norm), sd = sd(test_data$norm))

ggplot(test_data, aes(x = norm)) + 
  geom_histogram(aes(y = ..density..)) +
  geom_density(col = 'red') + 
  stat_function(fun = dnorm, args = fun_args, col = 'blue')


# ---- adjusting density plots: smoothing bandwidth and kernel 
small_data <- data.frame(x = c(-3.5, 0, 0.5, 6))
get_bw <- density(small_data$x)$bw  # how do people compute this?

p <- ggplot(small_data, aes(x = x)) +
  geom_rug() +
  coord_cartesian(ylim = c(0,0.5))
p + geom_density(adjust = 0.25)  # change the bandwidth
p + geom_density(bw = 0.25*get_bw)  # equivalent

p + geom_density(kernel = 'r')  # rectangular
p + geom_density(kernel = 'g')  # gaussian
p + geom_density(kernel = 't')  # triangle
p + geom_density(kernel = 'e')  # epanechnikov
p + geom_density(kernel = 'c')  # cosine 


# difference facet wrap and grid: wrap takes one variable, grid can take more



g <- ggplot(mpg, aes(displ, hwy))
g + geom_point(alpha=1/3) + facet_grid(cyl~class)  # some are also empty
g + geom_point(alpha=1/3) + facet_wrap(cyl~class)  # only the slots with actual values 


# ========== bivariate 
library(datasets)
install.packages('viridis')
library(viridis)
faithful
p <- ggplot(faithful, aes(x = waiting, y = eruptions)) +
  scale_y_continuous(limits = c(1, 5.5), expand = c(0, 0)) +
  scale_x_continuous(limits = c(40, 100), expand = c(0, 0)) +
  coord_fixed(60 / 4.5)

# the larger bin width is, the smoother the border is 
p + geom_density_2d(h = c(15, 0.5))
p + geom_density_2d(h = c(5, 1))
p + stat_density_2d(aes(col = ..level..), h = c(5, 0.5))


ggplot(faithful, aes(x = waiting, y = eruptions)) +
  scale_y_continuous(limits = c(1, 5.5), expand = c(0,0)) +
  scale_x_continuous(limits = c(40, 100), expand = c(0,0)) +
  coord_fixed(60/4.5) +
  stat_density_2d(geom = "tile", aes(fill = ..density..), h=c(5,.5), contour = FALSE) + scale_fill_viridis()










