mydata<-read.csv("C:/Users/sjpri/Dropbox/school/2019 Spring/data science/LPI_top-hit_any-hit.csv",header=T)
head(mydata)
names(mydata)

library(ggplot2)
library(dplyr)
p<-ggplot(data=mydata,aes(x=mydata$X1ST_HIT,y=mydata$ANY_HIT,col=mydata$Veg,))+
  geom_point()+
  #geom_abline(slope=1,intercept=0)+
  facet_wrap(facets = ~mydata$Veg)+
  #stat_smooth_func(geom="text",method="lm",hjust=0,parse=TRUE) +
  geom_smooth(method="lm",se=FALSE)
plot(p)


p+geom_abline(slope=1,intercept=0)
plot(p)



