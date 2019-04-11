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

data.path <- "C:\\Users\\jakal\\OneDrive - University of Idaho\\Documents\\GitHub\\REM504-DataScience\\Practice_Datasets"

## 1. Load the two shapefiles and name the objects gps.data and pasture


## Take a random subset of 10 GPS points
rand.IDs <- sample(1:length(gps.data),10) # Generate ID numbers for 10 random points
gps.rand <- gps.data[rand.IDs,]

## 2. Refer to the data API lecture materials and use the USGS elevation API service to get the elevation value for each point
###   MAKE SURE YOU PROGRAM IN THE TIME DELAY using Sys.sleep(1)



## 3. Check the projections for each dataset and reproject to UTM Zone 12 as needed
u12.proj <- "+proj=utm +zone=12 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0" # from spatialreference.org


## 4. Determine how many points fall outside of the pasture boundary (due to GPS error)
#### Use the over() function in sp
#### The output of the over() function is a vector. The number of NAs in the vector will be the number of points outside the polygon.



## 5. Create a nice looking map of the points on top of the pasture boundary using ggplot
##   Export it with ggsave (make sure to inlcude your name in the filename).



## 6. Calculate kernel density
###  Let's calculate a kernel density (number of cow locations per hectare) with the UTM12 GPS points
###  From the spatialEco package, use the sp.kde() function with the following options:
####  bw = 56.5 # radius in m of a 1ha circle
####  n = 1000 number of cells in output layer
### Plot your result with the plot() function and export it


