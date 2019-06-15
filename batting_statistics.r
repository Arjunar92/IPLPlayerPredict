###################################################################################################################################
#Set Working Directory
setwd("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1")
#Get Working Directory
getwd()
######################################################### Reading Data##################################################################
# 1 Open File
datafile = read.table("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1\\deliveries.csv", header=T, sep=",")
# 2 Find out the Column
names(datafile)
# 3 Number of Columns
ncol(datafile)
# 4 Number of Rows
nrow(datafile)
# 5 Test if data columns are categorical
str(datafile)
###############################################################################
#=================BAtting Statistics====================================#######
##########################################################################33#


#Try to find batsman overall stats, verify in cricbuzz
Runs = aggregate(datafile$batsman_runs, by=list(Category=datafile$batsman), FUN=sum)
names(Runs) <- c("Player_Name","Runs")

#Try to find number of 4s and 6s
da4 = datafile[datafile$batsman_runs==4,]
#aggregate(da4$batsman_runs/4, by=list(Category=da4$batsman), FUN=sum)
Fours = aggregate(da4$batsman_runs/4, by=list(Category=da4$batsman), FUN=sum)
names(Fours) <- c("Player_Name","Fours")

da6 = datafile[datafile$batsman_runs==6,]
Sixes = aggregate(da6$batsman_runs/6, by=list(Category=da6$batsman), FUN=sum)
names(Sixes) <- c("Player_Name","Sixes")

#Try to find scores greater than 50
da50=aggregate(datafile$batsman_runs, by=list(Category=datafile$match_id, Category=datafile$batsman), FUN=sum)
names(da50) <- c("Match_ID","Player_Name","Runs")
da50=da50[da50$Runs>=50,]
Fifties = aggregate(da50$Runs, by=list(Category=da50$Player_Name), FUN=length)
names(Fifties) <- c("Player_Name","Fifties")


#Try to find scores greater than 100
da100=aggregate(datafile$batsman_runs, by=list(Category=datafile$match_id, Category=datafile$batsman), FUN=sum)
names(da100) <- c("Match_ID","Player_Name","Runs")
da100=da100[da100$Runs>=100,]
Hundreds = aggregate(da100$Runs, by=list(Category=da100$Player_Name), FUN=length)
names(Hundreds) <- c("Player_Name","Hundreds")

#Try to find unique players
Players = aggregate(datafile$batsman_runs, by=list(Category=datafile$batsman), FUN=sum)
Players <- Players[-c(2)]
names(Players)<-c("Player_Name")

#Try to Merge all dataframes into a single file
#final <- merge(Players, Runs, Fours, Sixes, Fifties, Hundreds, by="Player_Name")
final <- merge(Players, Runs, by="Player_Name", all=TRUE)
final1 <- merge(final, Fours, by="Player_Name", all=TRUE)
final2 <- merge(final1, Sixes, by="Player_Name", all=TRUE)
final3 <- merge(final2, Fifties, by="Player_Name", all=TRUE)
final4 <- merge(final3, Hundreds, by="Player_Name", all=TRUE)

#final4.to_csv(r'C:\\Users\\Hi\\Documents\\Project\\BattingStatistics.csv', sep=',', index=None)
write.table(final4, file = "BattingStatistics.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")

#Final 4 is the batsman statistics without average and strike rate

