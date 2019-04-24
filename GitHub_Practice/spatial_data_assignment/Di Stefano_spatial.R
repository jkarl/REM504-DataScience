# R Spatial data exercise
## Goal of this exercise is to load some spatial data in R, 
##    do some simple analyses, and create a map using ggplot.
##    Make sure to refer to the class lecture materials for how to do the steps below.

#### Datasets (in the class repo Practice_Datasets folder:
####  private_pasture.shp - private pasture boundary
####  holding_pasture_merged_cleaned.shp - merged set of cattle GPS points

## Load libraries
library(rgdal)
library(sp)
library(raster)
library(spatialEco)
library(ggplot2)
library(mapproj)
library(ggsn)
library(rasterVis)
library(tidyverse)
library(xml2)
library(httr)

setwd("C:/Users/sfper/Documents/R/REM504-DataScience/Practice_Datasets")

## 1. Load the two shapefiles and name the objects gps.data and pasture
gps.data <- readOGR(dsn = getwd(), layer = "holding_pasture_merged_cleaned")
pasture <- readOGR(dsn = getwd(), layer = "private_pasture")

## Take a random subset of 10 GPS points
rand.IDs <- sample(1:length(gps.data),10) # Generate ID numbers for 10 random points
gps.rand <- gps.data[rand.IDs,]

# reprojecting to lat/long so that I can later be able to pull elevations
proj <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
cow.locs <- spTransform(gps.rand, proj)

## 2. Refer to the data API lecture materials and use the USGS elevation API service to get the elevation value for each point
###   MAKE SURE YOU PROGRAM IN THE TIME DELAY using Sys.sleep(1)
cow.elevations <- data.frame() # empty dataframe

for(i in 1:nrow(cow.locs@coords)) {
  loc <- as.data.frame(cow.locs@coords)[i,]
  lat <- loc$coords.x2
  long <- loc$coords.x1
  query.string <- paste("http://ned.usgs.gov/epqs/pqs.php?x=",long,"&y=",lat,"&units=Meters&output=xml",sep="")
  elev.response <- GET(query.string)
  if(elev.response$status_code == 200){
    elev.xml <- content(elev.response, "text") %>% read_xml
    elev <- xml_find_all(elev.xml, "//Elevation") %>% xml_text() %>% as.numeric()
    cow.elevations <- rbind(cow.elevations, data.frame("NED.elev"=elev)) 
  }
}
# combining cow data with elevation
cow.data <- cbind(cow.locs@data, cow.elevations) %>% select(id, rawDtTm, NED.elev,
                                                            dist, velocty) 


## 3. Check the projections for each dataset and reproject to UTM Zone 12 as needed
u12.proj <- CRS("+proj=utm +zone=12 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0") # from spatialreference.org

projection(pasture)
projection(gps.data)

pasture.u12 <- spTransform(pasture, u12.proj)

## 4. Determine how many points fall outside of the pasture boundary (due to GPS error)
#### Use the over() function in sp
#### The output of the over() function is a vector. The number of NAs in the vector will be the number of points outside the polygon.
outside.points <- sp::over(x = gps.data, y = pasture.u12)

# counting the number of NAs
summary(outside.points) # 129 NAs

## 5. Create a nice looking map of the points on top of the pasture boundary using ggplot
##   Export it with ggsave (make sure to inlcude your name in the filename).
 
pasture.u12@data$id <- row.names(pasture.u12@data)
pasture.df <- fortify(pasture.u12, group=id) # converting .shp to dataframe 

gps.data.df <- as.data.frame(gps.data) # converting points.shp to dataframe # fortify doesn't work on points
summary(gps.data.df$velocty) # quantile values used as breaks for velocity categories
gps.data.df <- gps.data.df %>% mutate(vel.class = cut(velocty, breaks=c(-Inf, 1.373, 4.646, Inf), # breaks identified from summary data
                                                      labels=c("Resting", "Grazing", "Walking"))) %>% # classes of velocity
                               na.omit() # removing rows with NA

ggplot() +
  geom_polygon(data = pasture.df, aes(x=long, y=lat), fill=NA, col="black") +
  geom_point(data = gps.data.df, aes(x=coords.x1, y=coords.x2, col = vel.class), alpha = 0.6) +
  labs(col = "Velocity Class") +
  blank() + # making background blank (no axes)
  north(pasture.df, symbol = 1, location = "bottomleft", scale = 0.2) # adding north arrow
  
ggsave("C:/Users/sfper/Documents/R/REM504-DataScience/GitHub_Practice/spatial_data_assignment/sean.distefano.grazing.loc.tiff",
       device = "tiff", dpi = 300)
## 6. Calculate kernel density
###  Let's calculate a kernel density (number of cow locations per hectare) with the UTM12 GPS points
###  From the spatialEco package, use the sp.kde() function with the following options:
####  bw = 56.5 # radius in m of a 1ha circle
####  n = 1000 number of cells in output layer
### Plot your result with the plot() function and export it
kernel.den <- sp.kde(x = gps.data, bw = 56.5, n = 1000)

# rough plot
plot(kernel.den)
# color palette for raster
color <- colorRampPalette(brewer.pal(9,'YlOrRd')) # 9 is number of colors (max n for "YlOrRd")
# prettier plot of kernel density # using package rasterVis
plot <- levelplot(x = kernel.den,
          margin=FALSE, # removes axes
          par.settings=list(axis.line=list(col='transparent')), # remove axes and legen outline
          scales=list(draw=FALSE), # removes axes' labels
          col.regions=color # color ramp
          ) +
  layer(sp.polygons(pasture.u12, # add pasture outline
                    lwd = 3) # outline width
        )

trellis.device(device = "tiff", filename = "C:/Users/sfper/Documents/R/REM504-DataScience/GitHub_Practice/spatial_data_assignment/sean.distefano.kernel.den.tiff")
print(plot)
dev.off()
