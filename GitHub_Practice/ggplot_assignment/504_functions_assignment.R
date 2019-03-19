# creating ggplot graphs using functions and gridExtra

## Load libraries
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
library(gridExtra)
library(grid)

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


## Write a function to create the ggplot graph. Give it arguments for dataset and indicator
## Use the indicator argument to filter the records from the dataset
## Add the axis legends and title
## Add the trendline, AB line, and R^2 value to the graph too.
## Have your function return a ggplot object




## We'll use an iterator to run our graphs automagically
indicators <- unique(data.plot$indicator)
grobs <- list()
for (ind in indicators) {
  grobs[[ind]] <- ### Call your function here. This will assign the output of the function to a new entry in a list
}

# Now we can use the list as the input to grid.arrange
grid.arrange(grobs=grobs,ncol=2,nrow=2,top = textGrob("Fancy plot title goes here",gp=gpar(fontsize=20,font=3)))

## Save using ggsave. Make sure to change the file name accordingly
ggsave(filename = "combined_graph_yourname.jpg", plot = combined.graph, width = 5,height = 5, units = "in", dpi=150)
