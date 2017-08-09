# CRAN Pacakges
# install_pak function: install and load multiple R packages.
install_pak <- function(pkg){
  new_pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new_pkg)) {
    install.packages(new_pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
  }
}

packages <- c("circlize")
install_pak(packages)


# BIOCONDUCTOR packages
source("https://bioconductor.org/biocLite.R")
biocLite()
biocLite(pkgs=c("flowCore", "flowQ", "flowViz"))
