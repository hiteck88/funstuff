library(broom)
library(gapminder)
library(dplyr)     # flexible grammar of data manipulation
library(tidyr)
library(purrr)      # functional programming toolkit
means <- map_dbl(mtcars, mean)
means
# same as..not exactly! map_dbl is for list 
apply(mtcars, 2, mean)

?mutate

# gapminder data example
str(gapminder)

gapminder <- gapminder %>% mutate(year1950 = year - 1950)
# the model to be used in every country data
country_model <- function(df){
  lm(lifeExp ~ year1950, data = df)
}

models <- gapminder %>%
  group_by(continent, country) %>%
  nest() %>%
  mutate(     # adds new variables and preserves existing
    mod = data %>% map(country_model)
  )
str(models)
models$continent
models$mod[[1]]

models %>% filter(continent == 'Africa')

# ------------ broom
# gives a lot of dataframes
?broom::augment

models <- models %>%
  mutate(
    tidy    = mod %>% map(broom::tidy),    # model estimates
    glance  = mod %>% map(broom::glance),  # summary
    r.sqd   = glance %>% map_dbl('r.squared'),
    augment = mod %>% map(broom::augment)
  )
models

unnest(models, tidy) %>% View()
unnest(models, glance) %>% View()
