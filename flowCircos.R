library(flowCore)
library(psych)
library(circlize)

# Functions

dichotomize <- function(channels, cutoffs){
  markers <- names(channels)
  binary_matrix <- list() 
  for (i in 1:length(channels)){
    binary_matrix[[markers[[i]]]] <- 1 * sapply(channels[[i]], function(x) x > cutoffs[i])
    binary_matrix[[markers[[i]]]][binary_matrix[[markers[[i]]]] == 0] <- NA
  }
  return(binary_matrix)
}


# User input
flow_file <- read.FCS("flowdata/Blo CLL Lo_02 K-L-_-19-79b-20-5BV-45-_-__002.fcs", 'linearize')
flow_file <- read.FCS("flowdata/", 'linearize')

cutoffs <- c(2500, 2500, 2500, 2500)

flow_file@description


channels <- list(CD20=flow_file@exprs[,10],
                 CD19=flow_file@exprs[,13],
                 CD45=flow_file@exprs[,14], 
                 CD79b=flow_file@exprs[,11]) 

# Get data matrix
bm <- dichotomize(channels, cutoffs)
bm <- as.matrix(as.data.frame(bm))

# Pairwise count 
bm_cnt <- count.pairwise(bm, diagonal=FALSE)
bm_cnt[lower.tri(bm_cnt)] <- NA

# Create plot
circos.clear()
chordDiagram(bm_cnt)

