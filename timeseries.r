library(tseries)
library(forecast)
library(lmtest)

workingdirectory = "C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1"
setwd(workingdirectory)

warner_data = read.table('warner.csv', sep = ',', header = TRUE)
warner_ts = ts(warner_data$Runs, frequency = 1, start = 2009)