getwd()
[1] "C:/Users/rush1/Documents"
> setwd("C:/Users/rush1/Documents/GitHub/REM504-DataScience")
> library(ggplot2)
>LPI_data <- read.csv("C:/Users/rush1/Documents/GitHub/REM504-DataScience/LPI_top-hit_any-hit.csv")

  # AG
  tableAG <- ggplot() +  geom_point(data=LPI_data, aes(x=AG_1ST_HIT, y=AG_ANY_HIT)) +
  geom_smooth(data=LPI_data, aes(x=AG_1ST_HIT, y=AG_ANY_HIT), fill="blue",
              colour="darkblue", size=1) + geom_abline() + labs(title = "Annual Grass", x = "First Hit Cover %", y = "Any Hit Cover %" )
  # PG
  tablePG <- ggplot() +  geom_point(data=LPI_data, aes(x=PG_1ST_HIT, y=PG_ANY_HIT)) +
  geom_smooth(data=LPI_data, aes(x=PG_1ST_HIT, y=PG_ANY_HIT), fill="red",
              colour="red", size=1) + geom_abline() + labs(title = "Perrenial Grass", x = "First Hit Cover %", y = "Any Hit Cover %" )
  # FB
 tableFB <- ggplot() + geom_point(data=LPI_data, aes(x=FB_1ST_HIT, y=FB_ANY_HIT)) +
  geom_smooth(data=LPI_data, aes(x=FB_1ST_HIT, y=FB_ANY_HIT), fill="green",
              colour="green", size=1) + geom_abline() + labs(title = "Forb", x = "First Hit Cover %", y = "Any Hit Cover %" )
  # SH
 tableSH <- ggplot() + geom_point(data=LPI_data, aes(x=SH_1ST_HIT, y=SH_ANY_HIT)) +
  geom_smooth(data=LPI_data, aes(x=SH_1ST_HIT, y=SH_ANY_HIT), fill="purple",
              colour="purple", size=1) + geom_abline() + labs(title = "Shrub", x = "First Hit Cover %", y = "Any Hit Cover %")
>library(gridExtra)
>library(grid)
> combined.graph <- grid.arrange(tableAG,tablePG,tableFB,tableSH,nrow=2,ncol=2, top = textGrob("Correlation of cover indicators",gp=gpar(fontsize=20,font=3)))
>ggsave(filename = "combined.graph_LRush.jpg", plot = combined.graph, width = 5,height = 5, units = "in", dpi=150)
>
##Me trying to get the R-squared value to work...
AG.lm = lm(AG_1ST_HIT ~ AG_ANY_HIT, data= LPI_data)
> PG.lm = lm(PG_1ST_HIT ~ PG_ANY_HIT, data= LPI_data)
> FB.lm = lm(FB_1ST_HIT ~ FB_ANY_HIT, data= LPI_data)
> SH.lm = lm(AG_1ST_HIT ~ SH_ANY_HIT, data= LPI_data)
