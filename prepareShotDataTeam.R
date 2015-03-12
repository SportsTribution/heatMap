##grab the csv date identifies when it was scraped
shotDistanceTeamT <- read.delim("Input/teamDF2015-03-12.csv")

rownames(shotDistanceTeamT)<-shotDistanceTeamT$teamAbb
## You can filter after Offense defense season (2013-14 or 2014-15) or 2013 Playoffs
## Example: Filter for the Offensive information of the 2014-15 season
shotDistanceTeam=shotDistanceTeamT[grep("Off",shotDistanceTeamT$teamAbb,value=FALSE),]
shotDistanceTeam=shotDistanceTeam[grep("Regular",shotDistanceTeam$teamAbb,value=FALSE),]
shotDistanceTeam=shotDistanceTeam[grep("2014-15",shotDistanceTeam$teamAbb,value=FALSE),]

##Attemps for each Team (more interesting filter for players...)
nbAttempts=rowSums(shotDistanceTeam[,grep("A2_", colnames(shotDistanceTeam), value=TRUE)])+rowSums(shotDistanceTeam[,grep("A3_", colnames(shotDistanceTeam), value=TRUE)])
shotDistanceTeam=shotDistanceTeam[nbAttempts>0,]

## filter out seldomly used shot distances to reduce noise
shotDistanceTeam=shotDistanceTeam[,-grep("3_27",colnames(shotDistanceTeam),value=FALSE)]
shotDistanceTeam=shotDistanceTeam[,-grep("2_23",colnames(shotDistanceTeam),value=FALSE)]

#the csv saves time and distance as sum of all attempts. divide by nb attempts for avg time/distance
shotDistanceTeam[,grep("PTD",colnames(shotDistanceTeam),value=FALSE)]=shotDistanceTeam[,grep("PTD",colnames(shotDistanceTeam),value=FALSE)]/shotDistanceTeam[,grep("PTA",colnames(shotDistanceTeam),value=FALSE)]
shotDistanceTeam[,grep("PTT",colnames(shotDistanceTeam),value=FALSE)]=shotDistanceTeam[,grep("PTT",colnames(shotDistanceTeam),value=FALSE)]/shotDistanceTeam[,grep("PTA",colnames(shotDistanceTeam),value=FALSE)]

## calculate effective field goal percentage
eFGP=(rowSums(shotDistanceTeam[,grep("M2_", names(shotDistanceTeam), value=TRUE)])+1.5*rowSums(shotDistanceTeam[,grep("M3_", names(shotDistanceTeam), value=TRUE)]))/(rowSums(shotDistanceTeam[,grep("A2_", names(shotDistanceTeam), value=TRUE)])+rowSums(shotDistanceTeam[,grep("A3_", names(shotDistanceTeam), value=TRUE)]))

## shot distribution
shotAttFTeamA=shotDistanceTeam[,grep("PTA", names(shotDistanceTeam), value=TRUE)]
shotAttFTeamA=t(apply(shotAttFTeamA,1,function(x)(x/sum(x))))

## field goal percentage
shotAttFTeamM=shotDistanceTeam[,grep("PTM", names(shotDistanceTeam), value=TRUE)]/shotDistanceTeam[,grep("PTA", names(shotDistanceTeam), value=TRUE)]

## defender distance
shotAttFTeamD=shotDistanceTeam[,grep("PTD", names(shotDistanceTeam), value=TRUE)]

## time on shot clock
shotAttFTeamT=shotDistanceTeam[,grep("PTT", names(shotDistanceTeam), value=TRUE)]

## add names to the rows and columns of the matrices
colnames(shotAttFTeamA)<-grep("PTA",names(shotDistanceTeam),value=TRUE)
rownames(shotAttFTeamA)<-rownames(shotDistanceTeam)
colnames(shotAttFTeamM)<-grep("PTM",names(shotDistanceTeam),value=TRUE)
rownames(shotAttFTeamM)<-rownames(shotDistanceTeam)
colnames(shotAttFTeamD)<-grep("PTD",names(shotDistanceTeam),value=TRUE)
rownames(shotAttFTeamD)<-rownames(shotDistanceTeam)
colnames(shotAttFTeamT)<-grep("PTT",names(shotDistanceTeam),value=TRUE)
rownames(shotAttFTeamT)<-rownames(shotDistanceTeam)