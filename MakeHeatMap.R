###MAKE HEATMAP DATA
##1. get some data from NBA.com (df_teamInfo: Team name, OFF DEF Rating, etc.)
source('nbaTeamGrabber.R')
##2. get Synergy data from NBA.com (df_list_PlayerOff or Def and df_list_TeamOff or Def)
source('SynergyGrabber.R')
##3. Can do more sorting stuff, right now it simply calculates PPP (in defTeamPPP and offTeamPPP, using the Synergy data) and makes sure that everything is sorted after team abbreviation names
source('addPPdata.R')
##4. grabs a csv with team or player Information and prepares the data for the heatmap
##heatmap data should be a matrix (or matrix-like data frame), for which the row and column names are used in the heatmap
source('prepareShotDataTeam.R')

##5. This is where the magic happens ;)
source('heatMap_SportsTributionTeam.R')

