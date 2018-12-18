# data camp course: data visualisation with ggplot2
install.packages('ggplot2')
library(ggplot2)
library(RColorBrewer)
str(mtcars)

# plot mpg against cyl, note that cyl has to be a categorical
ggplot(mtcars, aes(x = factor(cyl), y = mpg)) + 
  geom_point()

# ---------- change aesthetics 

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point()

# change color and size
# color argument has to be inside aes()! 
ggplot(mtcars, aes(x = wt, y = mpg, color = disp, size = disp)) +
  geom_point()

# ---------- change geometry
diamonds.sub <- diamonds[1:1000, ]
str(diamonds.sub)

ggplot(diamonds.sub, aes(x = carat, y = price)) + geom_point() + geom_smooth()

# alpha is the parameter for visibility
ggplot(diamonds.sub, aes(x = carat, y = price, color = clarity)) + 
  geom_point(alpha = 0.4)

# ---------- another way of doing it 
dia_plot <- ggplot(diamonds.sub, aes(x = carat, y = price))
# Add the same geom layer, but with aes() inside
dia_plot + geom_point(aes(color = clarity))



# -------------------- compare with base
mtcars$cyl <- as.factor(mtcars$cyl)


plot(mtcars$wt, mtcars$mpg, col = mtcars$cyl)
abline(lm(mpg ~ wt, data = mtcars), lty = 2)
# one regression for each cyl group 
lapply(mtcars$cyl, function(x) {
  abline(lm(mpg ~ wt, mtcars, subset = (cyl == x)), col = x)
})
legend(x = 5, y = 33, legend = levels(mtcars$cyl),
       col = 1:3, pch = 1, bty = "n")


# Plot 1: add geom_point() to this command to create a scatter plot
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + geom_point()  

# Plot 2: include the lines of the linear models, per cyl
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + 
  geom_point() + 
  geom_smooth(method = 'lm', se = FALSE)  

# Plot 3: include a lm for the entire dataset in its whole
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + 
  geom_point() + 
  geom_smooth(method = 'lm', se = FALSE) + 
  geom_smooth(aes(group = 1), method = 'lm', se = FALSE, linetype = 2)



# --------------- aesthetics
ggplot(mtcars, aes(x = wt, y = mpg, color = cyl)) +
  geom_point(shape = 1, size = 4)

# Change shape and alpha of the points in the above plot
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
  geom_point(shape = 21, size = 4, alpha = 0.6)


# Map am to col in the above plot
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl, col = am)) +
  geom_point(shape = 21, size = 4, alpha = 0.6)

ggplot(mtcars, aes(x = wt, y = mpg, alpha = cyl)) +
  geom_point()

# Map cyl to shape 
ggplot(mtcars, aes(x = wt, y = mpg, shape = cyl)) +
  geom_point()

# Map cyl to label
ggplot(mtcars, aes(x = wt, y = mpg, label = cyl)) +
  geom_text()

my_color <- "#4ABEFF"
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
  geom_point(color = my_color, size = 10, shape = 23, color = my_color)

ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) + 
  geom_text(label = rownames(mtcars), color = 'red') 

ggplot(mtcars, aes(x = mpg, y = qsec, 
                   color = factor(cyl), 
                   shape = factor(am), 
                   size = (hp/wt))) + geom_point()

# ------------------- base layer 
cyl.am <- ggplot(mtcars, aes(x = factor(cyl), fill = factor(am)))

# bar plot (stacked)
cyl.am + 
  geom_bar()

cyl.am + 
  geom_bar(position = 'fill')  # show proportions

cyl.am +
  geom_bar(position = 'dodge') 

val = c("#E41A1C", "#377EB8")
lab = c("Manual", "Automatic")
cyl.am +
  geom_bar(position = "dodge") +
  scale_x_discrete('Cylinders') + 
  scale_y_continuous('Number') +
  scale_fill_manual('Transmission', 
                    values = val,  # change color
                    labels = lab)  # change label 










