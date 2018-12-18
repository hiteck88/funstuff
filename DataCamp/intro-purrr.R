library(purrr)
install.packages('tidyverse')
library(tidyverse)
install.packages("rwars")
library(rwars)

x <- list(rnorm(1000), rnorm(1000), rnorm(1000))
map(x, mean) # this returns a LIST
lapply(x, mean) 

?lapply

map_dbl(x, mean)   # returns a double vector
sapply(x, mean)
sapply(1:3, function(i) mean(x[[i]]))  # same as above

map_chr(x, mean)   # returns a character

map_int(x, mean)  # this doesn't work

sapply(1:5, function(x) x*2)

map_dbl(1:5, ~ .*2)
map_dbl(1:5, ~ .x *2)
map2_dbl(1:5, 1:5, ~ .x*.y)



# --------------- map
# .x: a vector, list of dataframe(for each column)
# .f


# --------------- examine star wars data
load('data/swapi.rda')
all_planets <- get_all_planets()
planet_schema <- get_planet_schema()
str(all_planets)

people_schema <- get_all_people()


str(people_schema)
str(people)
people_schema$count
people_schema$results[[1]]

people <- people_schema$results

str(people[1])  # list of 1 of list of 16
str(people[[1]]) # list of 16

luke <- people[[1]]


# how many starships has luke been in
length(luke$starships)
map(people, ~ length(.x$starships))

luke$homeworld



people <- people %>% set_names(map_chr(people, 'name'))
head(people$`Luke Skywalker`)
# how many starships has each character been in
map_int(people, ~ length(.x[['starships']]))  # awesome
map_int(people, ~ length('starships'))
map(people, 'starships') %>% map_int(length)


map_chr(people, ~ .x[['hair_color']]) 
map_chr(people, 'hair_color')   # equivalent



map_lgl(people, ~ .x[['gender']] == 'male')   # compared to 'map()', it's more condensed

# ------------- purrr and list columns
# data should be in data frames. cases in rows, variables in columns

people_tbl <- tibble(
  name = people %>% map_chr('name'), 
  films = people %>% map('films'),  # this will be a list 
 #  n_films = map_int(people_tbl$films, length),
  height = people %>% map_chr('height') %>% readr::parse_number(na = 'unknown')
)
people_tbl

# create a new column for the number of films
# use mutate
people_tbl <- people_tbl %>% 
  mutate(
    n_films = map_int(people_tbl$films, length)
  )



# ----------- map2
map2('cat', 3, rep)
map2(c('cat', 'tiger'), c(3, 2), rep)
map2(c('cat', 'tiger'), c(3, 2), rep)


?rerun






