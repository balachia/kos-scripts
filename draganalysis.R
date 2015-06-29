library(data.table)
library(ggplot2)

rm(list=ls())

setwd('~/Dropbox/Code/kos')

kg <- 3.5316e12
kr <- 6e5

dt <- fread('draglog.csv')
setnames(dt,names(dt),c('time','alt','speed','mass','thrust','accel','grav','atms','target'))
dt[, dt := time - c(NA,head(time,-1))]
dt[, dv := speed - c(NA,head(speed,-1))]
dt[, engaccel := dt * thrust/mass]
dt[, gravaccel := dt * kg / ((kr + alt)^2)]

dt[, dragaccel := engaccel - gravaccel - dv]
dt[, drag := dragaccel / dt]

# drag is proportional to speed squared?
dt[, kdrag := drag / (speed^2)]

# um:
# dv = engaccel - gravaccel - dragaccel
# so
# dragaccel = engaccel - gravaccel - dv

#plot(dt$speed,dt$drag)
#plot(dt$alt,dt$drag)

ndrop <- -25
#with(tail(dt,ndrop), plot(alt,kdrag))
#with(tail(dt,ndrop), plot(speed,kdrag))

dt[, keep := abs(drag - mean(drag,na.rm=T)) < 2 * sd(drag,na.rm=T),by=target]
# dt[, keep := abs(dv) < 0.10,by=target]

minspeed <- 0.98

# is kd constant in altitude across speeds?
ggplot(dt[speed > minspeed*target & keep],aes(alt,kdrag,color=as.factor(target))) +
    geom_point(size=0.1) + 
    stat_smooth()

## diagnostic: can we use drag discontinuities?
#ggplot(dt[speed > minspeed*target],aes(alt,dv)) + 
    #geom_line() +
    #stat_smooth() +
    #facet_wrap(~target,scales='free_y')

#ggplot(dt[speed > minspeed*target & keep],aes(alt,speed)) + 
    #geom_line() +
    #stat_smooth() +
    #facet_wrap(~target,scales='free_y')

ggplot(dt[speed > minspeed*target & keep],aes(alt,kdrag)) + 
    geom_line() +
    stat_smooth() +
    facet_wrap(~target,scales='free_y')

ggplot(dt[speed > minspeed*target & keep],aes(alt,drag)) + 
    geom_line() +
    stat_smooth() +
    facet_wrap(~target,scales='free_y')

for (trg in unique(dt[,target])) {
    print(trg)
    print(summary(dt[speed > minspeed*target & target==trg,drag]))
}







