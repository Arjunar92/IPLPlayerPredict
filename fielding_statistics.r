###################################################################################################################################
#Set Working Directory
setwd("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1")
#Get Working Directory
getwd()
######################################################### Reading Data##################################################################
# 1 Open File
datafile1 = read.table("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1\\deliveries.csv", header=T, sep=",")
datafile = datafile1[datafile1$is_super_over==0,]
# 2 Find out the Column
names(datafile)
# 3 Number of Columns
ncol(datafile)
# 4 Number of Rows
nrow(datafile)
# 5 Test if data columns are categorical
str(datafile)
###########################################################################
#=================Fielding Statistics====================================##
###########################################################################

#What are the kind of dismissals that has happend?
unique(datafile$dismissal_kind)

dismissals1 = datafile[!(is.na(datafile$dismissal_kind) | datafile$dismissal_kind==""), ]
dismissals2 <- dismissals1[,-(3:6)]
dismissals3 <- dismissals2[,-(6:14)]

fielding=aggregate(dismissals3$fielder, by=list(Category=dismissals3$fielder, Category=dismissals3$dismissal_kind), FUN=length)
names(fielding) <- c("Player_Name","Dismissal","Number")

#[1] caught                bowled                run out               lbw                   caught and bowled     stumped               retired hurt         
#[8] hit wicket            obstructing the field

#Catches
catches = fielding[fielding$Dismissal=='caught',]
catches <- catches[,-2]
names(catches) <- c("Player_Name","Catches")

#Runouts
runout = fielding[fielding$Dismissal=='run out',]
runout <- runout[,-2]
names(runout) <- c("Player_Name","Run Outs")

#Stumped
stumped = fielding[fielding$Dismissal=='stumped',]
stumped <- stumped[,-2]
names(stumped) <- c("Player_Name","Stumped")

#Caught and Bowled
cnb = dismissals2[dismissals2$dismissal_kind=='caught and bowled',]
cnb <- cnb[,-(6:14)]
cnb <- cnb[,-(1:4)]
cnb <- cnb[,-4]
cnb2=aggregate(cnb$bowler, by=list(Category=cnb$bowler, Category=cnb$dismissal_kind), FUN=length)
cnb2 <- cnb2[,-2]
names(cnb2) <- c("Player_Name","Caught_and_Bowled")


final <- merge(catches, runout, by="Player_Name", all=TRUE)
final1 <- merge(final, stumped, by="Player_Name", all=TRUE)
final2 <- merge(final1, cnb2, by="Player_Name", all=TRUE)

final2[is.na(final2)] <- 0

final2$Actual_Catches <- with(final2, Catches+Caught_and_Bowled)

final2 = final2[,-c(2,5)]
names(final2) <- c("Player_Name","Run_Outs","Stumped","Catches")

write.table(final2, file = "FieldingStatistics.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")