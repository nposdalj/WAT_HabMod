library(ncdf4)
library(httr)
library (naniar)

#load files
ChlA = nc_open("erdMH1chlamday_8b69_53f4_fca7.nc")
names(ChlA$var)
v1=ChlA$var[[1]]
ChlAvar=ncvar_get(ChlA,v1)
ChlA_lon=v1$dim[[1]]$vals
ChlA_lat=v1$dim[[2]]$vals
dates=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

#plotting all values greater than 2, as 2
ChlAvar[ChlAvar > 2] = 2

#creating maps
#setting color breaks
h=hist(ChlAvar[,,1],100,plot=FALSE)
breaks=h$breaks
n=length(breaks)-1
jet.colors <-colorRampPalette(c("blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
c=jet.colors(n)
#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[1]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()
#adding HARP point
points(-66.35, rep(41.06165),pch=20,cex=2)
points(33.6699, rep(-76),pch=20,cex=2)

#plotting time series HZ
I=which(ChlA_lon>=-66.6 & ChlA_lon<=-66.1) #change lon to SST_lon values to match ours, use max and min function
J=which(ChlA_lat>=40.81165 & ChlA_lat<=41.31165) #change ""
sst2=ChlAvar[I,J,] 

n=dim(sst2)[3] 

res=rep(NA,n) 
for (i in 1:n) 
  res[i]=mean(sst2[,,i],na.rm=TRUE) 

plot(1:n,res,axes=FALSE,type='o',pch=20,xlab='',ylab='Chla (mg m-3)') 
axis(2) 
axis(1,1:n,format(dates,'%m')) 
box()

#plotting time series GS
I=which(ChlA_lon>=-76.25 & ChlA_lon<=-75.75) #change lon to SST_lon values to match ours, use max and min function
J=which(ChlA_lat>=33.41991667 & ChlA_lat<=33.91991667) #change ""
sst2=ChlAvar[I,J,] 

n=dim(sst2)[3]

res=rep(NA,n) 
for (i in 1:n) 
  res[i]=mean(sst2[,,i],na.rm=TRUE) 

plot(1:n,res,axes=FALSE,type='o',pch=20,xlab='',ylab='Chla (mg m-3)') 
axis(2) 
axis(1,1:n,format(dates,'%m')) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[2]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[3]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[4]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[5]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[6]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[7]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[8]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[9]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[10]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[11]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[12]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(ChlA_lon,rev(ChlA_lat),ChlAvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly ChlA", dates[13]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()