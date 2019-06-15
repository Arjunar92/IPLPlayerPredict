###########################################
#============Read in Libraries============#
###########################################

library(foreign)
library(psych)
library(ggplot2)
library(tree)
library(Hmisc)
library("car")

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
bowldata = read.table("BowlingStatistics.csv", header=T, sep=",")
str(bowldata)

#Re-arrange to construct classification tree. Runs is the target
bowlingdata = bowldata[,c(5,4,2,3,8,6,7)]
str(bowlingdata)

#Classifies only based on balls faced
bowlingtree = tree(bowlingdata)
bowlingtree
plot(bowlingtree)
text(bowlingtree)

bowlingprunetree = prune.tree(bowlingtree)
bowlingprunetree

plot(bowlingprunetree)	


bowlingprunetree2 = prune.tree(bowlingtree, best=3)
bowlingprunetree2

plot(bowlingprunetree2)
text(bowlingprunetree2)


bowlingprunetree3 = prune.tree(bowlingtree, best=4)
bowlingprunetree3

plot(bowlingprunetree3)
text(bowlingprunetree3)

bowlingcorr = cor(bowlingdata)
bowlingcorr

##############################################################################################3
#Try to do logistic Regression
#df$patients <- ifelse(df$patients==150, 100, ifelse(df$patients==350, 300, NA))
testdata = bowlingdata
testdata$isfit <- ifelse(testdata$Total_Innings>22, 1, 0)
testdata$isfit <- ifelse(testdata$Wickets>19, 1, 0)
#All significant in predicting, VIF shows, DurbinWatsonTest not significant based on correlation analysis
testcorr = cor(testdata)
testcorr


mylogit <- glm(isfit ~ economy + Strike_Rate + Average, data = testdata, family = "binomial")
vif(mylogit)
durbinWatsonTest(mylogit)
plot(mylogit)

topbowler = predict(mylogit, testdata, type="response")
head(order(-topbowler),10)


mylogit <- glm(isfit ~ Wickets + economy + Strike_Rate + Average, data = testdata, family = "binomial")
vif(mylogit)
durbinWatsonTest(mylogit)
plot(mylogit)
