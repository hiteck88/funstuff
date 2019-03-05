library(h2o)

h2o.init(max_mem_size = '500M')   # limit memory size



# import folder is good for images 
# note that nothing is in environment (java)
train.hex <- h2o.importFile('data/ames_train.csv')
class(train.hex)  # h2o frame, not dataframe 


train <- read.csv('data/ames_train.csv')
class(train)   # this is a dataframe, and in environment 

# or, can use as.h2o(train) to make it a hex. 


# ----------- investigate 
# can use head(train.hex) of course 
h2o.describe(train.hex)
h2o.nrow(train.hex)     # dim(train.hex)

# ------------ load test 
test.hex <- h2o.importFile('data/ames_test.csv')
h2o.describe(test.hex)


# AUTOML

y <- 'SalePrice'
x <- setdiff(h2o.names(train.hex), c('Id', y))   # want x to be everything apart from saleprice and ID 

# it starts with GBM or linear, then decide more 
?h2o.automl
mod <- h2o.automl(x = x, y = y, 
           training_frame = train.hex, 
           max_models = 10,    # 10 models, but not necessarily 10 different 
           seed = 3)  
mod
# outcome is a S4 class object 

lb <- mod@leaderboard
print (lb, n = nrow(lb))

# stacked ensemble all models () best of family (one from each of the model classes )

class(lb)
typeof(lb)   # it's not a dataframe

lbdf <- as.data.frame(lb)

allmod <- grep('AllModels', lbdf$model_id, value = T)   # instead of using the full name

se_allmod <- h2o.getModel(allmod)  # stack ensemble 
se_allmod_ml <- h2o.getModel(se_allmod@model$metalearner$name)
h2o.varimp(se_allmod_ml)  # here it is independent of the models
h2o.varimp_plot(se_allmod_ml)


# best model 
# bestmodname <- grep('XGBoost_3', lbdf$model_id, value = T) , with this approach will need to use getModel. 

bestmod <- h2o.getModel(lbdf$model_id[1])
h2o.varimp_plot(bestmod)   # variable importance plot 

# best model is the same as mod@leader



# -------------------- prediction 
# missing values are in training set, and it makes prediction hard since test data has new info 

best_pred <- h2o.predict(mod@leader, newdata = test.hex)
best_pred

write.csv(as.data.frame(best_pred), 'best_prediction.csv', 
          row.names = F)


# try another model, not the leader 

gbm1 <- grep('GBM_1', lbdf$model_id, value = T)   # instead of using the full name

gbm1_mod <- h2o.getModel(gbm1)  # stack ensemble 
gbm1_pred <- h2o.predict(gbm1_mod, newdata = test.hex)
gbm1_pred


# compare these two 
num_gmb1_pred <- as.data.frame(gbm1_pred)
num_best_pred <- as.data.frame(best_pred)

cor(num_best_pred, num_gmb1_pred)     # correlation 
preds <- cbind(num_best_pred, num_gmb1_pred)
plot(preds)

?plot
# h2o.shutdown()
