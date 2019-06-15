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

#Classifies only based on balls faced
battingtree = tree(battingdata)
battingtree
plot(battingtree)
text(battingtree)

#Try to Plot Runs vs Total_Innings

plot(battingdata$Balls_Faced, battingdata$Runs, pch=16)
abline(v=1090, lty=2)
lines(c(0,1090), c(177.20, 177.20))
lines(c(1090,max(battingdata$Runs)), c(2534,2534))

battingprunetree = prune.tree(battingtree)
battingprunetree

plot(battingprunetree)	


battingprunetree2 = prune.tree(battingtree, best=3)
battingprunetree2

plot(battingprunetree2)
text(battingprunetree2)


battingprunetree3 = prune.tree(battingtree, best=4)
battingprunetree3

plot(battingprunetree3)
text(battingprunetree3)

#Assess Correlation
battingcorr = cor(battingdata)
battingcorr

########################
##### 26 April #########
########################

testdata = battingdata[,-c(1)]
testdata1 = battingdata
mean(testdata$Runs)
#Mean Runs is 377.8
testdata$isfit <- ifelse(testdata$Runs>378, 1, 0)
testcorr = cor(testdata)
testcorr

################################
##### Different models #########
################################

#Strike Rate and Average
mylogit <- glm(isfit ~ Strike_Rate + Average, data = testdata, family = "binomial")
summary(mylogit)

#Average
mylogit <- glm(isfit ~ Average, data = testdata, family = "binomial")
summary(mylogit)


#Strike Rate and Average and NO
mylogit <- glm(isfit ~ NO + Strike_Rate + Average, data = testdata, family = "binomial")
summary(mylogit)

#Strike Rate and Average and NO
mylogit <- glm(isfit ~ Hundreds + NO + Strike_Rate + Average, data = testdata, family = "binomial")
summary(mylogit)

#Both of them significant. Fix with this model
mylogit <- glm(isfit ~ NO + Average, data = testdata, family = "binomial")
summary(mylogit)


#Both of them significant. Fix with this model
mylogit <- glm(isfit ~ Balls_Faced + NO + Average, data = testdata, family = "binomial")
summary(mylogit)

mylogit <- glm(isfit ~ Balls_Faced + Average, data = testdata, family = "binomial")
summary(mylogit)

vif(mylogit)
durbinWatsonTest(mylogit)
plot(mylogit)

##############################
##### Stepwise Regression ####
##############################

model.null = lm(testdata1$Runs ~ 1, data=testdata1)

model.full = lm(Runs ~ Total_Innings + Average + Strike_Rate + Hundreds + NO + Balls_Faced + Fours + Sixes + Fifties, data=testdata1)

step(model.null, scope = list(upper=model.full), direction="both", data=testdata1)

final = lm(testdata1$Runs ~ Balls_Faced + Sixes + Fours + NO + Fifties + Total_Innings + Strike_Rate, data = testdata1)

##############################
##### Take 2017 data #########
##############################

bat17 = read.table("BattingStatistics16.csv", header=T, sep=",")
bat17final = bat17[,c(4,2,3,5,8,9,10,11,6,7)]

bat17 = read.table("train.csv", header=T, sep=",")
bat17final = bat17[,c(4,2,3,5,8,9,10,11,6,7)]


topbatsman = predict(final, battingdata, type="response")
head(order(-topbatsman),10)


###############################
#Do Linear Regression for runs#
###############################

#ozone_reg = lm(ozone_data$ozone~ozone_data$rad+ozone_data$wind+ozone_data$temp)

Runsreg = lm(battingdata$Runs~battingdata$Balls_Faced + battingdata$Fours + battingdata$Sixes + battingdata$Fifties)
Runsreg = lm(battingdata$Runs~battingdata$Total_Innings + battingdata$Average + battingdata$Strike_Rate + battingdata$Hundreds)

Runsreg = lm(battingdata$Runs~battingdata$Total_Innings + battingdata$Average + battingdata$Strike_Rate + battingdata$Hundreds + battingdata$NO + battingdata$Balls_Faced + battingdata$Fours + battingdata$Sixes + battingdata$Fifties)


summary(Runsreg)

