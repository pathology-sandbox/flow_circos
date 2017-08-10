library(flowCore)
library(stringr)
library(psych)
library(circlize)

# Functions

dichotomize <- function(channels, cutoffs){
  mrkrs <- colnames(channels)
  bin_mat <- list() 
  for (i in 1:dim(channels)[2]) {
    bin_mat[[mrkrs[i]]] <- 1 * sapply(channels[,i], function(x) x > cutoffs[i])
    bin_mat[[mrkrs[i]]][bin_mat[[mrkrs[i]]] == 0] <- NA
  }
  return(bin_mat)
}

# User input
flow_file <- read.FCS("flowdata/", 'linearize')

# Capture mrkrs
capture_vector <- c("KAPPA", "LAMBDA", "CD19", "CD79b", 
                    "CD20", "CD5 BV 421", "CD45")
channel_labels <- flow_file@parameters[[2]]
index_labels <- list()
indeces <- list()
marker_index <- 1
for (i in 1:length(channel_labels)) {
  pattern <- paste(".*", channel_labels[i], ".*", sep = "")
  capture_vector_index <- which(str_detect(pattern, capture_vector))
  if (length(capture_vector_index) > 0) {
    index_labels[[marker_index]] <- capture_vector[[capture_vector_index]]
    indeces[[marker_index]] <- i
    marker_index <- marker_index + 1
  }
}

df <- sapply(indeces, function(x) flow_file@exprs[,x])
colnames(df) <- index_labels

channels<-as.list.data.frame(df)

cutoffs <- c(2500, 2500, 2500, 2500, 2500, 2500, 2500)

# Get data matrix
bm <- dichotomize(channels, cutoffs)
bm <- as.matrix(as.data.frame(bm))

# Pairwise count 
bm_cnt <- count.pairwise(bm, diagonal=FALSE)
bm_cnt[lower.tri(bm_cnt)] <- NA

# Create plot
circos.clear()
chordDiagram(bm_cnt)

