library(data.table)
library(ggplot2)
library(rootSolve)

rm(list=ls())

setwd('~/Dropbox/Code/kos')

kg <- 3.5316e12
kr <- 6e5

dt <- fread('draglog.csv')
setnames(dt,names(dt),c('time','alt','speed','mass','thrust','accel','grav','atms','target'))
dt[, dt := time - c(NA,head(time,-1))]
dt[, dv := speed - c(NA,head(speed,-1))]
dt[, engaccel0 := dt * thrust/mass]
dt[, gravaccel0 := dt * kg / ((kr + alt)^2)]

# interpolate engine, gravity
dt[, engaccel := 0.5*(engaccel0 + c(NA,head(engaccel0,-1)))]
dt[, gravaccel := 0.5*(gravaccel0 + c(NA,head(gravaccel0,-1)))]

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
ggplot(dt[speed > minspeed*target],aes(alt,kdrag,color=as.factor(target))) +
    geom_point(size=0.1) + 
    coord_cartesian(ylim = c(-2e-5,2e-5)) +
    stat_smooth(method='loess',span=0.2)

## diagnostic: can we use drag discontinuities?
#ggplot(dt[speed > minspeed*target],aes(alt,dv)) + 
    #geom_line() +
    #stat_smooth() +
    #facet_wrap(~target,scales='free_y')

#ggplot(dt[speed > minspeed*target & keep],aes(alt,speed)) + 
    #geom_line() +
    #stat_smooth() +
    #facet_wrap(~target,scales='free_y')

#ggplot(dt[speed > minspeed*target & keep],aes(alt,kdrag)) + 
    #geom_line() +
    #stat_smooth() +
    #facet_wrap(~target,scales='free_y')

ggplot(dt[speed > minspeed*target & keep],aes(alt,drag)) + 
    geom_line() +
    coord_cartesian(ylim = c(-0.2,1)) +
    stat_smooth(method='loess',n=200,span=0.2) +
    facet_wrap(~target,scales='free_y')

speeds <- sort(unique(dt[,target]))
pseq <- c(0.05,0.1,0.2,0.3)
alts <- lapply(pseq,function (x) rep(0,length(speeds)))
names(alts) <- pseq
idx <- 1
for (trg in speeds) {
    cat(rep('=',40),'\n',sep='')
    cat(trg,'\n')
    lo <- loess(drag~alt,data=dt[speed>minspeed*target & keep & target==trg],span=0.2)
    f <- function(x,p) predict(lo,c(alt=x)) - p
    xseq <- seq(5000,50000,100)
    #plot(xseq,f(xseq,0))
    rts <- lapply(pseq,
                  function(x) uniroot.all(f,p=x,interval=c(5e3,5e4)))
    rts <- lapply(rts,
                  function (x) if (length(x) == 0) {NA} else {x})
    names(rts) <- pseq
    for (name in as.character(pseq)) print(alts[[name]][[idx]] <- rts[[name]][1])
    print(summary(dt[speed > minspeed*target & target==trg,drag]))
    idx <- idx + 1
    #print((dt[target==trg & drag > 0.1 & drag < 0.5,alt]))
}

#plot(speeds,alts[['0.05']])
#plot(speeds,alts[['0.1']])
#plot(speeds,alts[['0.2']])
#plot(speeds,alts[['0.3']])

summary(lm(speeds ~ I(alts[['0.05']]/1e3) + I((alts[['0.05']]/1e3)^2)))
summary(lm(speeds ~ I(alts[['0.1']]/1e3) + I((alts[['0.1']]/1e3)^2)))
summary(lm(speeds ~ I(alts[['0.2']]/1e3) + I((alts[['0.2']]/1e3)^2)))
summary(lm(speeds ~ I(alts[['0.3']]/1e3) + I((alts[['0.3']]/1e3)^2)))

summary(lm(speeds ~ alts[['0.05']] + I(alts[['0.05']]^2)))
summary(lm(speeds ~ alts[['0.1']] + I(alts[['0.1']]^2)))
summary(lm(speeds ~ alts[['0.2']] + I(alts[['0.2']]^2)))
summary(lm(speeds ~ alts[['0.3']] + I(alts[['0.3']]^2)))

summary(lm(log(speeds) ~ alts[['0.05']]))
summary(lm(log(speeds) ~ alts[['0.1']]))
summary(lm(log(speeds) ~ alts[['0.2']]))
summary(lm(log(speeds) ~ alts[['0.3']]))





