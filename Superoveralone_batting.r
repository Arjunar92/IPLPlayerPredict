###################################################################################################################################
#Set Working Directory
setwd("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1")
#Get Working Directory
getwd()
######################################################### Reading Data##################################################################
# 1 Open File
datafile1 = read.table("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1\\deliveries.csv", header=T, sep=",")
# 2 Find out the Column
names(datafile)
# 3 Number of Columns
ncol(datafile)
# 4 Number of Rows
nrow(datafile)
# 5 Test if data columns are categorical
str(datafile)

datafile = datafile1[datafile1$is_super_over==1,]

###############################################################################
#=================BAtting Statistics====================================#######
##########################################################################33#


#Try to find batsman overall stats, verify in cricbuzz
Runs = aggregate(datafile$batsman_runs, by=list(Category=datafile$batsman), FUN=sum)
names(Runs) <- c("Player_Name","SRuns")

#Try to find number of 4s and 6s
da4 = datafile[datafile$batsman_runs==4,]
#aggregate(da4$batsman_runs/4, by=list(Category=da4$batsman), FUN=sum)
Fours = aggregate(da4$batsman_runs/4, by=list(Category=da4$batsman), FUN=sum)
names(Fours) <- c("Player_Name","SFours")

da6 = datafile[datafile$batsman_runs==6,]
Sixes = aggregate(da6$batsman_runs/6, by=list(Category=da6$batsman), FUN=sum)
names(Sixes) <- c("Player_Name","SSixes")

#Try to find unique players
Players = aggregate(datafile$batsman_runs, by=list(Category=datafile$batsman), FUN=sum)
Players <- Players[-c(2)]
names(Players)<-c("Player_Name")

#Try to Merge all dataframes into a single file
#final <- merge(Players, Runs, Fours, Sixes, Fifties, Hundreds, by="Player_Name")
final <- merge(Players, Runs, by="Player_Name", all=TRUE)
final1 <- merge(final, Fours, by="Player_Name", all=TRUE)
final2 <- merge(final1, Sixes, by="Player_Name", all=TRUE)

#tot[is.na(tot)] <- 0
final2[is.na(final2)] <-0

#final4.to_csv(r'C:\\Users\\Hi\\Documents\\Project\\BattingStatistics.csv', sep=',', index=None)
write.table(final2, file = "SuperBattingStatistics.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")
