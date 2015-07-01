library(data.table)
library(ggplot2)

rm(list=ls())

xseq <- seq(1000,50000,100)
xseq <- seq(0,1,0.01)
funcs <- list(c('sin',function (x) sin(x*pi/2)),
              c('linear',function (x) x),
              c('sqrt',sqrt),
              c('sqr',function (x) x^2))

resdts <- lapply(funcs,
                 function (f) data.table(name=f[[1]],x=xseq,theta=(f[[2]])(xseq)))

dt <- rbindlist(resdts)
dt[, alt := 1000 + x*(49000)]

ggplot(dt,aes(alt,theta,color=name)) + geom_line()
ggplot(dt,aes(theta,alt,color=name)) + geom_line()


