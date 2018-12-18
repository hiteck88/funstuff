# Question: will changing the homepage photo result in more 'Adopt today' clicks? 
# How is it relating to our intervention problem? 
# will changing the intervention result in lower infection rate? 
# it is also a time series so should fit in our case quite well

# ------------ lessons learnt --------------- #
# 1. do a power analysis to find out how many points needed to test a difference
# 2. define the outcome into 1/0
# 3. logistic reg can be helpful to find out the odds ratio in different groups 
# response is probablility of click yes (in our case, improved HAI situation)
# the two conditions for us is whether there is intervention 


# KEY WORD: experimental design - 2 or more variants of a design 
# USED IN: conversion rates (clicks or purchases), engagement (sharing, likes), dropoff, time spend on website 

# ------------ lessons learnt --------------- #

library(tidyverse)
library(lubridate)
click_data <- read_csv('data/click_data.csv')
head(click_data)

plot(click_data$clicked_adopt_today[c(3000:3010)], type = 'l')

# want to know conversion rate over a period of time, monthly, weekly etc

# need to define a baseline
click_data %>% summarise(conversion_rate = mean(clicked_adopt_today))

# conversion rate seasonality

click_data_sum <- click_data %>% 
  group_by(month(visit_date)) %>%   # from lubridate package, for us we can use weekdays
  summarize(conversion_rate = mean(clicked_adopt_today))

ggplot(click_data_sum, aes(x = `month(visit_date)`, y = conversion_rate)) +   # it's ``, not ''!!
  geom_point() + 
  geom_line()

# higher conversion rate in summer.. 

# look a bit more carefully into the weekly average 
click_data_sum_week <- click_data %>%
  group_by(week(visit_date)) %>%
  summarize(conversion_rate = mean(clicked_adopt_today))


ggplot(click_data_sum_week, aes(x = `week(visit_date)`, y = conversion_rate)) +
  geom_point() +
  geom_line() +
  scale_y_continuous(limits = c(0, 1))

# on average it's around 28%
# seasonality can exist
# experimental design and power analysis: how long should we run the analysis
# power analysis is to compute the sample size. before data collection
# need to know what test to use, what baseline the control condition is, what the desired value would be
# proportion of data
# significance threshold: alpha, 0.05
# power: prob of correctly rejecting null, 1 - beta, 0.8


library(powerMediation)
?SSizeLogisticBin  # binary predictor X
# logit(p) = a + bX
# b is odds ratio
# p1: P(diseased | x = 0), event rate at x = 0 
# p2: P(diseased | x = 1), event rate at x = 1
# B: proportion of sample with x = 1
# this tests whether odds ratio is equal to 1
# (in our case X would be no intervention or intervention, and P(improved outcome Yes))



total_sample_size <- SSizeLogisticBin(p1 = 0.2,     # event rate in January, roughly 0.2
                                      p2 = 0.3,     # 10% increase
                                      B = 0.5, 
                                      alpha = 0.05, 
                                      power = 0.8)
total_sample_size
# each group is total / 2
# need to run control and test together, so that they're subject to the same seasonal and other variables

# 5 percent increase
total_sample_size_5 <- SSizeLogisticBin(p1 = 0.2,     # event rate in January, roughly 0.2
                                      p2 = 0.25,     # 10% increase
                                      B = 0.5, 
                                      alpha = 0.05, 
                                      power = 0.8)
total_sample_size_5 
# much larger, I think it's due to the closer H1 is to H0, the smaller variance there should be to avoid overlap of 
# the two curves == large sample size to reduce the variance. 

# in the above example, the outcome is 0 or 1, so we need to define our outcome a bit different too. 


# ================ analyse the results 

experiment_data <- read_csv('data/experiment_data.csv')
head(experiment_data)
experiment_data %>% group_by(condition) %>%
  summarize(conversion_rate = mean(clicked_adopt_today))  # 0.167, 0.384
# why are there 4 controls on the same day? 


experiment_data_sum <- experiment_data %>% 
  group_by(visit_date, condition) %>%   # group by both visit date and condition
  summarize(conversion_rate = mean(clicked_adopt_today))  
experiment_data_sum

ggplot(experiment_data_sum, aes(x = visit_date, y = conversion_rate, 
                                color = condition, group = condition))+ 
  geom_point(size = 4) + 
  geom_line(lwd = 1) +
  scale_y_continuous(limits = c(0, 1))

# test is higher than control 


library(broom)

# do a logistic reg 

glm(clicked_adopt_today ~ condition,   # condition test has higher convrsion rate 
    family = 'binomial', 
    data = experiment_data) %>% 
  tidy()

month(experiment_data$visit_date, label = T)  # this is an interesting function.. with label, it becomes JAN



# take difference between the two measures, compute mean and sd to check whether the difference is consistent 





# ---------------- confounding ----------------- # 
# internal confounding variable: those within an experimental design
# external: such as age, gender

# ---------------- side effect ----------------- # 
# load times 













