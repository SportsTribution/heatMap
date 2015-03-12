# list of addresses for raw data.
teamInfo = "http://stats.nba.com/stats/leaguedashteamstats?DateFrom=&DateTo=&GameScope=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Advanced&Month=0&OpponentTeamID=0&Outcome=&PaceAdjust=N&PerMode=Totals&Period=0&PlayerExperience=&PlayerPosition=&PlusMinus=N&Rank=N&Season=2014-15&SeasonSegment=&SeasonType=Regular+Season&StarterBench=&VsConference=&VsDivision="
# function that grabs the data from the website and converts to R data frame
readItTeam <- function(address) {
  web_page <- readLines(address)
  
  ## regex to strip javascript bits and convert raw to csv format
  web_page <- web_page[sapply(web_page, nchar) > 0]
  web_page <- paste(web_page,",")
  x1 <- gsub("[\\{\\}\\]]", "", web_page, perl = TRUE)
  x2 <- gsub("[\\[]", "\n", x1, perl = TRUE)
  x3 <- gsub("\"rowSet\":\n", "", x2, perl = TRUE)
  x4 <- gsub(";", ",", x3, perl = TRUE)
  x4 <- gsub(",\"name\":\"Offensive\"","", x4, perl = TRUE)
  # read the resulting csv with read.table()
  nba <- read.table(textConnection(x4), header = T, sep = ",", skip = 2, stringsAsFactors = FALSE)
  return(nba)
}

df_teamInfo <- lapply(teamInfo, readItTeam)
