# data camp course on deep learning using keras
# 'RUN' is ctrl + R!!

import numpy as np

# the square bracket [] is the same as c() in r
input_data = np.array([2, 3]) # initial value for variable 1(number of children) 2(number account)

weights = {'node_0': np.array([1, 1]),
           'node_1': np.array([-1, 1]),
           'output': np.array([2, -1])}


''' identity activation function '''
node_0_value = (input_data * weights['node_0']).sum()  # both variable 1 and 2
node_1_value = (input_data * weights['node_1']).sum()


hidden_layer_values = np.array([node_0_value, node_1_value])
print(hidden_layer_values)  # 5, 1

# instead, use a tanh activation function on top of the .sum()

node_0_output = np.tanh(node_0_value)
node_1_output = np.tanh(node_1_value)
hidden_layer_values2 = np.array([node_0_output, node_1_output])
print(hidden_layer_values2)  # 0.99999, 0.7615


# compute output
output = (hidden_layer_values * weights['output']).sum()
output2 = (hidden_layer_values2 * weights['output']).sum()  # no activation function here
print(np.array([output, output2]))  # output from first is 9, from second is 1.238


''' ReLU '''

def relu(input):
    # Calculate the value for the output of the relu function: output
    output = max(input, 0)
    return (output)

print(np.array([relu(3), relu(-3)]))


def predict_with_network(input_data_row, weights):
    # Calculate node 0 value
    node_0_input = (input_data_row * weights['node_0']).sum()
    node_0_output = relu(node_0_input)

    # Calculate node 1 value
    node_1_input = (input_data_row * weights['node_1']).sum()
    node_1_output = relu(node_1_input)

    # Put node values into array: hidden_layer_outputs
    hidden_layer_outputs = np.array([node_0_output, node_1_output])

    # Calculate model output
    input_to_final_layer = (hidden_layer_outputs * weights['output']).sum()
    model_output = relu(input_to_final_layer)

    # Return model output
    return (model_output)


# Create empty list to store prediction results
results = []
for input_data_row in input_data:
    # Append prediction to results
    results.append(predict_with_network(input_data_row, weights))

# Print results
print(results)

