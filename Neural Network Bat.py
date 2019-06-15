#############################################
#=============Read in Libraries=============#
# Read in the necessary libraries.          #
#############################################

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

from sklearn import metrics
from scipy.stats.stats import pearsonr

#Neural Network
from sklearn.neural_network import MLPRegressor
from sklearn.neural_network import MLPClassifier

from sklearn.model_selection import train_test_split
from sklearn import preprocessing

#Multiple Regression
from sklearn.linear_model import LinearRegression
import statsmodels.formula.api as smf


#####################################################
#============Setup the Working Directory============#
# Set the working directory to the project folder by#
# running the appropriate code below.               #
#####################################################

os.chdir('C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1')


#############################################
#===============Read in data================#
# Read in the data for both data sets.	    #
#############################################

#================
# 2016 data
#================
bat16_data = pd.read_table('BattingStatistics16.csv', sep=',')
bat16_data.dtypes
bat16_data.columns
bat16_data = bat16_data[['Runs', 'Total_Innings', 'NO', 'Balls_Faced', 'Hundreds', 'Fifties', 'Fours', 'Sixes', 'Average', 'Strike_Rate']]

bat17_data = pd.read_table('BattingStatistics17.csv', sep=',')
bat17_data.dtypes
bat17_data.columns
bat17_data = bat17_data[['Runs', 'Total_Innings', 'NO', 'Balls_Faced', 'Hundreds', 'Fifties', 'Fours', 'Sixes', 'Average', 'Strike_Rate']]
bat17_final = bat17_data[['Hundreds', 'Strike_Rate', 'Average', 'Total_Innings']]



# Standardize the scaling of the variables by
# computing the mean and std to be used for later scaling.
scaler = preprocessing.StandardScaler()
scaler.fit(bat16_data)

# Perform the standardization process
bat16_data = scaler.transform(bat16_data)
bat17_data = scaler.transform(bat17_data)

#################################################
#==============Regression Analysis==============#
# Use a regression MLP on the Ozone data.       #
#################################################

nnreg1 = MLPRegressor(activation='logistic', solver='sgd', 
                      hidden_layer_sizes=(20,20), 
                      early_stopping=True)
nnreg1.fit(bat16_data, bat16_data.Runs)

nnpred1 = nnreg1.predict(bat17_data)

nnreg1.n_layers_

nnreg1.coefs_

metrics.mean_absolute_error(bat17_data.Runs, nnpred1)

metrics.mean_squared_error(bat17_data.Runs, nnpred1)

metrics.r2_score(bat17_data.Runs, nnpred1)
#or use the following:
nnreg1.score(bat17_data, bat17_data.Runs)

# 1(1,3),2(2,3)

#=================================
# Multiple regression stepwise
#=================================

bat16_data.corr()

#### A single correlation, with p-values
pearsonr(bat16_data.Total_Innings, bat16_data.Runs)
pearsonr(bat16_data.Hundreds, bat16_data.Runs)
pearsonr(bat16_data.Strike_Rate, bat16_data.Runs)
pearsonr(bat16_data.Average, bat16_data.Runs)

linreg1 = LinearRegression(fit_intercept=True)
linreg1.fit(bat16_data[['Hundreds','Strike_Rate','Average','Total_Innings']],bat16_data.Runs)

#Calculate R-square
rsquare = linreg1.score(bat16_data[['Hundreds','Strike_Rate','Average', 'Total_Innings']],bat16_data.Runs)

#Nicely formatted output
print('COEFFICIENTS\n',
      'Hundreds: ', linreg1.coef_[0],
      '\nStrike_Rate: ', linreg1.coef_[1],
      '\nAverage: ', linreg1.coef_[2],
	  '\nTotal_Innings: ', linreg1.coef_[3],
      '\ninterc: ', linreg1.intercept_,
      '\nR-Square: ', rsquare)

#Output coefficients in raw format
linreg1.coef_

#Output just the intercept
linreg1.intercept_

#Predict with Regression
linpred1 = linreg1.predict(bat17_final)

metrics.mean_absolute_error(bat17_data.Runs, linpred1)

metrics.mean_squared_error(bat17_data.Runs, linpred1)

metrics.r2_score(bat17_data.Runs, linpred1)


#=================================
# Neural Network using rectified 
# linear unit function
#=================================
nnreg2 = MLPRegressor(activation='relu', solver='sgd', 
                      early_stopping=True)
nnreg2.fit(bat16_data, bat16_data.Runs)

nnpred2 = nnreg2.predict(bat17_data)

metrics.mean_absolute_error(bat17_data.Runs, nnpred2)

metrics.mean_squared_error(bat17_data.Runs, nnpred2)

metrics.r2_score(bat17_data.Runs, nnpred2)
