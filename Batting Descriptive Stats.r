install.packages("psych")		#Perform descriptive statistics
install.packages("ggplot2")		#For advanced figures, plots, charts
install.packages("Hmisc")		#Provides correlation matrix with significance values
install.packages("RODBC")
library(foreign)
library(ggplot2)
library(psych)
library(plyr)
###################################################################################################################################
#Set Working Directory
setwd("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1")
#Get Working Directory
getwd()
######################################################### Reading Data##################################################################
# 1 Open File
finaldata = read.table("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1\\BattingStatistics.csv", header=T, sep=",")
str(finaldata)
########################################################################################################################################
#Data Conversion
finaldata$Player_Name=as.character(finaldata$Player_Name)
########################################################################################################################################
describe(finaldata[,-c(1)])
########################################################################################################################################
#Top 10 run getters in whole IPL
topruns = head(finaldata[order(finaldata$Runs, decreasing= T),], n = 10)
#Bring top 10 batsman with higher strike rate with minimum 1000 runs
minruns = finaldata[finaldata$Runs>=1000,]
topstr = head(minruns[order(minruns$Strike_Rate, decreasing= T),], n = 10)
topavg = head(minruns[order(minruns$Average, decreasing= T),], n = 10)
############################################################################################################################################
#Create the boxplots for Strike Rate and Average
boxplot(minruns$Strike_Rate, main='Strike Rate Batsman')
boxplot(minruns$Average, main='Average of Batsman')
############################################################################################################################################
#Create a histogram for the Average and Strike Rate
hist(minruns$Strike_Rate, main="Strike Rate")
hist(minruns$Average, main="Average")
############################################################################################################################################
concat1 <- rbind(topruns,topavg)
concat2 <- rbind(concat1,topstr)
#Find whose name has occurred more than once
names = aggregate(concat2$Player_Name, by=list(Category=concat2$Player_Name), FUN=length)
#ABD, Gayle, Warner, MS Dhoni, Raina, Kohli
#Final Top Batsman ka stats alone
topruns = topruns[-c(3,4,6,8),]
############################################################################################################################################
#Create Bar chart for the top 6 players
barplot(topruns$Fours,main="No of Fours", xlab=" Player Name", names.arg=c("SK Raina", "V Kohli", "DA Warner", "CH Gayle", "MS Dhoni", "AB de Villiers"))
barplot(topruns$Sixes,main="No of Sixes", xlab=" Player Name", names.arg=c("SK Raina", "V Kohli", "DA Warner", "CH Gayle", "MS Dhoni", "AB de Villiers"))
