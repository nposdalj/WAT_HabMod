library(ncdf4)
library(httr)
library (naniar)
library(ggmap)
library("rnaturalearth")
library("rnaturalearthdata")
library(ggplot2)
library(rgeos)

#load files
ChlA = nc_open("erdMH1chlamday_8b69_53f4_fca7.nc")
names(ChlA$var)
v1=ChlA$var[[1]]
ChlAvar=ncvar_get(ChlA,v1)
ChlA_lon=v1$dim[[1]]$vals
ChlA_lat=v1$dim[[2]]$vals
dates=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

#loading the world
world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

#plotting all values greater than 2, as 2
ChlAvar[ChlAvar > 2] = 2

#setting color breaks
h=hist(ChlAvar[,,1],100,plot=FALSE)
breaks=h$breaks
n=length(breaks)-1
jet.colors <-colorRampPalette(c("blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
c=jet.colors(n)

#creating maps in base R
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4) 
layout.show(2) 
par(mar=c(3,3,3,1))
r = raster(t(ChlAvar[,,1]),xmn = min(ChlA_lon),xmx = max(ChlA_lon),ymn=min(ChlA_lat),ymx=max(ChlA_lat))
image(r,col=c,breaks=breaks,xlab='',ylab='',axes=TRUE,xaxs="i",yaxs="i",asp=-1, main=paste("Monthly ChlA", dates[1]))
points(-66.35, rep(41.06165),pch=20,cex=1)
points(-76, rep(33.6699),pch=20,cex=2)
#adding color scale
par(mar=c(3,1,3,3))
source('scale.R') 
image.scale(sst[,,1], col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Chl a') 
axis(4, las=1) 
box()

#creating maps in ggplot
r = raster(t(ChlAvar[,,1]),xmn = min(ChlA_lon),xmx = max(ChlA_lon),ymn=min(ChlA_lat),ymx=max(ChlA_lat))
points = rasterToPoints(r, spatial = TRUE)
df = data.frame(points)
names(df)[names(df)=="layer"]="Chla"
mid = mean(df$Chla)
ggplot(data=world) +  geom_sf()+coord_sf(xlim= c(-81,-65),ylim=c(31,43),expand=FALSE)+
  geom_raster(data = df , aes(x = x, y = y, fill = Chla)) + 
  ggtitle(paste("Monthly Chl A", dates[1]))+geom_point(x = -66.3, y = 41.1, color = "black",size=3)+
  geom_point(x=-76, y=33.69, color = "red",size = 3)+xlab("Latitude")+ylab("Longitude")+
  scale_fill_gradient2(midpoint = mid, low="blue", mid = "yellow",high="green")

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