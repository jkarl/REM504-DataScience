# creating ggplot graphs using functions and gridExtra

## Load libraries
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
library(gridExtra)
library(grid)

setwd("C:/Users/rush1/Documents/GitHub/REM504-DataScience/")
library(ggplot2)
data <- read.csv("LPI_top-hit_any-hit.csv", header=T,stringsAsFactors = F)

## Tidy the data for plotting
data.long <- data %>% gather("key", "cover", -Plot) ## gather the data to long format
data.long$indicator <- str_sub(data.long$key,1,2) ## Get the first 2 letters to designate the indicator
data.long$method <- str_sub(data.long$key,4,6) ## Get the designation for the calculation method
data.plot <- data.long[,-2] %>% spread(method, cover)## Split the cover values from the any hit method back out from the top-hit values
names(data.plot) <- c("Plot","indicator","firsthit","anyhit") # Fix the names because it didn't like my "1st"


## Write a function to create the ggplot graph. Give it arguments for dataset and indicator
## Use the indicator argument to filter the records from the dataset
## Add the axis legends and title
## Add the trendline, AB line, and R^2 value to the graph too.
## Have your function return a ggplot object


lm_eqn <- function(df){
  m <- lm(anyhit~firsthit, df);
  eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
                   list(
                        r2 = format(summary(m)$r.squared, digits = 3)))
  as.character(as.expression(eq));
}


LPI.function <- function(df, ind) { 
  df.filter <- df %>% filter(indicator == ind)
  data.lm <- lm(anyhit~firsthit,data=df.filter)
  LPI.CombinedGraph <- ggplot(data = df, aes(x = firsthit, y = anyhit)) +
    geom_point() +
    geom_smooth(method="lm", fill="blue", colour="blue", size=1) +
    geom_text(aes(x = 25, y = 300, label = lm_eqn(lm(anyhit~firsthit, df))), parse = TRUE) +
    geom_abline() + labs(title = "Indicators", x = "First Hit Cover %", y = "Any Hit Cover %" )
  return(LPI.CombinedGraph)
}

NewGraph <- LPI.CombinedGraph + geom_text(x = 25, y = 300, label = lm_eqn(df), parse = TRUE)

indicators <- unique(data.plot$indicator)
grobs <- list()
for (each.indicator in indicators) {
  grobs[[each.indicator]] <- LPI.function(df = data.plot, each.indicator)
}

# Now we can use the list as the input to grid.arrange
LPI.function <- grid.arrange(grobs=grobs,ncol=2,nrow=2,top = textGrob("2 Methods of Vegetative Cover Indicators",gp=gpar(fontsize=20,font=3)))

