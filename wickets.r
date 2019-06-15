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
bowldata = read.table("BowlingStatistics16.csv", header=T, sep=",")
str(bowldata)

#Re-arrange to construct classification tree. Runs is the target
bowlingdata = bowldata[,c(5,2,3,4,6,7,8)]
str(bowlingdata)


##############################
##### Regression  wickets ####
##############################

bowling = bowlingdata[,c(2,3,4,5,6,7)]
bowlingcor = cor(bowlingdata)

#Runsgiven, AVerage, Strike Rate and Economy are lessly correlated
plot(bowlingdata$Runs_Given, bowlingdata$Wickets)

#Stepwise Regression
model.null = lm(Wickets ~ 1, data=bowlingdata)
model.full = lm(Wickets ~ Runs_Given + Average + Strike_Rate + economy, data=bowlingdata)
step(model.null, scope = list(upper=model.full), direction="both", data=bowlingdata)

#Build Regression Model
wicketstaken1 = lm(Wickets ~ Runs_Given + Strike_Rate + economy, data = bowlingdata)
summary(wicketstaken1)

vif(wicketstaken1)
durbinWatsonTest(wicketstaken1)
plot(wicketstaken1)


##############################
##### Take 2017 data #########
##############################

bowl17 = read.table("BowlingStatistics17.csv", header=T, sep=",")
bowl17final = bowl17[,c(2,7,8)]

topbowler = predict(wicketstaken1, bowl17final, type="response")
head(order(-topbowler),10)
write.table(topbowler, file = "WicketsPredicted.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")
