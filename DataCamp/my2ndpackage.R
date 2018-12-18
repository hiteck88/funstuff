# an alternative function to see the difference between 2 ways 
install.packages('usethis')
library(usethis)
library(devtools)

cat_function2 <- function(love=TRUE){
  if(love==TRUE){
    print("I love cats!")
  }
  else {
    print("I am not a cool person.")
  }
}
getwd()

usethis::create_package('secondpackage')

