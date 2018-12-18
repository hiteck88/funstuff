# qplot

ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point()

# same as 
qplot(Sepal.Length, Sepal.Width, data = iris)

qplot(Sepal.Length, Sepal.Width, data = iris, 
      geom = 'jitter', col = Species, 
      alpha = I(0.5))  # this I is needed 


# --------- dot plot: x categorical, y continuous
# with geom_point()
ggplot(mtcars, aes(cyl, wt, col = am)) +
  geom_point(position = position_jitter(0.2, 0))

# with geom_dotplot()
ggplot(mtcars, aes(factor(cyl), wt, fill = factor(am))) +
  geom_dotplot(binaxis = "y", stackdir = 'center')

# with qplot()
qplot(
  factor(cyl), wt,
  data = mtcars,
  fill = factor(am),
  geom = 'dotplot',
  binaxis = 'y',
  stackdir = "center"
)









