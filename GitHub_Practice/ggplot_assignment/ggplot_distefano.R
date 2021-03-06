## Load libraries
library(ggplot2)
library(tidyverse)
library(stringr)

## Set environment and load data
setwd("C:/Users/sfper/Documents/R/REM504-DataScience/GitHub_Practice/ggplot_assignment")
data <- read.csv("LPI_top-hit_any-hit.csv",header=T,stringsAsFactors = F)

## Tidy the data for plotting
data.long <- data %>% gather("key", "cover", -Plot) ## gather the data to long format
data.long$indicator <- str_sub(data.long$key,1,2) ## Get the first 2 letters to designate the indicator
data.long$method <- str_sub(data.long$key,4,6) ## Get the designation for the calculation method
data.plot <- data.long[,-2] %>% spread(method, cover)## Split the cover values from the any hit method back out from the top-hit values
names(data.plot) <- c("Plot","indicator","firsthit","anyhit") # Fix the names because it didn't like my "1st"

# renaming indicators so that their names are obvious
data.plot$indicator <- data.plot$indicator %>% 
  gsub(pattern = "AG", replacement = "Annual Grass") %>%
  gsub(pattern = "FB", replacement = "Forb") %>%
  gsub(pattern = "PG", replacement = "Perennial Grass") %>%
  gsub(pattern = "SH", replacement = "Shrub")

# changing from proportion to percentage
data.plot$firsthit <- data.plot$firsthit * 100
data.plot$anyhit <- data.plot$anyhit * 100

## Plot the data
ggplot(data.plot, aes(x = data.plot$firsthit, y = data.plot$anyhit)) +
  geom_point() +
  facet_wrap(vars(indicator)) +
  geom_abline(linetype = "dashed", size = 1, colour = "red") +
  geom_smooth(method = lm, se = F, fullrange = T) +
  xlab("Any Hit Cover %") +
  ylab("First Hit Cover %") +
  ggtitle("Comparison Between 2 Vegetative Cover Indicators") +
  theme(text = element_text(size = 12), plot.title = element_text(hjust = 0.5)) 

ggsave("sean_ggplot.jpeg")
