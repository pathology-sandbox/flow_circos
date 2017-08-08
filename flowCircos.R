
# Import modules
source("http://bioconductor.org/biocLite.R")
biocLite("flowCore")
biocLite("flowQ")
biocLite("flowViz")
library(flowCore)
library(flowQ)
library(flowViz)

x<- read.FCS('', transformation="linearize", dataset = 1)

f1 = read.FCS('')
f2 = read.FCS('')
f3 = read.FCS('')
f4 = read.FCS('')

colnames(f1)# the channel labels
E = exprs(f1)#the expression values measured for each cell
dim(E)
E[1:10,]#Look at the first 10 rows (cells) of E
f1@description#Study all the 'keyword' information store in the file
f1@description$`TUBE NAME`#access each 'keyword' one at a time
f1@description$`$P14S`#here is the data for CD45
f1@parameters@data#Access parameter information such as range of expression values of FSC-A
f1@parameters@data[14, c("minRange", "maxRange")]#Range expression values for CD45

cd45.1 = f1@exprs[,14]#this is to acces data on V500-A where CD45 is.
ssca = f1@exprs[,4]
plot(ssca ~ cd45.1)
f2@parameters@data

kappa = f2@exprs[,7]#kappa
lambda = f2@exprs[,8]#lambda
cd19 = f2@exprs[,10]#cd19
cd79b = f2@exprs[,11]#cd79b
cd20 = f2@exprs[,12]#cd20
cd5 = f2@exprs[,13]#cd5?
cd45 = f2@exprs[,14]#cd45

fmc7 = f3@exprs[,7]
cd23 = f3@exprs[,8]
cd5.1 = f3@exprs[,9]
cd19.1 = f3@exprs[,10]
cd38 = f3@exprs[,11]
cd20.1 = f3@exprs[,13]

cd43 = f4@exprs[,7]
cd200 = f4@exprs[,8]
cd5.2 = f4@exprs[,9]
cd19.2 = f4@exprs[,10]
cd22 = f4@exprs[,11]
cd11c = f4@exprs[,13]

df2 = data.frame(kappa, lambda, cd19, cd79b, cd20, cd5)
df3 = data.frame(fmc7, cd23, cd5.1, cd19.1, cd38, cd20.1)
df4 = data.frame(cd43, cd200, cd5.2, cd19.2, cd22, cd11c)
plot(cd5 ~ lambda)
plot(cd5 ~ kappa)
coplot(lambda ~ kappa|cd5, panel = panel.smooth, df2)

install.packages("circlize")
library(circlize)

mat = as.matrix(sapply(df2, mean))

chordDiagram(mat)#, link.border = 1, text(-0.1, 0.1, "A", cex = 0.8))

circos.clear()
