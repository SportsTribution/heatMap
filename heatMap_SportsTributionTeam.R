#Heatmap
#partially 'stolen from http://sebastianraschka.com/Articles/heatmaps_in_r.html

#########################################################
### A) Installing and loading required packages
#########################################################

if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}
if (!require("cba")) {
  install.packages("cba", dependencies = TRUE)
}

SportsTributionHeatmap <- function (mat_data,y_data,title_name,y_name,key_name,save_name){

##make sure that it's a matrix and not a data frame
mat_data <- data.matrix(mat_data)

# creates a own color palette from darkred to darkgreen
my_palette <- colorRampPalette(c("darkred","red", "yellow", "green","darkgreen"))(n = 499)


##normalize mat_data
# mat_data <- (apply(mat_data, 2, function(x)(x-mean(x))/(sd(x))))
mat_data <- (apply(mat_data, 2, function(x)(x-mean(x))))

# ## find limit percentiles
quantBreaks=quantile(data.matrix(mat_data),c(0.02,0.25,0.5,0.8,0.9,0.98))
quantBreaks[2]=quantBreaks[1]+(quantBreaks[6]-quantBreaks[1])/6
quantBreaks[3]=quantBreaks[1]+(quantBreaks[6]-quantBreaks[1])/3
quantBreaks[4]=quantBreaks[6]-(quantBreaks[6]-quantBreaks[1])/3
quantBreaks[5]=quantBreaks[6]-(quantBreaks[6]-quantBreaks[1])/6

col_breaks = c(seq(quantBreaks[1],quantBreaks[2],length=100),              # for darkred
               seq(quantBreaks[2],quantBreaks[3],length=100),              # for red
               seq(quantBreaks[3],quantBreaks[4],length=100),              # for yellow
               seq(quantBreaks[4],quantBreaks[5],length=100),              # for green
               seq(quantBreaks[5],quantBreaks[6],length=100))              # for darkgreen

## map y_data to Palette
y_tmp <- ((y_data-mean(y_data))/(sd(y_data))+2)*125
y_tmp <- round(y_tmp)
y_tmp[y_tmp<1]=1
y_tmp[y_tmp>499]=499
y_tmp<-my_palette[y_tmp]

# creates a 5 x X inch image (X depends on the size of the matrix)
png(paste(save_name,".png"),    # create PNG for the heat map        
    width = 5*300,        # 5 x 300 pixels
    height = sqrt(dim(mat_data)[1]/30)*4.1*300,
    res = 300,            # 300 pixels per inch
    pointsize = 8)        # smaller font size


##optimal leave order (makes it look better)
d <- dist((mat_data))
hc <- hclust(d)
co <- order.optimal(d, hc$merge)
hc$order <- co$order
hc$merge <- co$merge
hc <- as.dendrogram(hc)
lwid = c(1.5,4)
lhei = c(1,sqrt(dim(mat_data)[1]/30)*4.2)

##heatmap.2
heatmap.2(mat_data,
          main = title_name, # heat map title
          Rowv=hc,
          Colv=FALSE,
          notecol="black",      # change font color of cell labels to black
          density.info="none",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          margins =c(12,11),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier 
          breaks=col_breaks,    # enable color transition at specified limits
          dendrogram="row",    # only draw a row dendrogram
          rowsep=1:dim(mat_data)[1],
          colsep=c(13),
          sepwidth = c(0.05,0.01),
          RowSideColors = y_tmp,
          key = TRUE,
          keysize = 1,
          lwid = lwid, lhei = lhei,
          key.xlab=key_name
          
)

mtext(c(y_name),side=2,line=-6.5,at=c(0))
dev.off()               # close the PNG device

}


## y_data has different possibilities eFG, OFF_RATING, PPP
# y_data <- df_teamInfo[[1]]$OFF_RATING[order(df_teamInfo[[1]]$TeamNameAbbreviation)]
y_data <- offTeamPPP

mat_data <- shotAttFTeamA
SportsTributionHeatmap(mat_data,y_data,'Offense: Frequency (shot clock <18)','PPP estimation','Shot Frequency','Output/ShotDistanceTeamOffFrequency2013-14')

mat_data <- shotAttFTeamM
SportsTributionHeatmap(mat_data,y_data,'Offense: Percentage (shot clock <18)','PPP estimation','Shooting Percentage','Output/ShotDistanceTeamOffPercentage2013-14')

mat_data <- shotAttFTeamD
SportsTributionHeatmap(mat_data,y_data,'Offense: Defender Dist (shot clock <18)','PPP estimation','Offender Distance (ft)','Output/ShotDistanceTeamOffDistance2013-14')

mat_data <- shotAttFTeamT
SportsTributionHeatmap(mat_data,y_data,'Offense: Time left (shot clock <18)','PPP estimation','Time left on Shot Clock (s)','Output/ShotDistanceTeamOffTime2013-14')


## other use for the Synergy data
# mat_data <- defTeamPPP
# y_data <- df_teamInfo[[1]]$DEF_RATING
# SportsTributionHeatmap(mat_data,y_data,'Playtype Defensive PPP','Def Rating','PPP Diff','Synergy_DefPPP')
# 
# mat_data <- offTeamPPP
# y_data <- df_teamInfo[[1]]$OFF_RATING
# SportsTributionHeatmap(mat_data,y_data,'Playtype Offensive PPP','Off Rating','PPP Diff','Synergy_OffPPP')
# 
# mat_data <- defTeamFreq
# y_data <- df_teamInfo[[1]]$DEF_RATING
# SportsTributionHeatmap(mat_data,y_data,'Playtype Defensive Frequency','Def Rating','Frequency Diff','Synergy_DefFreq')
# 
# mat_data <- offTeamFreq
# y_data <- df_teamInfo[[1]]$OFF_RATING
# SportsTributionHeatmap(mat_data,y_data,'Playtype Offensive Frequency','Off Rating','Frequency Diff','Synergy_OffFreq')
