## function that combines first and last name of a player Chosen name was useful for another function

# ## not needed at the moment
# combineNames <- function(playType) {
#   playType$ChosenName <- paste(playType$PlayerFirstName,y=playType$PlayerLastName, sep = " ")
#   return(playType)
# }
# 
# TeamNames <- function(playType) {
#   playType$ChosenName <- playType$TeamNameAbbreviation
#   return(playType)
# }
# 
# possToPerc <- function(playType) {
#   playType$eFG <- playType$PPP/2
#   playType$eFGM <- playType$PPP*playType$Poss/2
#   return(playType)
# }
# 
# sortTeams <- function(playType) {
#   playType <- playType[order(playType$TeamName),]
#   return(playType)
# }
# 
# makeFreq <- function(playType) {
#   freqPT <- playType$Time
#   return(freqPT)
# }
# 
# makePPP <- function(playType) {
#   freqPT <- playType$PPP
#   return(freqPT)
# }
# makeNormInfoMatrix <- function(df,rowN,colN){
#   tmpMat <- matrix(unlist(df), nrow = length(df), byrow = TRUE)
#   colnames(tmpMat) <- colN
#   rownames(tmpMat) <- rowN
#   #tmpMat <- (apply(tmpMat, 1, function(x)(x-mean(x))/(sd(x))))
#   tmpMat<-t(tmpMat)
#   return(tmpMat)
# }


sortTeams2 <- function(playType) {
  playType <- playType[order(playType$TeamNameAbbreviation),]
  return(playType)
}



sumPoints <- function(playType) {
  freqPT <- playType$Points
  return(freqPT)
}
sumPoss <- function(playType) {
  freqPT <- playType$Poss
  return(freqPT)
}


allPPP <- function(df){
  tmpMat <- matrix(unlist(df), nrow = length(df), byrow = TRUE)
  return(tmpMat)
}

# df_list_PlayerOff <- lapply(df_list_PlayerOff, combineNames)
# df_list_PlayerOff <- lapply(df_list_PlayerOff, possToPerc)
# df_list_PlayerDef <- lapply(df_list_PlayerDef, combineNames)
# df_list_PlayerDef <- lapply(df_list_PlayerDef, possToPerc)
# 
# df_list_TeamOff <- lapply(df_list_TeamOff, possToPerc)
# df_list_TeamOff <- lapply(df_list_TeamOff, TeamNames)
# df_list_TeamOff <- lapply(df_list_TeamOff, sortTeams)
# df_list_TeamDef <- lapply(df_list_TeamDef, possToPerc)
# df_list_TeamDef <- lapply(df_list_TeamDef, TeamNames)
# df_list_TeamDef <- lapply(df_list_TeamDef, sortTeams)


# dfTeamI<-lapply(df_list_TeamDef,makeFreq)
# defTeamFreq <- makeNormInfoMatrix(dfTeamI,names(dfTeamI),df_list_TeamDef$Team_Def_Transition$TeamNameAbbreviation)
# dfTeamI<-lapply(df_list_TeamDef,makePPP)
# defTeamPPP <- makeNormInfoMatrix(dfTeamI,names(dfTeamI),df_list_TeamDef$Team_Def_Transition$TeamNameAbbreviation)
# dfTeamI<-lapply(df_list_TeamOff,makeFreq)
# offTeamFreq <- makeNormInfoMatrix(dfTeamI,names(dfTeamI),df_list_TeamDef$Team_Def_Transition$TeamNameAbbreviation)
# dfTeamI<-lapply(df_list_TeamOff,makePPP)
# offTeamPPP <- makeNormInfoMatrix(dfTeamI,names(dfTeamI),df_list_TeamDef$Team_Def_Transition$TeamNameAbbreviation)


df_list_TeamOff <- lapply(df_list_TeamOff, sortTeams2)
df_list_TeamDef <- lapply(df_list_TeamDef, sortTeams2)
defTeamIPoints<-lapply(df_list_TeamDef,sumPoints)
defTeamIPoss<-lapply(df_list_TeamDef,sumPoss)
defTeamPPP <- colSums(allPPP(defTeamIPoints))/colSums(allPPP(defTeamIPoss))
offTeamIPoints<-lapply(df_list_TeamOff,sumPoints)
offTeamIPoss<-lapply(df_list_TeamOff,sumPoss)
offTeamPPP <- colSums(allPPP(offTeamIPoints))/colSums(allPPP(offTeamIPoss))