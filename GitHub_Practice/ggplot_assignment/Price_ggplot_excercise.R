library(readxl)
library(tidyverse)
library(ggplot2)
library(dplyr)
setwd('C:/Users/sjpri/Documents/GitHub/REM504-DataScience/GitHub_Practice/ggplot_assignment')
mydata<-read.csv("C:/Users/sjpri/Documents/GitHub/REM504-DataScience/GitHub_Practice/ggplot_assignment/LPI_top-hit_any-hit.csv",header=T)
#View(mydata)

longdata <- mydata %>% gather(key=vege,value=cover,-Plot) #long form...I don't understand how or why this works
longdata$key<-str_sub(longdata$vege,1,2) #need to create a new column named "key" to store our vege type
longdata$method<-str_sub(longdata$vege,4,6) #need to create a new column named "method" to store our sample method
data <- longdata[,-2] %>% spread(method, cover) #just splits up our two sample methods...I don't even know how
names(data) <- c("Plot","vege","first","any") #renames our columns

data$vege <- data$vege %>% #renaming variables within vege
  gsub(pattern = "AG", replacement = "Annual Grass") %>%
  gsub(pattern = "FB", replacement = "Forb") %>%
  gsub(pattern = "PG", replacement = "Perennial Grass") %>%
  gsub(pattern = "SH", replacement = "Shrub")


ggplot(data,aes(x=first,y=any))+
  geom_point()+
  geom_abline(slope=1,intercept=0,colour='red',size=1,linetype='dashed')+
  facet_wrap(facets = ~vege)+
  geom_smooth(method="lm",se=FALSE,colour='black')+
  xlab("Any Hit Cover") +
  ylab("First Hit Cover") +
  ggtitle("Vegetative Cover Indicators") +
  theme(text = element_text(size = 12), plot.title = element_text(hjust = 0.5)) 

ggsave("price_ggplot.tiff")
