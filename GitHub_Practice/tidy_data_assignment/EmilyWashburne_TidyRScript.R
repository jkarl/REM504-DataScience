setwd("C:/Users/Emily Washburne/Documents/R/DataScienceClass")
getwd()
install.packages("tidyverse")
library(tidyverse)
install.packages("readxl")
library(readxl)
?readxl

#read untidy 'master' excel file into R to create path to document 
Untidy <- read_xlsx("TidyDataPractice_SalsifyData.xlsx")

#select each seperate table within master and make into object 
Design1 <- read_excel("TidyDataPractice_SalsifyData.xlsx", range = "B3:F16")
Design2 <- read_excel("TidyDataPractice_SalsifyData.xlsx", range = "B23:F31")
Design3 <- read_excel("TidyDataPractice_SalsifyData.xlsx", range = "B37:F40")

library(dplyr)
library(tidyr)

#remove superfluous rows 
Design1 = Design1[-(1:3),]
Design2 = Design2[-(1:3),]
Design3 = Design3[-(1:2),]

#Name all columns and cleanly re-add Quadrat type 
colnames(Design1) <- c("Team1", "Team2", "Team3", "Team4", "Team5")
Design1$Quadrat_Size <- "50cmX20cm"

colnames(Design2) <- c("Team1", "Team2", "Team3", "Team4", "Team5")
Design2$Quadrat_Size <- "50cmX50cm"

colnames(Design3) <- c("Team1", "Team2", "Team3", "Team4", "Team5")
Design3$Quadrat_Size <- "30mX1m"

?gather

#Gather from wide to long 
Design1Tidy <- gather(Design1, key = "Team", value = "Plant_Density", -Quadrat_Size)
Design2Tidy <- gather(Design2, key = "Team", value = "Plant_Density", -Quadrat_Size)
Design3Tidy <- gather(Design3, key = "Team", value = "Plant_Density", -Quadrat_Size)

#Bind Together 
Final_Tidy <- rbind(Design1Tidy, Design2Tidy, Design3Tidy)

write.csv(Final_Tidy, "EmilyWashburne_SalsifyTidy.csv")
