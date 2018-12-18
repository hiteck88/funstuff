ggplot(diamonds, aes(x = cut, y = price, col = color)) + 
  geom_boxplot(varwidth = T) + 
  facet_grid(. ~ color)



