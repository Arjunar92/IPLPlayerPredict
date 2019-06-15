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
batdata = read.table("BattingStatistics.csv", header=T, sep=",")
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

##############################################################################################3
#Try to do logistic Regression
#df$patients <- ifelse(df$patients==150, 100, ifelse(df$patients==350, 300, NA))
testdata = battingdata
testdata$isfit <- ifelse(testdata$Total_Innings>21, 1, 0)

testdata$isfit <- ifelse(testdata$Runs>395, 1, 0)

#All significant in predicting, VIF shows, DurbinWatsonTest not significant based on correlation analysis
testcorr = cor(testdata)
testcorr
#mylogit <- glm(isfit ~ Hundreds + Strike_Rate + Average, data = testdata, family = "binomial")

mylogit <- glm(isfit ~ Runs + Strike_Rate + Average, data = testdata, family = "binomial")
mylogit <- glm(isfit ~ Runs + Strike_Rate + Average, data = testdata, family = "binomial")

vif(mylogit)
durbinWatsonTest(mylogit)
plot(mylogit)
topbatsman = predict(mylogit, testdata, type="response")
head(order(-topbatsman),10)

#Lowest AIC so far but VIF shows multicollinearity
mylogit <- glm(isfit ~ Balls_Faced + Runs + Average + Strike_Rate, data = testdata, family = "binomial")
summary(mylogit)

####################################################################################################################
#None of the below things work


#Either this
testdata$isfit <- ifelse(testdata$Runs>396, 1, 0)
#or this -> Makes a significant model
testdata$isfit <- ifelse(testdata$Total_Innings>21, 1, 0)
testdata1=testdata

testdata$isfit<-factor(testdata$isfit)

#mylogit <- glm(admit ~ gre + gpa + rank, data = mydata, family = "binomial")
#Below is significant
mylogit <- glm(isfit ~ Runs + Average + Strike_Rate, data = testdata, family = "binomial")
#None of it is significant
mylogit <- glm(isfit ~ Total_Innings + NO + Runs + Balls_Faced + Hundreds + Fifties + Fours + Sixes + Average + Strike_Rate, data = testdata, family = "binomial")

#Try different
mylogit <- glm(isfit ~ Runs + Average + Strike_Rate, data = testdata, family = binomial(link="logit"))
#None of it is significant
mylogit <- glm(isfit ~ Total_Innings + NO + Runs + Balls_Faced + Hundreds + Fifties + Fours + Sixes + Average + Strike_Rate, data = testdata, family = binomial("logit"))



#Try different
mylogit.null <- glm(isfit ~ 1, data = testdata, family = binomial(link="logit"))
#None of it is significant
mylogit.full <- glm(isfit ~ Total_Innings + NO + Runs + Balls_Faced + Hundreds + Fifties + Fours + Sixes + Average + Strike_Rate, data = testdata, family = binomial("logit"))





#step(model.null, scope = list(upper=model.full), direction="both", test="Chisq", data=Data)
step(mylogit.null, scope = list(upper=mylogit.full), direction="both", test="Chisq", data=testdata)

#########################################################################################################################

			 
			 