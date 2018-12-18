# Tree based methods 

## Classification tree 

### Advantages

- missing data handling 
- robust to outliers
- little data preparation (i.e. normalisation)
- non linearity 
- fast  (large datasets)

### Disadvantages 

- large trees hard to interpret
- high variance 
- overfits 



### Evaluations

- accuracy: correct predictions (both classes) / total data points (both classes)
- confusion matrix: rownames: predicted; col names: actual 
- log loss
- AUC



### Imputity measure: Gini index 



## Regression Tree 

RMSE is more useful when large errors are undesireable, because it gives higher weight to large errors than MAE



### cost-complexity parameter 

cross validation 

