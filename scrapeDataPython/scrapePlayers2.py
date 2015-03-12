'''
Created on Feb 20, 2015

@author: jbecker
'''
import requests
import json
import pandas as pd
import time
import numpy as np

# General player Info
def find_player_info(player_id):
    player_url = 'http://stats.nba.com/stats/commonplayerinfo?LeagueID=00'+ \
        '&PlayerID='+str(player_id)+'&SeasonType=Regular+Season'
        
    # request the URL and parse the JSON
    response = requests.get(player_url)
    response.raise_for_status() # raise exception if invalid response
    data = json.loads(response.text)
    headers = data['resultSets'][0]['headers']
    player_data = data['resultSets'][0]['rowSet']
    dfTMP=pd.DataFrame(player_data,columns=headers)
    player_stats=dfTMP.xs(0)
    return player_stats;

# shooting distance stats
def find_stats(player_id,year_id):
    #NBA Stats API using selected player ID
    url = 'http://stats.nba.com/stats/playerdashptshotlog?'+ \
    'DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&' + \
    'Location=&Month=0&OpponentTeamID=0&Outcome=&Period=0&' + \
    'PlayerID='+str(player_id)+'&Season=20'+str(year_id)+'-'+str(year_id+1)+'&SeasonSegment=&' + \
    'SeasonType=Regular+Season&TeamID=0&VsConference=&VsDivision='
    
    #Create Dict based on JSON response
    response = requests.get(url)
    #shots = response.json()['resultSets'][0]['rowSet']
    data = json.loads(response.text)
    #Create df from data and find averages 
    headers = data['resultSets'][0]['headers']
    shot_data = data['resultSets'][0]['rowSet']
    shotMade=shotMadeTMP
    df = pd.DataFrame(shot_data,columns=headers)
    df['SHOT_DIST']=df['SHOT_DIST'].round()
    for i_dist in range (0,25):
        shotMade["PTM2_"+str(i_dist)]=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==2) & (df['FGM']==1))
        shotMade["PTA2_"+str(i_dist)]=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==2))
    for i_dist in range (22,39):
        shotMade["PTM3_"+str(i_dist)]=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==3) & (df['FGM']==1))
        shotMade["PTA3_"+str(i_dist)]=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==3))
    return shotMade;

