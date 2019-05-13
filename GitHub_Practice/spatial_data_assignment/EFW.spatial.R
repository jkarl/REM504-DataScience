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
library(dplyr)
library(xml2)
library(httr)

data.path <- "C:/Users/Emily Washburne/Documents/REM504-DataScience/Practice_Datasets"

getwd()
setwd("C:/Users/Emily Washburne/Documents/REM504-DataScience/Practice_Datasets")
?readOGR
?sample

## 1. Load the two shapefiles and name the objects gps.data and pasture
gps.data <- readOGR( dsn = data.path, layer = "holding_pasture_merged_cleaned")
pasture <- readOGR( dsn = data.path, layer = "private_pasture")

## Take a random subset of 10 GPS points
rand.IDs <- sample(1:length(gps.data), size = 10, replace = FALSE) #seperate ID numbers for 10 random points
gps.rand <- gps.data[rand.IDs,]

## 2. Refer to the data API lecture materials and use the USGS elevation API service to get the elevation value for each point
###   MAKE SURE YOU PROGRAM IN THE TIME DELAY using Sys.sleep(1)

cow.elevations <- data.frame()

for (i in 1:nrow(gps.rand@coords)) {
  row <- as.data.frame(gps.rand@coords)[i,]
  lat <- row$coords.x2
  long <- row$coords.x1 
  query.string <- paste("http://ned.usgs.gov/epqs/pqs.php?x=",long,"&y=",lat,"&units=Meters&output=xml",sep="")
  elev.response <- GET(query.string)
  if (elev.response$status_code == 200){
    elev.xml <- content(elev.response, "text") %>% read_xml
    elev <- xml_find_all(elev.xml, "//Elevation") %>% xml_text() %>% as.numeric()
    cow.elevations <- rbind(cow.elevations, data.frame("Latitude"= row$coords.x2,
                                                       "Longitude"= row$coords.x1,
                                                       "NED.elev"= elev))
  }
  Sys.sleep(1)
}

## 3. Check the projections for each dataset and reproject to UTM Zone 12 as needed
u12.proj <- "+proj=utm +zone=12 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0" # from spatialreference.org

projection(pasture)
projection(gps.data)

pasture.new <- spTransform(pasture, u12.proj)
gps.new <- spTransform(gps.data, u12.proj)

cow.location <- cbind(gps.geodd@data, cow.elevations) %>% select(id, rawDtTm, NED.elev, dist, velocty)

## 4. Determine how many points fall outside of the pasture boundary (due to GPS error)
#### Use the over() function in sp
#### The output of the over() function is a vector. The number of NAs in the vector will be the number of points outside the polygon.

outside.bound <- sp::over(x = gps.new, y = pasture.new)
summary(outside.bound)

## 5. Create a nice looking map of the points on top of the pasture boundary using ggplot
##   Export it with ggsave (make sure to inlcude your name in the filename).

#covert spatial data to regular df for ggplot use
pasture.new@data$id <- row.names(pasture.new@data)
pasture.new.df <- fortify(pasture.new, group = id)
gps.new.df <- as.data.frame(gps.new)

#basic map
ggplot() +
  geom_polygon(data = pasture.new.df, aes(x=long, y=lat), fill=NA, col="blue") +
  geom_point(data = gps.new.df, aes(x=coords.x1, y=coords.x2), alpha = 0.6)

ggsave("C:/Users/Emily Washburne/Documents/REM504-DataScience/GitHub_Practice/spatial_data_assignment/EmilyWashburne.spatial.tiff", device = "tiff", dpi = 300)

## 6. Calculate kernel density
###  Let's calculate a kernel density (number of cow locations per hectare) with the UTM12 GPS points
###  From the spatialEco package, use the sp.kde() function with the following options:
####  bw = 56.5 # radius in m of a 1ha circle
####  n = 1000 number of cells in output layer
### Plot your result with the plot() function and export it

kernel.density <- sp.kde(x = gps.data, bw = 56.5, n = 1000)
plot(kernel.density)
