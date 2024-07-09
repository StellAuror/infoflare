### parameters
title <- "HighSchoolExamPL"
createRMD <- TRUE
createQMD <- FALSE
createR <- FALSE
daysAhead <- 0

### actual script
dir <- as.character(Sys.Date() + daysAhead)

if (!dir.exists(dir)) {
  dir.create(dir)
}

create_file <- function(extension, condition) {
  file <- file.path(dir, paste0(title, extension))
  if (condition && !file.exists(file)) {
    file.create(file)
  }
}

create_file(".Rmd", createRMD)
create_file(".Qmd", createQMD)
create_file(".R", createR)

