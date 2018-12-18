# statistical analysis of AB testing

# ----------- power analysis ------------- #
# find out sample size to detect an effect 
library(pwr)
library(powerMediation)
?pwr.t.test
# effect size is the difference divided by sd (pooled)


# common tests
# logistic reg: categorical (binary) response - clicked or not
# t test (linear reg): continuous response - time spent on website

?t.test
plot(extra ~ group, data = sleep)
t.test(extra ~ group, data = sleep)

# ----------- stopping rules ------------ #
# sequential analysis
# why? 1. prevent p-hacking 
# 2. unsure effect size 

install.packages('gsDesign')
library(gsDesign)
?gsDesign  # boundaries and trial size for a group sequential design 

seq_analysis <- gsDesign(k = 4,   # number of analyses planned 
                         test.type = 1, # one sided 
                         alpha = 0.05, 
                         beta = 0.2, 
                         sfu = 'Pocock')
seq_analysis


max_n <- 1000
max_n_per_group <- max_n/2
stopping_points <- max_n_per_group * seq_analysis$timing  # timing is 0.25, 0.5, 0.75, 1
# at any of this group, if significant, then stop collecting data
# not sure it would be helpful for our case


# ----------- multivariate testing ------------ #








