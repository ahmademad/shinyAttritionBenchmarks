description <- read.csv("./data/description.csv", stringsAsFactors = FALSE)
data <- read.csv("./data/abs_benchmarktool_sourcedata_public.csv", stringsAsFactors = FALSE, sep="\t")

data$group1 <- sapply(strsplit(data$subgrp, "_"), "[", 1)
data$group2 <- sapply(strsplit(data$subgrp, "_"), "[", 2)
data$group3 <- sapply(strsplit(data$subgrp, "_"), "[", 3)
data$group4 <- "Elementary"
data$group4[data$period %in% c("10 to 12", "9 to 11")] <- "High School"

transitions <- unique(data$period)
overall <- unique(description$Meaning[description$Level == "Overall"])
school <- unique(description$Meaning[description$Level == "School"])
student <- unique(description$Meaning[description$Level == "Student"])

