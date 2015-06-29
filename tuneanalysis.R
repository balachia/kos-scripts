library(data.table)
library(ggplot2)

rm(list=ls())

setwd('~/Dropbox/Code/kos')

kg <- 3.5316e12
kr <- 6e5

dt <- fread('dragtune.csv')
setnames(dt,names(dt),c('time','kp','tgtspd','spd'))
dt[,grp := paste0(tgtspd,'-',kp)]

dt[, back := spd - c(NA,head(spd,-1)),by=grp]
dt[, fwd := spd - c(tail(spd,-1),NA),by=grp]
dt[, opt := sign(back)*sign(fwd)]
dt[is.na(opt), opt:= 0]

# find inter optimum timing
optims <- dt[opt == 1]
optims[, dtime := time - c(NA,head(time,-1)),by=grp]

# optimum stats
# change is the growth in amplitude over time
optimstats <- optims[!is.na(dtime),
                     list(mean=mean(dtime),
                          med=median(dtime),
                          sd=sd(dtime),
                          min=min(dtime),
                          max=max(dtime),
                          p25=quantile(dtime,0.25),
                          p75=quantile(dtime,0.75),
                          change=coef(lm(spd~time,data=.SD[back>0 & time < 60]))['time']),
                          by=grp]

print(optimstats)

print(optims[,list(min=min(time),max=max(time)),by=grp])

ggplot(dt[time>10 & time < 60],aes(time,spd)) + geom_line() +
    facet_wrap(~grp)

