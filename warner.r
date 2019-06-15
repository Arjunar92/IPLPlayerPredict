###################################################################################################################################
#Set Working Directory
setwd("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1")
#Get Working Directory
getwd()
######################################################### Reading Data##################################################################
# 1 Open File
balldata = read.table("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1\\deliveries.csv", header=T, sep=",")
str(balldata)
balldata1 = balldata[balldata$is_super_over==0,]
matchbymatch = aggregate(balldata1$batsman_runs, by=list(Category=balldata1$batsman, Category=balldata1$match_id), FUN=sum)
names(matchbymatch) <- c("Player_Name","id","Runs")
matchdata = read.csv("C:\\Users\\Hi\\OneDrive - Oklahoma State University\\R and Python Project\\ds1\\matches.csv", header=T, sep=",")
needed = matchdata[,c(1,2)]
finaldata = merge(matchbymatch,needed,by="id") 
#finaldata$Player_Name=as.character(finaldata$Player_Name)

seasonruns = aggregate(finaldata$Runs, by=list(Category=finaldata$Player_Name, Category=finaldata$season), FUN=sum)
names(seasonruns) <- c("Player","Year","Runs")
top10 = seasonruns[seasonruns$Player=='DA Warner' | seasonruns$Player=='G Gambhir' | seasonruns$Player=='S Dhawan' | seasonruns$Player=='SP Narine' | seasonruns$Player=='SK Raina' | seasonruns$Player=='HM Amla' | seasonruns$Player=='KA Pollard' | seasonruns$Player=='RA Tripathi' | seasonruns$Player=='RV Uthappa' | seasonruns$Player=='SPD Smith',]
testone = seasonruns[seasonruns$Player=='MS Dhoni' | seasonruns$Player=='V Kohli' | seasonruns$Player=='SK Raina' | seasonruns$Player=='DA Warner' | seasonruns$Player=='CH Gayle' | seasonruns$Player=='AB de Villiers',]
######################################################### Try Scatterplot##################################################################
plot(top10$Year,top10$Runs,xlab="Season",ylab="Runs")
qplot(testone$Year,testone$Runs)
qplot(testone$Year,testone$Runs, color=testone$Player) #Perfect, make it a line graph
######################################################### Try Scatterplot##################################################################
qplot(top10$Year,top10$Runs, color=top10$Player, geom="line") #Perfect, make it a line graph
######################################################### Try Scatterplot##################################################################
warner = seasonruns[seasonruns$Player=='DA Warner',]
write.table(warner, file = "Warner.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")