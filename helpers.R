description <- read.csv("./data/description.csv", stringsAsFactors = FALSE)
data <- read.csv("./data/abs_benchmarktool_sourcedata_public.csv", stringsAsFactors = FALSE, sep="\t")
description[,c("Notation", "Level", "Meaning")] <- 
  sapply(description[,c("Notation", "Level", "Meaning")], trimws)

data$interType <- sapply(strsplit(data$subgrp, "_"), "[", 1)
data$group1 <- sapply(strsplit(data$subgrp, "_"), "[", 2)
data$group2 <- sapply(strsplit(data$subgrp, "_"), "[", 3)
data$group3 <- "Elementary"
data$group3[data$period %in% c("10 to 12", "9 to 11")] <- "High School"

data[,c("period", "subgrp", "interType", "group1", "group2", "group3")] <- 
      sapply(data[,c("period", "subgrp", "interType", "group1", "group2", "group3")], trimws)
transitions <- unique(data$period)

meaning <- function(g1, type) {
  temp1 <- description[description$Type == type & description$Level == g1,c("Notation", "Meaning")]
  temp1 <- unique(temp1)
  temp1 <- temp1[order(temp1$Notation), ]
  meanings1 <- temp1[,"Meaning"]
  names(meanings1) <- temp1[,"Notation"]
  meanings1
}

interaction <- function(interType) {
  if(interType == "school-by-student interaction") {
    gr1 <- "s1"
    g1 <- "School"
    g2 <- "Student"
  }
  if(interType == "student-by-student interaction") {
    gr1 <- "s3"
    g1 <- "Student"
    g2 <- "Student"
  }
  if(interType == "school-by-school interaction") {
    gr1 <- "s2"
    g1 <- "School"
    g2 <- "School"
  }
  c(gr1, g1, g2)
}

transition <- function(transitionPeriod) {
  if(transitionPeriod %in% c("10 to 12", "9 to 11")) {
    type <- "High School"
  }
  else {
    type <- "Elementary"
  }
  type
}