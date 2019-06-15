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
################################################################
#=================BAtting Statistics=====================#######
################################################################

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
da50=da50[(da50$Runs>=50) & (da50$Runs<=99),]
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


#Final 4 is the batsman statistics without average and strike rate

#################################
##### No of Innings #############
#################################

#Try to find the number of innings where people got to bat
inn1=aggregate(datafile$batsman, by=list(Category=datafile$match_id, Category=datafile$batsman), FUN=length)
names(inn1)<-c("Match_ID","Player_Name","No_of_balls1")
inn2=aggregate(datafile$non_striker, by=list(Category=datafile$match_id, Category=datafile$non_striker), FUN=length)
names(inn2)<-c("Match_ID","Player_Name","No_of_balls2")

#Total Number of Innings
tot <- merge(inn1,inn2, by=c("Player_Name","Match_ID"), all=TRUE)
tot[is.na(tot)] <- 0
innings_count = aggregate(tot$Match_ID, by=list(Category=tot$Player_Name), FUN=length)
names(innings_count) <- c("Player_Name","Total_Innings")

#################################
##### No of Notouts #############
#################################
not1 = aggregate(datafile$player_dismissed, by=list(Category=datafile$player_dismissed), FUN=length)
names(not1) <- c("Player_Name","No_of_times_dismisses")
inn_and_out <- merge(innings_count,not1, by=c("Player_Name"), all=TRUE)
inn_and_out[is.na(inn_and_out)] <- 0
names(inn_and_out) <- c("Player_Name","Total_Innings","No_of_outs")

#balls$actual <- with(balls, Balls_Faced-Extra_Balls_Faced)
inn_and_out$NO <- with(inn_and_out, Total_Innings-No_of_outs)
inn_and_out = inn_and_out[,-c(3)]

final5 = merge(inn_and_out, final4, by="Player_Name", all=TRUE)
final5[is.na(final5)] <-0




####################################################################################################

###############################
##### No of Balls #############
###############################

tot_balls = aggregate(datafile$batsman, by=list(Category=datafile$batsman), FUN=length)
names(tot_balls) <- c("Player_Name","Total_Balls")
wides = datafile[datafile$wide_runs>0,]
no_of_wides = aggregate(wides$wide_runs, by=list(Category=wides$batsman), FUN=length)
names(no_of_wides) <- c("Player_Name","Total_Wides")
ballsframe = merge(tot_balls, no_of_wides, by="Player_Name", all=TRUE)
ballsframe[is.na(ballsframe)] <- 0
ballsframe$Balls_Faced <- with(ballsframe, Total_Balls - Total_Wides)
ballsframe = ballsframe[,-c(2,3)]

final6 = merge(final5, ballsframe, by="Player_Name", all=TRUE)
final6[is.na(final6)] <-0 # All valid stats with unstructured column name

final7 = final6[,c(1,2,3,4,9,8,7,5,6)]

####################################################################################################

###############################
### Average and Strike Rate ###
###############################

final7$Average <- with(final7, Runs/(Total_Innings-NO))
final7$Strike_Rate <- with(final7, (Runs/Balls_Faced)*100)
final7[is.na(final7)] <-0


#ROund off Average ,and Strike Rate
final7$Strike_Rate <- round(final7$Strike_Rate,2)
final7$Average <- round(final7$Average,2)
final7 = final7[final7$Total_Innings!=0,]

#final7[which(!is.finite(final7))] <- 0
final7$Average <- ifelse(is.infinite((final7$Average)),final7$Runs,final7$Average)

#final4.to_csv(r'C:\\Users\\Hi\\Documents\\Project\\BattingStatistics.csv', sep=',', index=None)
write.table(final7, file = "BattingStatistics.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")