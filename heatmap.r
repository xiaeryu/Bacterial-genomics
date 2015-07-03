## args[1]: the input table file
## args[2]: the output pdf file
## prerequisites: gplots

args <- commandArgs(TRUE)
library(gplots)

data <- read.table(args[1],header=T,row.names=1)
pdf(args[2])
heatmap.2(as.matrix(data),Rowv=F,trace="none",density.info="none",margins =c(8,8),dendrogram="none")
dev.off()
