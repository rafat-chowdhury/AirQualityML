import pandas as pd 
import numpy as np 
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

x_train, x_test, y_train, y_test = sklearn.model_selection.train_test_split(x,y,test_size = test_vol) # Split dataset 
AirQualMod.fit(x_train,y_train) # Load data into model for training
acc = AirQualMod.score(x_test,y_test) # Define model accuracy as measure of predictive efficiency 
print(acc) # Return accuracy value

predictions = AirQualMod.predict(x_test) # Test model 
 
percentage_change = [0] * len(predictions) # Create vector to show % diff between predicted T and actual T
for x in range(len(predictions)): # Print output for all predictions 
    percentage_change[x] = ((predictions[x]-y_test[x])/y_test[x])*100
    print(np.round(predictions[x]),np.round(y_test[x]),percentage_change[x],x_test[x])