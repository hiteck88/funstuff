InsectSprays

subdata <- InsectSprays[InsectSprays$spray %in% c('B', 'C'), ]
str(subdata)  # 24 observations
y <- subdata$count

group <- as.character(subdata$spray)
group
testStat <- function(w, g) mean(w[g == 'B']) - mean(w[g== 'C'])
observedStat <- testStat(y, group)
observedStat  # mean difference is 13.25


# labels are switched
# null hypo is that group label is unrelated to outcome
permutations <- sapply(1:10, function(i) testStat(y, sample(group)))
permutations

mean(permutations > observedStat)
# Pval is not exactly 0, because one permutation might give back original data

