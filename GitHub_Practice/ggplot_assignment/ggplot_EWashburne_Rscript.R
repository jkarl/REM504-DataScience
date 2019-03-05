

## Load libraries
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)

getwd()

## Set environment and load data
path <- "C:/Users/Emily Washburne/Documents/REM504-DataScience/GitHub_Practice/ggplot_assignment"
file <- "LPI_top-hit_any-hit.csv"

data <- read.csv(file.path(path,file),header=T,stringsAsFactors = F)

## Tidy the data for plotting
data.long <- data %>% gather("key", "cover", -Plot) ## gather the data to long format
data.long$indicator <- str_sub(data.long$key,1,2) ## Get the first 2 letters to designate the indicator
data.long$method <- str_sub(data.long$key,4,6) ## Get the designation for the calculation method
data.plot <- data.long[,-2] %>% spread(method, cover)## Split the cover values from the any hit method back out from the top-hit values
names(data.plot) <- c("Plot","indicator","firsthit","anyhit") # Fix the names because it didn't like my "1st"

data.plot$firsthitpercent <- (data.plot$firsthit)*100
data.plot$anyhitpercent <- (data.plot$anyhit)*100

?ggplot
?facet_wrap
?geom_abline
?geom_smooth

label.string <- as_labeller(c('AG' = "Annual Grass", 'FB' = "Perennial Forb", 'SH' = "Shrub", 'PG' = "Perennial Grass"))

## Plot the data
ggplot(data = data.plot, aes(x = firsthitpercent, y = anyhitpercent)) + 
  geom_point(size = 1.3) + 
  facet_wrap(vars(indicator), labeller = label.string) +
  geom_abline(color = "blue") + 
  geom_smooth(color = "red", method = "lm", formula = y ~ x) +
  labs(x = "First Hit Cover %", y = "Any Hit Cover %", title = "Correlation Between Two Vegetation Intercept Cover Calculations", subtitle = "A Noble Attempt by Emily Washburne")

  