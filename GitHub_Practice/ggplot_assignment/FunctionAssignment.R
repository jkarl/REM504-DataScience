
## Load libraries
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
library(gridExtra)
library(grid)

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
names(data.plot) <- c("Plot","indicator", "firsthit", "anyhit") # Fix the names because it didn't like my "1st"

##Change names of indicators for clarity 
data.plot$indicator <- data.plot$indicator %>%
gsub(pattern = "AG", replacement = "Annual Grass") %>%
  gsub(pattern = "FB", replacement = "Forb") %>%
  gsub(pattern = "PG", replacement = "Perennial Grass") %>%
  gsub(pattern = "SH", replacement = "Shrub")

?geom_text
##Build Function for R^2 Ahead of Time 
lmeqn <- function(df){
    m <- lm(y ~ x, df);
    eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
          list(a = format(coef(m)[1], digits = 2),
              b = format(coef(m)[2], digits = 2),
              r2 = format(summary(m)$r.squared, digits = 3)))
    as.character(as.expression(eq));
   }

##Build function
plot.function <- function(df, ind){
  df.ind <- df %>% filter(indicator==ind)
  OutputGraph <- ggplot(data = df.ind, aes(x = firsthit, y = anyhit)) +
    geom_point(size = 1.2)+
    geom_abline(color = "blue") + 
    geom_smooth(color = "red", method = "lm", formula = y ~ x) +
    geom_text(label = lmeqn(df)) +
    labs(x = "", y = "", title = ind)
  
   return(OutputGraph)
}

indicators <- unique(data.plot$indicator)
grobs <- list()
for (ind in indicators) {
  grobs[[ind]] <- plot.function(df = data.plot, ind)
}

FinalGraph <- grid.arrange(grobs=grobs, ncol=2, nrow=2, gp=gpar(fontsize=13,font=2), left = paste("Any Hit Cover %"), bottom = paste("First Hit Cover %"), top = paste("Correlation Between Two Vegetation Measurements"))


ggsave(filename = "combined_graph_Washburne.jpg", plot = FinalGraph, width = 5,height = 5, units = "in", dpi=150)