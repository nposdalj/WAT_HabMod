library(ncdf4)
library(httr)
library(zoo)
library(raster)
library(oceanmap)
library(viridis)

#load files
sal = nc_open("coastwatchSMOSv662SSS1day_f370_bdcf_ecf9.nc")
names(sal$var)
v1=sal$var[[1]]
Salvar=ncvar_get(sal,v1)
Sal_lon=v1$dim[[1]]$vals
Sal_lat=v1$dim[[2]]$vals
dates=as.POSIXlt(v1$dim[[4]]$vals,origin='1970-01-01',tz='GMT')

##summarizing data by month
sal_name="monthly variable with the right long and lat/coastwatchSMOSv662SSS1day_f370_bdcf_ecf9.nc"
readsal=ncvar_get(sal,"sss")
stack_sal = stack(sal_name, varname = "sss")
dates_salinity=as.Date(sal$dim$time$vals/30)
monthly_mean_stack <- function(x) {
  require(zoo)
  pixel.ts <- zoo(x, dates)
  out <- as.numeric(aggregate(pixel.ts, as.yearmon, mean, na.rm=TRUE))
  out[is.nan(out)] <- NA     
  return(out)
}
v <- getValues(stack_sal) # every row displays one pixel (-time series)
# this should give you a matrix with ncol = number of months and nrow = number of pixel
means_matrix <- t(apply(v, 1, monthly_mean_stack))
means_stack <- calc(stack_sal, monthly_mean_stack)

#extracting salinity for an individual point
pointHZ = cbind(41,-66)
resultHZ = extract(means_stack,pointHZ)

pointGS = cbind(28.4,-81.1)
resultGS = extract(means_stack,pointGS)

#creating maps
#setting color breaks
h=hist(Salvar[,,1],100,plot=FALSE)
breaks=h$breaks
n=length(breaks)-1
jet.colors <-colorRampPalette(c("blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
c=jet.colors(n)
#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[3]))

#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()
#adding HARP point
points(-66.35, rep(41.06165),pch=20,cex=2)
points(33.6699, rep(-76),pch=20,cex=2)

#plotting time series
I=which(sal_lon>=-81.125 & sal_lon<=-63.875) #change lon to SST_lon values to match ours, use max and min function
J=which(sal_lat>=28.375 & sal_lat<=42.875) #change ""
sst2=salvar[I,J,] 

n=dim(sst2)[3] 

res=rep(NA,n) 
for (i in 1:n) 
  res[i]=mean(sst2[,,i],na.rm=TRUE) 

plot(1:n,res,axes=FALSE,type='o',pch=20,xlab='',ylab='salinity (sss)') 
axis(2) 
axis(1,1:n,format(dates,'%m')) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[2]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[3]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[4]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[5]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[6]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[7]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[8]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[9]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[10]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[11]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[12]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()

#begin plot
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
image(Sal_lon,Sal_lat,Salvar[,,1],col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs='i',yaxs='i',asp=1, main=paste("Monthly Salinity", dates[13]))
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Salinity') 
axis(4, las=1) 
box()