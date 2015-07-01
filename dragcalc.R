library(data.table)
library(ggplot2)

rm(list=ls())

speeds <- c(100,150,200,250,300,400,500,600,700,800,900,1000)
alts01 <- c(NA,NA,7278,10384,19434,25351,27468,28649,30087,31995,33511,34854)
alts02 <- c(NA,NA,7278,10384,19434,25351,27468,28649,30087,31995,33511,34854)

dt <- data.table(alt=seq(5000,35000,5000))
dt[,alt := alt/1000]
dt[,top := c(150,200,250,300,400,600,900)]

summary(lm(top~alt+I(alt^2),data=dt))
summary(lm(log(top)~alt,data=dt))

