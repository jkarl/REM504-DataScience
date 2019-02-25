library(readxl)
library(tidyverse)

setwd("C:/Users/sfper/Documents/R/REM504-DataScience/GitHub_Practice/tidy_data_assignment/")

raw.data <- readxl::read_excel("TidyDataPractice_SalsifyData.xlsx")
clean.data <- read.csv("tidied_salsify_data.csv")

raw01 <- raw.data[2:15,2:6]
raw02 <- raw.data[22:30,2:6]
raw03 <- raw.data[36:39,2:6]


colnames(raw01) <- c("Team01", "Team02", "Team03", "Team04", "Team05")
raw01$Quadrat <- "20X50"
raw01 <- raw01[c(-1,-2,-3,-4),]
long01 <- raw01 %>% gather( -Quadrat, key = Team, value = Density)

colnames(raw02) <- c("Team01", "Team02", "Team03", "Team04", "Team05")
raw02$Quadrat <- "50X50"
raw02 <- raw02[c(-1,-2,-3,-4),]
long02 <- raw02 %>% gather(-Quadrat, key = Team, value = Density)

colnames(raw03) <- c("Team01", "Team02", "Team03", "Team04", "Team05")
raw03$Quadrat <- "30X1"
raw03 <- raw03[c(-1,-2,-3),]
long03 <- raw03 %>% gather(-Quadrat, key = Team, value = Density)

tidy.data <- rbind(long01, long02, long03)

write.csv(tidy.data, "sean_tidied_salsify_data.csv")
