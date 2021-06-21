# dir_background = directory in which "background.RData" is saved
# save_output = either NULL if not saved, or DIRECTORY where diagram needs to be saved
# language = "ENG" for english, "NL" for dutch
# contour = TRUE in contour lines (at phase transition)
# date range = (START DATE,END DATE) (use NA for start of end date if all data is to be used)
# pos.date = position of start and end date (1,2,3 or 4)
# extra.timepoint = additional dates to be added in diagram
# loc.timepoint = position of additional timepoints (needs to be of same length as extra.timepoint)
# pch.timepoint (optional) = point type of additional timepoints
# correction.weekend = TRUE if correction for weekend/holidays
# 
cliquet<-function(dir_background,save_output=NULL,
                  language="ENG",contour=TRUE, 
                  date_range=c("2020-09-20",NA),
                  pos.date=c(1,1),
                  extra.timepoint=NULL,loc.timepoint=NULL,pch.timepoint=NULL,
                  correction.weekend=FALSE){
  
  ## required packages
  library(ggplot2)
  library(zoo)
  library(fields)
  
  ## output
  if (length(save_output)>0){
    png(file = save_output, width = 1800, height = 1500, pointsize = 40)
  }
  
  par(mfrow=c(1,1))
  
  ## load background 
  load(paste0(dir_background,"background.RData",sep=""))
  
  ## plot background
  HOSP<-10^seq(0.9,3,0.0025)
  GR<-seq(0.85,1.25,0.0025)
  breaks<-c(0,50,303,528,987,1502,10^10)
  if (language=="NL"){
    image(log10(HOSP),GR,matrix(result[,3],nrow=length(HOSP),byrow=T),axes = F,
          col = hcl.colors(6, "Heat", rev = T),
          breaks=breaks,
          xlab="Nieuwe hospitalisaties",ylab="Groeisnelheid nieuwe hospitalisaties")
  }
  if (language=="ENG"){
    image(log10(HOSP),GR,matrix(result[,3],nrow=length(HOSP),byrow=T),axes = F,
          col = hcl.colors(6, "Heat", rev = T),
          breaks=breaks,
          xlab="New hospitalizations",ylab="New Hospitalizations daily growth")
  }
  
  xaxis_seq = c(0,10,20,40,75,150,300,600)
  yaxis_seq = c(0.9,1,1.025,1.050,1.1,1.2)
  axis(1, at = log10(xaxis_seq),labels=xaxis_seq,cex.axis=0.75)
  axis(2, at = c(0.9,0.95,1,1.050,1.1,1.15,1.2), labels = c("-10%","-5.0%","+0.0%","+5.0%","+10%","+15%","+20%"), las=1, cex.axis=0.75)
  segments(0,1,1000,1,lty="dashed",lwd=2)
  box()
  
  ## add contours
  if (contour==TRUE){
    if (language=="NL"){
      contour(log10(HOSP),GR,matrix(result[,3],nrow=length(HOSP),byrow=T),add=T,cex=1,col="black",
              levels=breaks,labels=c("0","50 ICU bedden","Fase 1A","Fase 1B",
                                     "Fase 2A","Fase 2B"),lwd=1.5)
    }
    if (language=="ENG"){
      contour(log10(HOSP),GR,matrix(result[,3],nrow=length(HOSP),byrow=T),add=T,cex=1,col="black",
              levels=breaks,labels=c("0","50 ICU beds","Phase 1A","Phase 1B",
                                     "Phase 2A","Phase 2B"),lwd=1.5)
    }
    
  }
  
  
  ## import hospitalization data
  dta <- read.csv("https://epistat.sciensano.be/Data/COVID19BE_HOSP.csv")
  
  
  ## aggregate new intakes
  dta_agg <- aggregate(NEW_IN ~ DATE, dta, sum)
  dta_agg2 <- aggregate(TOTAL_IN_ICU ~DATE, dta, sum)
  dta_agg<-merge(dta_agg,dta_agg2,by="DATE")
  dta_agg$DATE = as.character(dta_agg$DATE)
  
  N<-nrow(dta_agg)
  dta_agg$ICU_IN2WEEKS = NA
  dta_agg$ICU_IN2WEEKS[1:(N-14)] = dta_agg$TOTAL_IN_ICU[15:N]
  
  ## calculate moving averages
  dta_agg$new_in_mean <- rollmean(dta_agg$NEW_IN, 7, align = "right", fill = NA)
  
  ## calculate growth rate
  windows = 14  
  dta_agg$new_in_growth = rep(NA,nrow(dta_agg))
  
  for (i in windows:nrow(dta_agg)){
    temp_df = as.data.frame(cbind(0:(windows-1),dta_agg$NEW_IN[(i-windows+1):i]))
    names(temp_df)=c("day","new_in")
    dates<-dta_agg$DATE[(i-windows+1):i]
    if (correction.weekend == TRUE){
      temp_df$weekend<-as.numeric(weekdays(as.Date(dates)) %in% c("Monday","Sunday"))
      holidays<-c("2020-04-13","2020-05-01","2020-05-21","2020-07-21","2020-11-11","2020-12-25","2021-01-01","2021-04-05",
                  "2021-05-01","2021-05-13","2021-05-24","2021-07-21","2021-11-01","2021-11-11")
      temp_df$weekend[dates %in% holidays]<-1
      mylm = lm(log10(new_in) ~ day + weekend, temp_df)
    }
    else{
      mylm = lm(log10(new_in) ~ day, temp_df)
    }
    dta_agg$new_in_growth[i] = 10^coefficients(mylm)[[2]]
  }
  
  ## subset for period
  
  if (!is.na(date_range[1])){ dta_agg=subset(dta_agg,DATE>=as.Date(date_range[1]))}
  if (!is.na(date_range[2])){ dta_agg=subset(dta_agg,DATE<=as.Date(date_range[2]))}
  
  ## create the plot
  dta_agg_s = dta_agg[!is.na(dta_agg$new_in_growth),]
  dta_agg_s$nday = 1:(nrow(dta_agg_s))
  dta_agg_s$transparency = dta_agg_s$nday/nrow(dta_agg_s)/2+0.5
  dta_agg_s$size = dta_agg_s$TOTAL_IN_ICU/500
  xaxis_seq = c(12.5,25,50,100,200,400,600)
  yaxis_seq = seq(0.9,1.30,0.05)
  dta_agg_s$Weekday = as.numeric(weekdays(as.Date(dta_agg_s$DATE))=="Wednesday")
  
  
  # add the plot on top of decorations
  lines(log10(dta_agg_s$new_in_mean),dta_agg_s$new_in_growth, lty = 1, col = "darkblue", lwd = 2)
  points(log10(dta_agg_s$new_in_mean),dta_agg_s$new_in_growth,pch = 16, col = rgb(0.18,0,0.54, dta_agg_s$transparency), cex = 0.9)
  myWed = subset(dta_agg_s, Weekday == 1)
  points(log10(myWed$new_in_mean),myWed$new_in_growth,pch = 16, col = "darkred", cex = 0.9)
  
  # add text with dates
  txsize = 0.8
  points(log10(dta_agg_s$new_in_mean[1]),dta_agg_s$new_in_growth[1],pch=18,col="darkblue",cex=1.2)
  points(log10(dta_agg_s$new_in_mean[nrow(dta_agg_s)]),dta_agg_s$new_in_growth[nrow(dta_agg_s)],pch=18,col="darkblue",cex=1.2)
  points(log10(dta_agg_s$new_in_mean[1]),dta_agg_s$new_in_growth[1],pch=18,col="darkblue")
  points(log10(dta_agg_s$new_in_mean[nrow(dta_agg_s)]),dta_agg_s$new_in_growth[nrow(dta_agg_s)],pch=18,col="darkblue")
  
  text(log10(dta_agg_s$new_in_mean[1]),dta_agg_s$new_in_growth[1],format(as.Date(dta_agg_s$DATE[1]),"%d/%m"), pos = pos.date[1], cex = txsize, col="darkblue")
  text(log10(dta_agg_s$new_in_mean[nrow(dta_agg_s)]),dta_agg_s$new_in_growth[nrow(dta_agg_s)],format(as.Date(dta_agg_s$DATE[nrow(dta_agg_s)]),"%d/%m"), pos = pos.date[2], cex = txsize, col="darkblue")
  
  if (length(extra.timepoint)>0){
    for (i in 1:length(extra.timepoint)){
      text(log10(dta_agg_s$new_in_mean[dta_agg_s$DATE==extra.timepoint[i]]),dta_agg_s$new_in_growth[dta_agg_s$DATE==extra.timepoint[i]],format(as.Date(dta_agg_s$DATE[dta_agg_s$DATE==extra.timepoint[i]]),"%d/%m"), pos = loc.timepoint[i], cex = txsize, col="darkblue")
      if (length(pch.timepoint)==0){
        points(log10(dta_agg_s$new_in_mean[dta_agg_s$DATE==extra.timepoint[i]]),dta_agg_s$new_in_growth[dta_agg_s$DATE==extra.timepoint[i]],pch=18,col="darkblue")
      }
      if (length(pch.timepoint)>0){
        points(log10(dta_agg_s$new_in_mean[dta_agg_s$DATE==extra.timepoint[i]]),dta_agg_s$new_in_growth[dta_agg_s$DATE==extra.timepoint[i]],pch=pch.timepoint[i],col="darkblue",bg="darkblue")
      }
    }
  }
  
  
  if (length(save_output)>0){
    dev.off()
    
    tmp<-tail(dta_agg_s[c(1,2,3,5,6)],10)
    tmp[,4]<-round(tmp[,4],3)
    tmp[,5]<-round(tmp[,5],3)
    
    write.csv(tmp,paste0(substr(save_output, 1, nchar(save_output)-4),".csv"))
  }
  
  
}





