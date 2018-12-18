# re-arrange data to make it suit my purpose 

library(tidyr)
# tidy data: each row is an observation and column is a variable 
# gather() moves info from columns to the rows 
# separate() splits one column into 2
head(iris)
iris.tidy <- iris %>%
  gather(key, Value, -Species) %>%   # gather categorical
  separate(key, c("Part", "Measure"), "\\.")  # create new 
head(iris.tidy)



# Add column with unique ids (don't need to change)
iris$Flower <- 1:nrow(iris)

# Fill in the ___ to produce to the correct iris.wide dataset
iris.wide <- iris %>%
  gather(key, value, -Species, -Flower) %>%
  separate(key, c('Part', 'Measure'), "\\.") %>%
  spread(Measure, value)




# -------------- gather 
# for instance, the current dataframe has species, length, width
# gather(original data, 
#        name of key column (part), 
#        name of value column (measure value), 
#        name of grouping variable with - in front)





# get first observation for each Species in iris data -- base R
mini_iris <- iris[c(1, 51, 101), ]
mini_iris
# gather Sepal.Length, Sepal.Width, Petal.Length, Petal.Width
# basically turned 4 column titles into a separate column named Part 
mini_iris2 <- gather(mini_iris, key = Part, value = Measure,
                     Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)
# same as
gather(mini_iris, key = Part, value = Measure, -Species) # all apart from Species
# then separaet 




