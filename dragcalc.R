library(data.table)
library(ggplot2)

rm(list=ls())

dt <- data.table(alt=seq(5000,35000,5000))
dt[,alt := alt/1000]
dt[,top := c(150,200,250,300,400,600,900)]

summary(lm(top~alt+I(alt^2),data=dt))
summary(lm(log(top)~alt,data=dt))

