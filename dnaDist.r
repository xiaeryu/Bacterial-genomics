library(ape)

## Read in fasta file
data <- read.FASTA("input.fasta") # Read input multiple fasta file

## Calculate the pair-wise distance
# Route 1 #
out <-  dist.dna(data,model="raw",pairwise.deletion=TRUE,as.matrix=T) ## Full matrix
out[lower.tri(out,diag=T)] <- NA ## take upper triangular matrix, when needed

# Route 2 #
out <-  dist.dna(data,model="raw",pairwise.deletion=TRUE)

## Plot
hist(as.matrix(out),breaks=1000,na.rm=T)
plot(density(as.matrix(out),na.rm=T))

