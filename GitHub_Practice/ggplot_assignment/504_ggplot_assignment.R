

## Load libraries
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)

## Set environment and load data
path <- ".\\GitHub\\REM504-DataScience\\GitHub_Practice\\ggplot_assignment"
file <- "LPI_top-hit_any-hit.csv"

data <- read.csv(file.path(path,file),header=T,stringsAsFactors = F)

## Tidy the data for plotting
data.long <- data %>% gather("key", "cover", -Plot) ## gather the data to long format
data.long$indicator <- str_sub(data.long$key,1,2) ## Get the first 2 letters to designate the indicator
data.long$method <- str_sub(data.long$key,4,6) ## Get the designation for the calculation method
data.plot <- data.long[,-2] %>% spread(method, cover)## Split the cover values from the any hit method back out from the top-hit values
names(data.plot) <- c("Plot","indicator","firsthit","anyhit") # Fix the names because it didn't like my "1st"

## Plot the data

  