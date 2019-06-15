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
finaldata = read.table("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1\\FieldingStatistics.csv", header=T, sep=",")
str(finaldata)
########################################################################################################################################
#Data Conversion
finaldata$Player_Name=as.character(finaldata$Player_Name)
########################################################################################################################################
#Top 10 Catchers in whole IPL
topcatchers = head(finaldata[order(finaldata$Catches, decreasing= T),], n = 10)
#Top 10 Run Outs in whole IPL
toprunouts = head(finaldata[order(finaldata$Run_Outs, decreasing= T),], n = 10)
#Top 10 Stumped in whole IPL
topstumped = head(finaldata[order(finaldata$Stumped, decreasing= T),], n = 10)
########################################################################################################################################
#List of player common across all three sets with atleast 2 sets
concat1 <- rbind(topcatchers,toprunouts)
concat2 <- rbind(concat1,topstumped)
#Find whose name has occurred more than once
commonplayers = aggregate(concat2$Player_Name, by=list(Category=concat2$Player_Name), FUN=length)
names(commonplayers) <- c("Player_Name","Occurence")
commonplayers = commonplayers[commonplayers$Occurence>1,]
#Filter in the original dataset
concat2 = concat2[c(1,2,3,4,5,6,8,9,10),]
########################################################################################################################################
BAr chart for those
barplot(concat2$Catches,main="Highest Catches", xlab=" Player Name", names.arg=c("KD Karthik", "SK Raina", "AB de Villiers", "MS Dhoni", "RV Uthapa", "RG Sharma","NV Ojha","DJ Bravo","PA Patel"))
barplot(concat2$Run_Outs,main="Highest Run Outs", xlab=" Player Name", names.arg=c("KD Karthik", "SK Raina", "AB de Villiers", "MS Dhoni", "RV Uthapa", "RG Sharma","NV Ojha","DJ Bravo","PA Patel"))
barplot(concat2$Stumped,main="Highest Stumped", xlab=" Player Name", names.arg=c("KD Karthik", "SK Raina", "AB de Villiers", "MS Dhoni", "RV Uthapa", "RG Sharma","NV Ojha","DJ Bravo","PA Patel"))
