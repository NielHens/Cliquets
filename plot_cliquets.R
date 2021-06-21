# MAKE CLIQUES PLOT

source("cliquet.R")

#### TO MAKE PLOT OF CLIQUES

## dir_backgroup: directory where background.RData is located
## save_output: if plot needs to be saved, link & name of plot (png) - otherwise NULL
## language: ENG, NL 
## contour: TRUE or FALSE
## date_range: date range as vector (minimal date,maximial date); if no constraint put NA
## loc.timepoint: position of start and end date in the graph (1=below point, 2=left of point, 3=above point, 4=right of point)
## correction.weekend: TRUE to correct the growth rates for weekend effects (leads to smoother plot)

dir_background<-"..."

cliquet(dir_background,save_output=NULL,
        language="ENG",contour=TRUE, 
        date_range=c(NA,"2020-06-01"),
        pos.date=c(3,1),
        correction.weekend=TRUE)


cliquet(dir_background,save_output=NULL,
        language="ENG",contour=TRUE, 
        date_range=c("2020-07-01","2020-08-31"),
        pos.date=c(1,1),
        correction.weekend=TRUE)

cliquet(dir_background,save_output=NULL,
                  language="ENG",contour=TRUE, 
                  date_range=c("2021-02-01",NA),
                  pos.date=c(2,2),
                  extra.timepoint=c("2021-03-01","2021-04-01"),loc.timepoint=c(3,3),
                  correction.weekend=TRUE)
  








