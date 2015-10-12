args <- commandArgs(TRUE)
require(data.table)

data <- fread(args[1],header=TRUE)
data <- as.data.frame(data)
new_data <- data.frame(data[,-1], row.names=data[,1])
write.table(as.matrix(dist(new_data)),args[2])
