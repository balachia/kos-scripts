library(data.table)

fileName <- 'boot.ks'
boot <- readChar(fileName, file.info(fileName)$size)

ms <- gregexpr("\\w+\\.ks",boot)
files <- sapply(1:length(ms[[1]]), function (x) {
        #print(x)
        #print(ms[[1]][x])
        #print(attr(ms[[1]],"match.length")[x])
        substr(boot,ms[[1]][x],ms[[1]][x]+(attr(ms[[1]],"match.length")[x]-1))
    })

files <- c('boot.ks',files)
dt <- data.table(file.info(files),keep.rownames=TRUE)
print(dt)
dt[,sum(size)]
