# jitter
ggplot(mtcars, aes(x = mpg, y = 0)) +
  geom_point()

ggplot(mtcars, aes(x = 0, y = mpg)) +
  geom_jitter()
plot(mtcars$mpg) # equivalent, though the x index is different 

ggplot(mtcars, aes(x = mpg, y = 0)) +
  geom_jitter()+ scale_y_continuous(limits = c(-2, 2))

ggplot(mtcars, aes(x = cyl, y = wt)) +
  geom_jitter(width = 0.1)
# equivalent to 
ggplot(mtcars, aes(x = cyl, y = wt)) +
  geom_point(position = position_jitter(0.1))

ggplot(Vocab, aes(x = education, y = vocabulary)) + 
  geom_jitter(shape = 1, alpha = 0.2)



ggplot(mtcars, aes(x = wt, y = mpg, color = cyl)) + 
  geom_point(size = 4, shape = 1)

# for large dataset, better to set transparancy
ggplot(diamonds, aes(x = carat, y = price, color = clarity)) + 
  geom_point(alpha = 0.5)

# can use jitter to avoid everything on the same line
ggplot(diamonds, aes(x = clarity, y = carat, color = price)) + 
  geom_point(alpha = 0.5, position = 'jitter')

ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, col = Species)) + 
  geom_jitter() + 
  scale_color_brewer(palette = 'Dark2')
# other options: 
# Accent, Paired, Pastel1, Pastel2, Set1, Set2, Set3




# =================== bar plots

# 1. histogram
ggplot(iris, aes(x = Sepal.Width, fill = Species)) + 
  geom_histogram(binwidth = 0.1)  # simply setting transparancy doesn't work

ggplot(iris, aes(x = Sepal.Width, fill = Species)) + 
  geom_histogram(binwidth = 0.1, position = 'fill')  


ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(binwidth =1, fill = '#377EB8', aes(y = ..density..)) # changes count into density


# 2. bar
mtcars$mpg
posn_d <- position_dodge(width = 0.2) 
# with position as dodge
ggplot(mtcars, aes(x = cyl, fill = factor(am))) +
  geom_bar(position = posn_d, alpha = 0.6) 

ggplot(iris, aes(x = Sepal.Width, fill = Species)) + 
  geom_histogram(binwidth = 0.1)  # simply setting transparancy doesn't work

barplot(mtcars$cyl)

# remember the factor!!!!
ggplot(mtcars, aes(x = mpg, fill = factor(cyl))) +
  geom_histogram(binwidth = 0.5)
ggplot(mtcars, aes(mpg, color = factor(cyl))) +
  geom_freqpoly(binwidth = 1)



# this is cool 
install.packages('RColorBrewer')

ggplot(iris, aes(x = Sepal.Width, fill = Species)) +
  geom_bar(position = "fill") +
  scale_fill_brewer()
blues <- brewer.pal(9, "Blues") 
blue_range <- colorRampPalette(blues)


# 2 - Use blue_range to adjust the color of the bars, use scale_fill_manual()
ggplot(iris, aes(x = Sepal.Width, fill = Species)) +
  geom_bar(position = "fill") +
  scale_fill_manual(values = blue_range(11))




# ============== line plots

data("economics")
economics2 <- economics[c(1:6), ]
str(economics2)

ggplot(economics, aes(x = date, y = unemploy)) + geom_line()
?geom_rect

# chick weight data
ChickWeight
ggplot(ChickWeight, aes(x = Time, y = weight, color = Diet)) +
  geom_line(aes(group = Chick), alpha = 0.3) + 
  geom_smooth(lwd = 2, se = F)


Titanic
str(Titanic)





