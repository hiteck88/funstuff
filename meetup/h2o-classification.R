library(h2o)
h2o.init(max_mem_size = '500M')   # limit memory size


# --------------- prepare dataset, combine 2 dataset 

# this is still a regression problem (10 classes but still very subjective classes )
wine_red <- read.csv('data/winequality-red.csv', sep = ';', 
                      stringsAsFactors = F)

wine_white <- read.csv('data/winequality-white.csv',  sep = ';', 
                        stringsAsFactors = F)

all.equal(names(wine_white), names(wine_red))    # see if they contain the same variables 

# assign some labels 
wine_red$type <- 'red'
wine_white$type <- 'white'
wine <- rbind(wine_red, wine_white)
head(wine)

hist(wine$quality)

# don't introduce unnecessary class imbalance, but here fine
wine$quality_class <- factor(as.integer(wine$quality >= 7), 
                             level = c(0, 1),    # this is a fast way to specify human readable labels 
                             labels = c('average', 'premium'))
table(wine$quality_class)   # roughly 4:1 average vs premium 



# ---------------- prepare training and test set
wine.hex <- as.h2o(wine)
wine.hex.split <- h2o.splitFrame(wine.hex)    # don't even need to specify the proportion 

y <- 'quality_class'
x <- setdiff(h2o.names(wine.hex), c('quality', 'quality_class')) 




# ---------------- start model 

mod_wine <- h2o.automl(x, y, wine.hex.split[[1]],  # train on the first part 
                       max_models = 10, 
                       seed = 3)


mod_wine@leaderboard

# --------------- examine 
# with stacked ensemble we can't plot variable importance directly 

mod_wine@leader
lbdf <- as.data.frame(mod_wine@leaderboard)
topmod <- h2o.getModel(lbdf$model_id[3])
h2o.varimp_plot(topmod)   # alcohol is most important 



print (mod_wine@leaderboard, n = 12)


# --------------- prediction performance 

h2o.performance(topmod, newdata = wine.hex.split[[2]])






