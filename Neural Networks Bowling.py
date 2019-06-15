# -*- coding: utf-8 -*-
"""
Created on Tue May  1 19:45:46 2018

@author: divad
"""

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

os.chdir('C:\\Users\\divad\\Desktop\\project\\R nd python')


#############################################
#===============Read in data================#
# Read in the data for both data sets.	    #
#############################################

#================
# 2016 data
#================
bowl16_data = pd.read_table('BowlingStatistics16.csv', sep=',')
bowl16_data.dtypes
bowl16_data.columns
bowl16_data = bowl16_data[['Runs_Given', 'Balls_Delivered', 'Total_Innings', 'Wickets','Average', 'Strike_Rate', 'economy']]

#================
# 2017 data
#================

bowl17_data = pd.read_table('BowlingStatistics17.csv', sep=',')
bowl17_data.dtypes
bowl17_data.columns
bowl17_data = bowl17_data[['Runs_Given', 'Balls_Delivered', 'Total_Innings', 'Wickets','Average', 'Strike_Rate', 'economy']]
bowl17_final = bowl17_data[['Balls_Delivered', 'Strike_Rate', 'economy']]

#=================================
# Multiple regression stepwise
#=================================

bowl16_data.corr()

#### A single correlation, with p-values
pearsonr(bowl16_data.Balls_Delivered, bowl16_data.Wickets)
pearsonr(bowl16_data.Strike_Rate, bowl16_data.Wickets)
pearsonr(bowl16_data.economy, bowl16_data.Wickets)

linreg1 = LinearRegression(fit_intercept=True)
linreg1.fit(bowl16_data[['Balls_Delivered', 'Strike_Rate', 'economy']],bowl16_data.Wickets)

#Calculate R-square
rsquare = linreg1.score(bowl16_data[['Balls_Delivered', 'Strike_Rate', 'economy']],bowl16_data.Wickets)

#Nicely formatted output
print('COEFFICIENTS\n',
      'Balls_Delivered: ', linreg1.coef_[0],
      '\nStrike_Rate: ', linreg1.coef_[1],
      '\neconomy: ', linreg1.coef_[2],
      '\ninterc: ', linreg1.intercept_,
      '\nR-Square: ', rsquare)

#Output coefficients in raw format
linreg1.coef_

#Output just the intercept
linreg1.intercept_

#Predict with Regression
linpred1 = linreg1.predict(bowl17_final)

metrics.mean_absolute_error(bowl17_data.Wickets, linpred1)

metrics.mean_squared_error(bowl17_data.Wickets, linpred1)

metrics.r2_score(bowl17_data.Wickets, linpred1)

#################################################
#==============Regression Analysis==============#
# Use a regression MLP on the 2017 bowling data.       #
#################################################

nnreg1 = MLPRegressor(activation='logistic', solver='sgd', 
                      hidden_layer_sizes=(20,20), 
                      early_stopping=True)
nnreg1.fit(bowl17_data, bowl17_data.Wickets)

nnpred1 = nnreg1.predict(bowl17_data)

nnreg1.n_layers_

nnreg1.coefs_

metrics.mean_absolute_error(bowl17_data.Wickets, nnpred1)

metrics.mean_squared_error(bowl17_data.Wickets, nnpred1)

metrics.r2_score(bowl17_data.Wickets, nnpred1)
#or use the following:
nnreg1.score(bowl17_data, bowl17_data.Wickets)

# 1(1,3),2(2,3)

