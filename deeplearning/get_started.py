import pickle, gzip, numpy

f = gzip.open('mnist.pkl', 'rb')
train_set, valid_set, test_set = pickle.load(f)
f.close()

# ok I can t even load the dataset.... how upsetting