# list of addresses for raw data.
addressListPlayerOff <- list(Player_Off_Transition = "http://stats.nba.com/js/data/playtype/player_Transition.js", 
                             Player_Off_Cut = "http://stats.nba.com/js/data/playtype/player_Cut.js", 
                             Player_Off_PnR_Handler = "http://stats.nba.com/js/data/playtype/player_PRBallHandler.js", 
                             Player_Off_HandOff = "http://stats.nba.com/js/data/playtype/player_Handoff.js", 
                             Player_Off_Isolation = "http://stats.nba.com/js/data/playtype/player_Isolation.js", 
                             Player_Off_Misc = "http://stats.nba.com/js/data/playtype/player_Misc.js", 
                             Player_Off_OffScreen = "http://stats.nba.com/js/data/playtype/player_OffScreen.js", 
                             Player_Off_PostUp = "http://stats.nba.com/js/data/playtype/player_Postup.js", 
                             Player_Off_PutBack = "http://stats.nba.com/js/data/playtype/player_OffRebound.js",
                             Player_Off_PnR_Roller = "http://stats.nba.com/js/data/playtype/player_PRRollMan.js",
                             Player_Off_SpotUp = "http://stats.nba.com/js/data/playtype/player_Spotup.js")

addressListTeamOff <- list(
                             Team_Off_Transition = "http://stats.nba.com/js/data/playtype/team_Transition.js", 
                             Team_Off_Cut = "http://stats.nba.com/js/data/playtype/team_Cut.js", 
                             Team_Off_PnR_Handler = "http://stats.nba.com/js/data/playtype/team_PRBallHandler.js", 
                             Team_Off_HandOff = "http://stats.nba.com/js/data/playtype/team_Handoff.js", 
                             Team_Off_Isolation = "http://stats.nba.com/js/data/playtype/team_Isolation.js", 
                             Team_Off_Misc = "http://stats.nba.com/js/data/playtype/team_Misc.js", 
                             Team_Off_OffScreen = "http://stats.nba.com/js/data/playtype/team_OffScreen.js", 
                             Team_Off_PostUp = "http://stats.nba.com/js/data/playtype/team_Postup.js",                               Team_Off_PutBack = "http://stats.nba.com/js/data/playtype/team_OffRebound.js",
                             Team_Off_PnR_Roller = "http://stats.nba.com/js/data/playtype/team_PRRollMan.js",
                             Team_Off_SpotUp = "http://stats.nba.com/js/data/playtype/team_Spotup.js")

addressListPlayerDef <- list(Player_Def_PnR_Handler = "http://stats.nba.com/js/data/playtype/player_PRBallHandler.js", 
                             Player_Def_HandOff = "http://stats.nba.com/js/data/playtype/player_Handoff.js", 
                             Player_Def_Isolation = "http://stats.nba.com/js/data/playtype/player_Isolation.js", 
                             Player_Def_OffScreen = "http://stats.nba.com/js/data/playtype/player_OffScreen.js", 
                             Player_Def_PostUp = "http://stats.nba.com/js/data/playtype/player_Postup.js", 
                             Player_Off_PutBack = "http://stats.nba.com/js/data/playtype/player_OffRebound.js",
                             Player_Def_PnR_Roller = "http://stats.nba.com/js/data/playtype/player_PRRollMan.js",
                             Player_Def_SpotUp = "http://stats.nba.com/js/data/playtype/player_Spotup.js")

addressListTeamDef <- list(Team_Def_Transition = "http://stats.nba.com/js/data/playtype/team_Transition.js", 
                           Team_Def_Cut = "http://stats.nba.com/js/data/playtype/team_Cut.js", 
                           Team_Def_PnR_Handler = "http://stats.nba.com/js/data/playtype/team_PRBallHandler.js", 
                           Team_Def_HandOff = "http://stats.nba.com/js/data/playtype/team_Handoff.js",                             Team_Def_Isolation = "http://stats.nba.com/js/data/playtype/team_Isolation.js", 
                           Team_Def_Misc = "http://stats.nba.com/js/data/playtype/team_Misc.js", 
                           Team_Def_OffScreen = "http://stats.nba.com/js/data/playtype/team_OffScreen.js", 
                           Team_Def_PostUp = "http://stats.nba.com/js/data/playtype/team_Postup.js",                             Team_Def_PutBack = "http://stats.nba.com/js/data/playtype/team_OffRebound.js",
                           Team_Def_PnR_Roller = "http://stats.nba.com/js/data/playtype/team_PRRollMan.js",
                           Team_Def_SpotUp = "http://stats.nba.com/js/data/playtype/team_Spotup.js")

# function that grabs the data from the website and converts to R data frame
readItOff <- function(address) {
  web_page <- readLines(address)
  
  ## regex to strip javascript bits and convert raw to csv format
  web_page <- web_page[sapply(web_page, nchar) > 0]
  findDef <- gregexpr(pattern ='}',web_page)
  web_page <- strtrim(web_page,findDef[[1]][2]+2)
  x1 <- gsub("[\\{\\}\\]]", "", web_page, perl = TRUE)
  x2 <- gsub("[\\[]", "\n", x1, perl = TRUE)
  x3 <- gsub("\"rowSet\":\n", "", x2, perl = TRUE)
  x4 <- gsub(";", ",", x3, perl = TRUE)
  x4 <- gsub(",\"name\":\"Offensive\"","", x4, perl = TRUE)
  # read the resulting csv with read.table()
  nba <- read.table(textConnection(x4), header = T, sep = ",", skip = 2, stringsAsFactors = FALSE)
  return(nba)
}

readItDef <- function(address) {
  web_page <- readLines(address)
  print(address)
  ## regex to strip javascript bits and convert raw to csv format
  web_page <- web_page[sapply(web_page, nchar) > 0]
  findDef <- gregexpr(pattern ='}',web_page)
  web_page <- substr(web_page,findDef[[1]][2]+2,nchar(web_page, type = "chars", allowNA = FALSE))
  web_page <- paste(web_page,",")
  x1 <- gsub("[\\{\\}\\]]", "", web_page, perl = TRUE)
  x2 <- gsub("[\\[]", "\n", x1, perl = TRUE)
  x3 <- gsub("\"rowSet\":\n", "", x2, perl = TRUE)
  x4 <- gsub(";", ",", x3, perl = TRUE)
  x4 <- gsub(",\"name\":\"Defensive\"","", x4, perl = TRUE)
  x4 <- gsub(",\"name\":\"Deffensive\"","", x4, perl = TRUE)
  # read the resulting csv with read.table()
  nba <- read.table(textConnection(x4), header = T, sep = ",", skip = 1, stringsAsFactors = FALSE)
  return(nba)
}

df_list_PlayerOff <- lapply(addressListPlayerOff, readItOff)
df_list_TeamOff <- lapply(addressListTeamOff, readItOff)
df_list_TeamDef <- lapply(addressListTeamDef, readItDef)
df_list_PlayerDef <- lapply(addressListPlayerDef, readItDef)
