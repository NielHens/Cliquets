# MAKE CLIQUES PLOT

source("functions_cliquets.R")

###  TO MAKE BACKGROUND.RDATA

#dir_data = FILL IN
#dir_output = FILL IN

#calculate_net_ICU(dir_data,dir_output)

#### TO MAKE PLOT OF CLIQUES

## dir_backgroup: directory where background.RData is located
## save_output: if plot needs to be saved, link & name of plot (png) - otherwise NULL
## language: ENG, NL or FR (FR TO BE DONE)
## contour: TRUE or FALSE
## date_range: date range as vector (minimal date,maximial date); if no constraint put NA
## add.ICU: "ALL","Wednesday" or"NONE" to add "in 2 weeks ICU load" on all days, on wednesdays or not
## loc.timepoint: position of start and end date in the graph (1=below point, 2=left of point, 3=above point, 4=right of point)
## correction.weekend: TRUE to correct the growth rates for weekend effects (leads to smoother plot)

dir_background = dir

cliques(dir,save_output=NULL,
        language="ENG",contour=TRUE, 
        date_range=c("2020-09-01",NA),
        add.ICU=c("ALL","Wednesday","NONE")[3],
        extra.timepoint=c("2020-10-19","2020-11-02"),loc.timepoint=c(1,4),
        correction.weekend=TRUE)



save_output1 = paste(dir,"/Hospitalizations_period1.png",sep="")
save_output2 = paste(dir,"/Hospitalizations_period2.png",sep="")
save_output3 = paste(dir,"/Hospitalizations_period3.png",sep="")
save_output4 = paste(dir,"/Hospitalizations_period4.png",sep="")
save_output_ALL = paste(dir,"/Hospitalizations_ALL.png",sep="")
save_output = paste(dir,"/Hospitalizations_trend.png",sep="")

cliques(dir_background,save_output=save_output1,
        language="ENG",contour=TRUE, 
        date_range=c("2020-03-20","2020-06-01"),
        add.ICU=c("ALL","Wednesday","NONE")[3])

cliques(dir_background,save_output=save_output2,
        language="ENG",contour=TRUE, 
        date_range=c("2020-05-20","2020-07-15"),
        add.ICU=c("ALL","Wednesday","NONE")[3])

cliques(dir_background,save_output=save_output3,
        language="ENG",contour=TRUE, 
        date_range=c("2020-07-05","2020-08-30"),
        add.ICU=c("ALL","Wednesday","NONE")[3])

cliques(dir_background,save_output=save_output4,
        language="ENG",contour=TRUE, 
        date_range=c("2020-08-20","2020-10-01"),
        add.ICU=c("ALL","Wednesday","NONE")[3])

cliques(dir_background,save_output=save_output,
        language="ENG",contour=TRUE, 
        date_range=c("2020-09-20",NA),
        add.ICU=c("ALL","Wednesday","NONE")[3])
  


cliques(dir_background,save_output=save_output_ALL,
        language="ENG",contour=TRUE, 
        date_range=c(NA,NA),
        add.ICU=c("ALL","Wednesday","NONE")[1])




