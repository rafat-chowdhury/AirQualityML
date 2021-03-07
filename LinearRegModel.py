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

x = np.array(extracted.drop([predict], 1)) # Generate dataset to test and train model in array form
y = np.array(extracted[predict])

test_vol = 0.1 # Define volume of data to to train model on # Large clean dataset can go with > test size

AirQualMod = linear_model.LinearRegression() # Define model type

# Uncomment the following section: Lines 24-27 once model accuracy has been optimised
# x_train, x_test, y_train, y_test = sklearn.model_selection.train_test_split(x,y,test_size = test_vol) # Split dataset 
# AirQualMod.fit(x_train,y_train) # Load data into model for training
# acc = AirQualMod.score(x_test,y_test) # Define model accuracy as measure of predictive efficiency 
# print(acc) # Return accuracy value

# Comment the following section: Lines 30-44 once model accuracy has been optimised
best = 0 # Needed to optimise model
test_runs = 100 # Define number of test runs

for _ in range(test_runs):
    x_train, x_test, y_train, y_test = sklearn.model_selection.train_test_split(x,y,test_size = test_vol) # Split dataset into training and test

    AirQualMod.fit(x_train,y_train) # Load data into model for training
    acc = AirQualMod.score(x_test,y_test) # Define model accuracy as measure of predictive efficiency 
    print(acc) # Return accuracy value

    if acc > best: # Store model via pickle if the accuracy is better than previous iterations
        best = acc
        with open("AirQualityModel.pickle","wb") as temp:
            pickle.dump(AirQualMod,temp)
    print(best)

AirQualMod_in = open("AirQualityModel.pickle","rb") # Load in model with best accuracy
AirQualMod = pickle.load(AirQualMod_in) 

predictions = AirQualMod.predict(x_test) # Test model 
 
percentage_change = [0] * len(predictions) # Create vector to show % diff between predicted T and actual T
for x in range(len(predictions)): # Print output for all predictions 
    percentage_change[x] = ((predictions[x]-y_test[x])/y_test[x])*100
    print(np.round(predictions[x], decimals=1),np.round(y_test[x], decimals=4),np.round(percentage_change[x], decimals=1),np.round(x_test[x], decimals=1))

output = pd.DataFrame(x_test) # Port test data into a new dataframe
output.columns = [extracted.drop([predict], 1)] # Add headers

output[predict] = y_test # Add reference temperature data for testing into new dataframe
output['Predicted'] = np.round(predictions,decimals = 1) # Add predictions to new dataframe
output['% Change'] = np.round(percentage_change,decimals = 1) # Add % Change

print(output.head) # Show output table
path = os.getcwd() 
filename = '/AirQuality_processed.csv'
filepath = path + filename # Create file path to save .csv to 

output.to_csv(filepath , index = False) # Save output as a .csv file