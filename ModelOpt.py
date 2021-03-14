import pandas as pd 
import numpy as np 
import os
import sklearn
import pickle
from sklearn import linear_model
from sklearn.utils import shuffle

# Read in test data: AirQualityUCIUpdated.csv
data = pd.read_csv('AirQualityUCI.csv',sep=',',decimal= ',')
print(data.head()) # Print table header

extracted = data[["CO(GT)","PT08.S1(CO)","NMHC(GT)","C6H6(GT)","PT08.S1(CO)","RH","AH",'T']] # Define variables to extract

predict = "T" # Define parameter to model

labels = np.array(extracted.drop([predict], 1)) # Generate dataset to test and train model in array form
orig_data = np.array(extracted[predict])

test_vol = 0.1 # Define volume of data to to train model on # Large clean dataset can go with > test size

AirQualMod = linear_model.LinearRegression() # Define model type

# Comment the following section: Lines 30-44 once model accuracy has been optimised
best = 0 # Needed to optimise model
test_runs = 100 # Define number of test runs

for _ in range(test_runs):
    labels_train, labels_test, orig_data_train, orig_data_test = sklearn.model_selection.train_test_split(labels,orig_data,test_size = test_vol) # Split dataset into training and test

    AirQualMod.fit(labels_train,orig_data_train) # Load data into model for training
    acc = AirQualMod.score(labels_test,orig_data_test) # Define model accuracy as measure of predictive efficiency 
    print(acc) # Return accuracy value

    if acc > best: # Store model via pickle if the accuracy is better than previous iterations
        best = acc
        with open("AirQualityModel.pickle","wb") as temp:
            pickle.dump(AirQualMod,temp)
    print(best)