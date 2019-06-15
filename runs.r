###########################################
#============Read in Libraries============#
###########################################

library(foreign)
library(psych)
library(ggplot2)
library(tree)
library(Hmisc)
library(car)

#######################################################
#=============Setup the Working Directory=============#
#######################################################

getwd()
workingdirectory = "C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1"
setwd(workingdirectory)


###########################################
#==============Read in data===============#
###########################################

#Read original CSV File
batdata = read.table("BattingStatistics16.csv", header=T, sep=",")
str(batdata)

#Re-arrange to construct classification tree. Runs is the target
battingdata = batdata[,c(4,2,3,5,8,9,10,11,6,7)]
str(battingdata)


##############################
##### Stepwise Regression ####
##############################

#Correlation
cor(battingdata)

#Build Stepwise Regression based on correlation assessment.
model.null = lm(Runs ~ 1, data=battingdata)
model.full = lm(Runs ~ Total_Innings + Average + Strike_Rate + Hundreds, data=battingdata)
step(model.null, scope = list(upper=model.full), direction="both", data=battingdata1)

#Multiple Regression based on Stepwise Regression
Runsreg = lm(Runs~ Total_Innings + Average + Strike_Rate + Hundreds, data = battingdata)
summary(Runsreg)

#Assessment
vif(Runsreg)
durbinWatsonTest(Runsreg)
plot(Runsreg)

plot(battingdata$Average, battingdata$Runs)
##############################
##### Take 2017 data #########
##############################

bat17 = read.table("BattingStatistics17.csv", header=T, sep=",")
bat17final = bat17[,c(4,2,3,5,8,9,10,11,6,7)]

bat17final2 = bat17[,c(2,10,11,6)]
topbatsman2 = predict(Runsreg, bat17final, type="response")
write.table(topbatsman2, file = "RunsPredicted.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")
head(order(-topbatsman2),10)



