# data manipulation
library(ggplot2)
library(gapminder)
library(dplyr) 

# filter
gapminder %>% 
  filter(year == 2007)
gapminder %>%
  filter(year == 2007, country == 'United States')

# arrange: sorts a table based on a variable 
gapminder %>% 
  arrange(gdpPercap)
gapminder %>% 
  arrange(desc(gdpPercap)) # descending order 

gapminder %>% 
  filter(year == 2007) %>% 
  arrange(desc(gdpPercap))

# mutate: replace the one on the left with right 
gapminder %>% 
  mutate(pop = pop/1000000)  

gapminder %>% 
  mutate(gdp = gdpPercap * pop)   # or to add a new variable 

# summarize 
str(gapminder)

gapminder %>% 
  summarize(meanLifeExp = mean(lifeExp))  # same as mean(gapminder$lifeExp)

gapminder %>% 
  filter(year == 2007) %>%
  summarize(meanLifeExp = mean(lifeExp), 
            totalPop = sum(as.numeric(pop)))  

# group_by
gapminder %>% 
  group_by(year, continent) %>%
  summarize(meanLifeExp = mean(lifeExp), 
            totalPop = sum(as.numeric(pop)))  






# ====================== visualisation with ggplot2
gapminder_2007 <- gapminder %>% filter(year == 2007)
gapminder_2007

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) + 
  geom_smooth() + 
  geom_point() + 
  scale_x_log10()  # x axis on log10 scale

ggplot(gapminder_2007, 
       aes(x = gdpPercap, y = lifeExp, 
           color = continent, size = pop)) + 
  geom_point() + 
  scale_x_log10()  # x axis on log10 scale


# faceting: create subplots
ggplot(gapminder_2007, 
       aes(x = gdpPercap, y = lifeExp, 
           color = continent, size = pop)) + 
  geom_point() + 
  scale_x_log10() +  # x axis on log10 scale
  facet_wrap( ~ continent)  # subplot based on continent variable 


# create object 
by_year <- gapminder %>% 
  group_by(year) %>%
  summarize(totalPop = sum(as.numeric(pop)))  
ggplot(by_year, aes(x = year, y = totalPop)) + 
  geom_point() + 
  expand_limits(y = 0)


by_year_continent <- gapminder %>% 
  group_by(year, continent) %>%
  summarize(meanLifeExp = mean(lifeExp), 
            totalPop = sum(as.numeric(pop)))  
ggplot(by_year_continent, aes(x = year, y = totalPop, color = continent)) + 
  geom_line() + 
  expand_limits(y = 0)


# barplot

by_continent <- gapminder %>% 
  group_by(continent) %>%
  summarize(meanLifeExp = mean(lifeExp))  
ggplot(by_continent, aes(x = continent, y = meanLifeExp)) +
  geom_col()

# histogram
# geom_histogram(binwidth = 5) means each bin is 5 years (units)
# scale_x_log10()

gapminder_1952 <- gapminder %>%
  filter(year == 1952)

# boxplot
ggplot(gapminder_1952, aes(x = continent, y = lifeExp)) + 
  geom_boxplot() + 
  ggtitle('Comparing life expectancy across continents')










