# learn how to create packages

library(devtools)
library(roxygen2)

getwd()
create('firstpackage')
# ------ create functions, add documentation, 
# then put them under the R folder 




# ------ start building package
setwd('./firstpackage')
document()

# ------ set back to parent directory
getwd()
setwd('..')
install('firstpackage')
firstpackage::cat_function()
?cat_function




