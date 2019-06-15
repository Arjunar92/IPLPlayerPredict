###################################################################################################################################
#Set Working Directory
setwd("C:\\Users\\divad\\Desktop\\project\\R nd python")
#Get Working Directory
getwd()
######################################################### Reading Data##################################################################
# 1 Open File
#Read deliveries
deliveries1 = read.table("C:\\Users\\divad\\Desktop\\project\\R nd python\\deliveries.csv", header=T, sep=",")
#Exclude super over
deliveries = deliveries1[deliveries1$is_super_over==0,]
ncol(deliveries)
nrow(deliveries)

#Wickets Taken

w1 = deliveries[deliveries$player_dismissed!="",]
w2 = w1[w1$dismissal!="run out"&w1$dismissal!="retired hurt"&w1$dismissal!="obstructing the field",]
wickets = aggregate(w2$player_dismissed, by=list(Category=w2$bowler, Category=w2$match_id), FUN = length)
names(wickets) <- c("Bowler","id","Wickets")

matchdata = read.csv("C:\\Users\\divad\\Desktop\\project\\R nd python\\matches.csv", header=T, sep=",")
needed = matchdata[,c(1,2)]
finaldata = merge(wickets,needed,by="id") 
finaldata$Bowler=as.character(finaldata$Bowler)

seasonwickets = aggregate(finaldata$Wickets, by=list(Category=finaldata$Bowler, Category=finaldata$season), FUN=sum)
names(seasonwickets) <- c("Player","Year","Wickets")
testone = seasonwickets[seasonwickets$Player=='AD Mascarenhas' | seasonwickets$Player=='DE Bollinger' | seasonwickets$Player=='Imran Tahir' | seasonwickets$Player=='MF Maharoof ' | seasonwickets$Player=='MR Marsh ' | seasonwickets$Player=='NM Coulter-Nile'| seasonwickets$Player=='Rashid Khan ' | seasonwickets$Player=='SL Malinga',]
######################################################### Try Scatterplot##################################################################
plot(testone$Year,testone$Wickets,xlab="Season",ylab="Wickets")
qplot(testone$Year,testone$Wickets)
qplot(testone$Year,testone$Wickets, color=testone$Player) #Perfect, make it a line graph
qplot(testone$Year,testone$Wickets, color=testone$Player, geom="line") #Perfect, make it a line graph
######################################################### Try Scatterplot##################################################################