def find_Teamstats(player_id,year_id,team_array):
    #NBA Stats API using selected player ID
    sType=["Regular+Season","Playoffs"]
    for k in range(0,2):
        try:
            url = 'http://stats.nba.com/stats/playerdashptshotlog?'+ \
            'DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&' + \
            'Location=&Month=0&OpponentTeamID=0&Outcome=&Period=0&' + \
            'PlayerID='+str(player_id)+'&Season=20'+str(year_id)+'-'+str(year_id+1)+'&SeasonSegment=&' + \
            'SeasonType='+sType[k]+'&TeamID=0&VsConference=&VsDivision='
             
            #Create Dict based on JSON response
            response = requests.get(url)
            #shots = response.json()['resultSets'][0]['rowSet']
            data = json.loads(response.text)
            #Create df from data and find averages 
            headers = data['resultSets'][0]['headers']
            shot_data = data['resultSets'][0]['rowSet']
            #print(shot_data)
            df = pd.DataFrame(shot_data,columns=headers)
            df = df[df['SHOT_CLOCK']<18]
            df['SHOT_DIST']=df['SHOT_DIST']/2
            df['SHOT_DIST']=np.ceil(df['SHOT_DIST'])
            df['SHOT_DIST']=df['SHOT_DIST']*2-1
        #     df['SHOT_DIST']=df['SHOT_DIST'].round()
        #     df.loc[df['CLOSE_DEF_DIST']>8,'CLOSE_DEF_DIST']=8
        #     test=df['MATCHUP'].str.split(' @ ').apply(Series, 1).stack()
            df['offAbb'] = [item.split(' ')[4] for item in df['MATCHUP']]
            df['defAbb'] = [item.split(' ')[6] for item in df['MATCHUP']]
            for iAbb in list(set(df['offAbb'])):
                tmpIndx=df['offAbb']==iAbb
                for i_dist in range (1,24,2):
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Off',"PTM2_"+str(i_dist)+"ft"]+=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==2) & (df['FGM']==1) & tmpIndx)
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Off',"PTA2_"+str(i_dist)+"ft"]+=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==2) & tmpIndx)
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Off',"PTD2_"+str(i_dist)+"ft"]+=sum(df['CLOSE_DEF_DIST'][(df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==2) & tmpIndx])
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Off',"PTT2_"+str(i_dist)+"ft"]+=sum(df['SHOT_CLOCK'][(df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==2)& (df['SHOT_CLOCK']<24) & tmpIndx])
                for i_dist in range (23,29,2):
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Off',"PTM3_"+str(i_dist)+"ft"]+=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==3) & (df['FGM']==1) & tmpIndx)
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Off',"PTA3_"+str(i_dist)+"ft"]+=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==3) & tmpIndx)
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Off',"PTD3_"+str(i_dist)+"ft"]+=sum(df['CLOSE_DEF_DIST'][(df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==3) & tmpIndx])
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Off',"PTT3_"+str(i_dist)+"ft"]+=sum(df['SHOT_CLOCK'][(df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==3) & (df['SHOT_CLOCK']<24) & tmpIndx])
              
            for iAbb in list(set(df['defAbb'])):
                tmpIndx=df['defAbb']==iAbb
                for i_dist in range (1,24,2):
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Def',"PTM2_"+str(i_dist)+"ft"]+=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==2) & (df['FGM']==1) & tmpIndx)
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Def',"PTA2_"+str(i_dist)+"ft"]+=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==2) & tmpIndx)
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Def',"PTD2_"+str(i_dist)+"ft"]+=sum(df['CLOSE_DEF_DIST'][(df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==2) & tmpIndx])
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Def',"PTT2_"+str(i_dist)+"ft"]+=sum(df['SHOT_CLOCK'][(df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==2) & (df['SHOT_CLOCK']<24) & tmpIndx])
                for i_dist in range (23,29,2):
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Def',"PTM3_"+str(i_dist)+"ft"]+=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==3) & (df['FGM']==1) & tmpIndx)
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Def',"PTA3_"+str(i_dist)+"ft"]+=sum((df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==3) & tmpIndx)
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Def',"PTD3_"+str(i_dist)+"ft"]+=sum(df['CLOSE_DEF_DIST'][(df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==3) & tmpIndx])
                    team_array.loc[iAbb+ '_20'+str(year_id)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' +'Def',"PTT3_"+str(i_dist)+"ft"]+=sum(df['SHOT_CLOCK'][(df['SHOT_DIST']==i_dist) & (df['PTS_TYPE']==3) & (df['SHOT_CLOCK']<24) & tmpIndx])
                    
        except:
            pass
             
    return team_array;
        

##NOTE: brute force player info takes quite long...
# #initialize player_info
# player_url = 'http://stats.nba.com/stats/commonplayerinfo?LeagueID=00'+ \
#     '&PlayerID=202066&SeasonType=Regular+Season'
# response = requests.get(player_url)
# response.raise_for_status() # raise exception if invalid response
# data = json.loads(response.text)
# headers = data['resultSets'][0]['headers']
# player_info=pd.DataFrame(columns=headers)    
#initialize distance info    

sdInfo=pd.read_csv('/home/jbecker/Documents/PythonData/shotDistance.csv',sep='\t')
M2PT = "PTM2_"
A2PT = "PTA2_"
Pts2M=["PTM2_"+str(i) for i in range(0,25)]
Pts2A=["PTA2_"+str(i) for i in range(0,25)]
Pts3M=["PTM3_"+str(i) for i in range(22,39)]
Pts3A=["PTA3_"+str(i) for i in range(22,39)]
shot_made_info=pd.DataFrame(columns=['PlayerID']+['Player Name']+['Season']+Pts2M+Pts2A+Pts3M+Pts3A)
shotMadeTMP=pd.DataFrame(index=['A'],columns=['PlayerID']+['Player Name']+['Season']+Pts2M+Pts2A+Pts3M+Pts3A)
for player_ID in set(sdInfo['PlayerID']):
    try:
        playerTMP=find_player_info(player_ID)
#         player_info = player_info.append(playerTMP)
        for year_ID in range(13,15):
            try:
                shotMadeTMP['Season']='20'+str(year_ID)+'-'+str(year_ID+1)
                shotMadeTMP['PlayerID']=player_ID
                shotMadeTMP['Player Name']=playerTMP['DISPLAY_FIRST_LAST']
                shot_made_info = shot_made_info.append(find_stats(player_ID,year_ID))
            except:
                pass
    except:
        pass
    print(player_ID)
# # player_info.to_csv('Input/playerInfo'+time.strftime("%Y-%m-%d")+'.csv', sep='\t')
shot_made_info.to_csv('/home/jbecker/Documents/shotMade'+time.strftime("%Y-%m-%d")+'.csv', sep='\t') 
 
## Initialization of team stats   
tAbb=["ATL", "BKN", "BOS", "CHA", "CHI", "CLE", "DAL", "DEN", "DET", "GSW", 
         "HOU", "IND", "LAC", "LAL", "MEM", "MIA", "MIL", "MIN", "NOP", "NYK", 
         "OKC", "ORL", "PHI", "PHX", "POR", "SAC", "SAS", "TOR", "UTA", "WAS"]

OffDef = ["Off","Def"]
SeasonType= ["Regular","Playoffs"]
tAbbAll=[tAbb[i] + '_20'+str(j)+'-'+str(j+1)+'_'+ SeasonType[k] +'_' + OffDef[l] for i in range(0,30) for j in range(13,15) for k in range(0,2) for l in range(0,2)]
print(tAbbAll)
 
Pts2M=["PTM2_"+str(i)+"ft" for i in range(1,24,2)]
Pts2A=["PTA2_"+str(i)+"ft" for i in range(1,24,2)]
Pts2D=["PTD2_"+str(i)+"ft" for i in range(1,24,2)]
Pts2T=["PTT2_"+str(i)+"ft" for i in range(1,24,2)]
Pts3M=["PTM3_"+str(i)+"ft" for i in range(23,29,2)]
Pts3A=["PTA3_"+str(i)+"ft" for i in range(23,29,2)]
Pts3D=["PTD3_"+str(i)+"ft" for i in range(23,29,2)]
Pts3T=["PTT3_"+str(i)+"ft" for i in range(23,29,2)]
teamDF=pd.DataFrame(0,columns=['teamAbb'] +Pts2M+Pts3M+Pts2A+Pts3A+Pts2D+Pts3D+Pts2T+Pts3T,index=tAbbAll)
teamDF['teamAbb']=tAbbAll

## scrape team info (could be combined with player Info
for playerID in sdInfo['PlayerID']:
    print(playerID)
    for j in range(13,15):
        try:
            teamDF=find_Teamstats(playerID, j, teamDF)
        except:
            pass
teamDF.to_csv('/home/jbecker/Documents/teamDF'+time.strftime("%Y-%m-%d")+'.csv', sep='\t')
