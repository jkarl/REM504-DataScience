## Load libraries
library(rgdal)
library(sp)
library(raster)
library(spatialEco)
library(ggplot2)

path <- "/Users/keri_york/Documents/GitHub/REM504-DataScience/Practice_Datasets"
data.file <- "private_pasture"
setwd(path)

#Read in file 1
gps.data <- readOGR(dsn=path, layer = data.file)
View(gps.data)
pasture <- gps.data
View(gps.data@data)

#Read in file 2
path <- "/Users/keri_york/Documents/GitHub/REM504-DataScience/Practice_Datasets"
data.file2 <- "holding_pasture_merged_cleaned"
setwd(path)

View(data.file2)
gps.data2 <- readOGR(dsn=path, layer = data.file2)
View(gps.data2)
pastures_merged <- gps.data2
View(gps.data2@data)

## Take a random subset of 10 GPS points
rand.IDs <- sample(1:length(gps.data2),10) # Generate ID numbers for 10 random points
gps.rand <- gps.data2[rand.IDs,]
View(gps.rand@data)

#install package httr, magrittr, xml2, elevatr and XML
library(httr)
library(XML)
library(magrittr)
library(xml2)
library(elevatr)

# Reproject datasets
u12.proj <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
cow.locs <- spTransform(gps.rand, u12.proj)
cow.elevations <- data.frame() # empty dataframe

# Connect to API
elev.response <- GET("http://ned.usgs.gov/epqs/pqs.php?x=-123.45&y=44.56&units=Meters&output=xml")
response.code <- status_code(elev.response)
elev.xml.string <- content(elev.response, "text")
elev.xml <- xmlSource(elev.xml.string)
elev <- xml_find_all(elev.xml, "//Elevation") %>% xml_text() %>% as.numeric()
print(elev)

for (i in 1:nrow(cow.locs)) {
  row <- cow.locs[i,]
  lat <- row$Latitude
  lon <- row$Longitude
  query.string <- paste("http://ned.usgs.gov/epqs/pqs.php?x=",lon,"&y=",lat,"&units=Meters&output=xml",sep="")
  elev.response <- GET(query.string)
  if (status_code(elev.response)==200){
    elev.xml <- content(elev.response, "text") %>% read_xml
    elev <- xml_find_all(elev.xml, "//Elevation") %>% xml_text() %>% as.numeric()
    cow.elevations <- rbind(cow.elevations, data.frame("Index"=row$Index, 
                                                       "Date"=row$Date,
                                                       "Time"=row$Time,
                                                       "Latitude"=row$Latitude,
                                                       "Longitude"=row$Longitude,
                                                       "EHPE"=row$EHPE,
                                                       "GPS.Altitude"=row$Altitude,
                                                       "NED.elev"=elev))
  }
  Sys.sleep(0.5)
}

u12.proj <- "+proj=utm +zone=12 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"

library(dplyr)
# combining cow data with elevation
cow.data <- cbind(cow.locs@data, cow.elevations) %>% select(id, rawDtTm, NED.elev,
                                                            dist, velocty)

pasture.u12 <- spTransform(pasture, u12.proj)

# Determine points outside of boundary
outside <- sp::over(x = gps.data, y=pasture.u12)

