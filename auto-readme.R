### Load packages
# webshot::install_phantomjs()
pacman::p_load(
  "webshot",
  "magick"
)

### Look up sub-folder & .html names 
subfolders <- list.files()
subfolders <- subfolders[grep("\\b\\d{4}-\\d{2}-\\d{2}\\b", subfolders)]

### Initialize markdown section
md_auto <- "\n ## Gallery \n"

### Create .PNGs & the markdown section content
## for each sub-folder
lapply(subfolders, function(folder) {
  # Firstly find and manage the easy part
  otherGraphs <- c(
    list.files(folder, pattern = "\\.png"),
    list.files(folder, pattern = "\\.jpeg"),
    list.files(folder, pattern = "\\.jpg")
  )
  # initialize markdown subsection
  md_auto <<- glue::glue(md_auto, "\n <details><summary>", folder, "</summary>")
  
  # search .HTMLs 
  htmls <- list.files(folder, pattern = "\\.html")
  ## for each html file
  lapply(htmls, function(file) {
    # defining constants for the file
    len <- nchar(file) - 5
    inputFile <- file.path(folder, file)
    outputFile <- file.path(folder, paste0(substr(file, 1, len), ".png"))
    
    # Check if outputFile exists and is newer than inputFile
    if (!file.exists(outputFile) || file.info(outputFile)$mtime < file.info(inputFile)$mtime) {
      # convert .html to .png 
      result <- tryCatch({
        webshot(inputFile, file = outputFile, selector = ".svglite", zoom = 2)
        TRUE  
      }, error = function(e) {
        message("Screenshot with selector '.svglite' failed.")
        FALSE 
      })
      if (result) {
        message("Screenshot with selector '.svglite' succeeded.")
      }
    } else {
      message(paste("Skipping", outputFile, "- already up to date."))
    }
  })
  
  ## for each graphical file
  lapply(otherGraphs, function(file) {
    inputFile <- file.path(folder, file)
    md_auto <<- glue::glue(md_auto, '\n <img src="', inputFile, '">')
  })
  md_auto <<- glue::glue(md_auto, "\n </details>")
})

### load the README constant
fileConn <- file("const.md")
md_const <- readLines(fileConn)
close(fileConn)

### Merge README constant and generated sections
fileConn <- file("README.md")
writeLines(glue::glue(paste0(md_const, collapse = "\n"), md_auto), fileConn)
close(fileConn)
