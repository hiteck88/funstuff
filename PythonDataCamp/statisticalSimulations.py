''' =============== simulations =============== '''

import numpy as np

'''generate random numbers 
inputs: a = int, generate like np.arange(a)
        a = array, generate one from the array 

        size: int, default is None (then a single value)
        replace = True
        p: probability associated with each entry in a 
'''

np.random.choice(a = 3)  # generate like np.arange(3), i.e. from 0 to 2
np.random.choice(a = np.array([1, 3, 5, 7, 9]), size = 20)



''' ------------- generate from probability distribution -------------- '''
np.random.seed(123)
lam, size_1, size_2 = 5, 3, 1000

# Draw samples & calculate absolute difference between lambda and sample mean
samples_1 = np.random.poisson(lam, size_1)
samples_2 = np.random.poisson(lam, size_2)
answer_1 = abs(samples_1.mean())
answer_2 = abs(samples_2.mean())


''' --------------- random shuffle ------------ '''

# first try to create a list of tuples of poker cards
# looks like this: [('Heart', 0), ... ('Diamond', 12)]

a = [['Heart'] * 13, ['Club'] * 13, ['Spade'] * 13, ['Diamond'] * 13]
cardnames = np.hstack(a)
b = np.arange(13)
cardpoints = np.hstack(np.repeat(b[np.newaxis,...], 4, axis=0))

deck_of_cards = list(zip(cardnames, cardpoints))

np.random.shuffle(deck_of_cards)

# Print out the top three cards
card_choices_after_shuffle = deck_of_cards[0:3]
print(card_choices_after_shuffle)
# note that the originals will be shuffled


''' --------------- throw a die ------------ '''

# Define die outcomes and probabilities
die, probabilities, throws = [1, 2, 3, 4, 5, 6], [1/6, 1/6, 1/6, 1/6, 1/6, 1/6], 1

# Use np.random.choice to throw the die once and record the outcome
outcome = np.random.choice(die, size=1, p=probabilities)
print("Outcome of the throw: {}".format(outcome[0]))



''' =============== resampling ============= '''
# Set up the bowl
success_rep, success_no_rep, sims = 0, 0, 10000
bowl = ['b', 'b', 'b', 'g', 'g', 'y', 'y', 'y', 'y', 'y']

for i in range(sims):
    # Sample with and without replacement & increment success counters
    sample_rep = np.random.choice(bowl, size = 3, replace=True)
    sample_no_rep = np.random.choice(bowl, size = 3, replace=False)
    if (sample_rep[0] == 'b') & (sample_rep[1] == 'g') & (sample_rep[2] == 'y'):
        success_rep += 1
    if (sample_no_rep[0] == 'b') & (sample_no_rep[1] == 'g') & (sample_no_rep[2] == 'y'):
        success_no_rep += 1

# Calculate probabilities
prob_with_replacement = success_rep/sims
prob_without_replacement = success_no_rep/sims
print("Probability with replacement = {}, without replacement = {}".format(prob_with_replacement, prob_without_replacement))



''' =============== bootstrap ================= 
note the placeholder and the .append
'''


# Draw some random sample with replacement and append mean to mean_lengths.
mean_lengths, sims = [], 1000
for i in range(sims):
    temp_sample = np.random.choice(wrench_lengths, replace=True, size=len(wrench_lengths))
    sample_mean = temp_sample.mean()
    mean_lengths.append(sample_mean)

# Calculate bootstrapped mean and 95% confidence interval.
boot_mean = np.mean(mean_lengths)
boot_95_ci = np.percentile(mean_lengths, [2.5, 97.5])
print("Bootstrapped Mean Length = {}, 95% CI = {}".format(boot_mean, boot_95_ci))


''' ------------ bootstrap for dataframe -------------- '''
### use df.sample, not np.random.choice



# Sample with replacement and calculate quantities of interest
sims, data_size, height_medians, hw_corr = 1000, df.shape[0], [], []


# df.weights.corr(df.heights)

for i in range(sims):
    tmp_df = df.sample(n=data_size, replace=True)
    height_medians.append(tmp_df.heights.median())
    hw_corr.append(tmp_df.weights.corr(tmp_df.heights))

# Calculate confidence intervals
height_median_ci = np.percentile(height_medians, [2.5, 97.5])
height_weight_corr_ci = np.percentile(hw_corr, [2.5, 97.5])
print("Height Median CI = {} \nHeight Weight Correlation CI = {}".format( height_median_ci, height_weight_corr_ci))

''' -------------- jackknife -------------- '''

# Leave one observation out from wrench_lengths to get the jackknife sample and store the mean length
mean_lengths, n = [], len(wrench_lengths)
index = np.arange(n)

for i in range(n):
    jk_sample = wrench_lengths[index != i]   ##### this is the core of jackknife
    mean_lengths.append(jk_sample.mean())

# The jackknife estimate is the mean of the mean lengths from each sample
mean_lengths_jk = np.mean(np.array(mean_lengths))
print("Jackknife estimate of the mean = {}".format(mean_lengths_jk))


''' -------------- permutation test -------------- '''
#### seems to be a good way to compute p value
#### the distribution of test statistic T under H0 is obtained by calculating all possible values of T, under
#### re-arrangements of the labels

a = np.array([1, 2, 3])
b = np.array([4, 5, 6])
np.concatenate([a, b])  # equivalent to np.r_[a, b]

np.random.permutation(10)     # does permutation here mean sample without replacement?

# Generate permutations equal to the number of repetitions
perm = np.array([np.random.permutation(len(donations_A) + len(donations_B)) for i in range(reps)])
permuted_A_datasets = data[perm[:, :len(donations_A)]]
permuted_B_datasets = data[perm[:, len(donations_A):]]

# np.mean(permuted_A_datasets, axis = 1).shape
# Calculate the difference in means for each of the datasets
samples = np.mean(permuted_A_datasets, axis = 1) - np.mean(permuted_B_datasets, axis = 1)

# Calculate the test statistic and p-value
test_stat = np.mean(donations_A) - np.mean(donations_B)
p_val = 2*np.sum(samples >= np.abs(test_stat))/reps
print("p-value = {}".format(p_val))