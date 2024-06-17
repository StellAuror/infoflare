### Load packages
# webshot::install_phantomjs()
pacman::p_load(
  "webshot",
  "magick"
)

### Look up sub-folder & .html names 
subfolders <- list.files()[1]
subfolders <- subfolders[grep("\\b\\d{4}-\\d{2}-\\d{2}\\b", subfolders)]

### Initialize markdown section
md_auto <- "## Gallery \n"

### Create .PNGs & the markdown section content
## for each sub-folder
lapply(subfolders, function(folder) {
  # search .HTMLs
  htmls <- list.files(folder, pattern = "\\.html")
  # initialize markdown subsection
  md_auto <<- glue::glue(md_auto, "\n ### ", folder)
  ## for each html file
  lapply(htmls, function(file) {
    # defining constants for the file
    len <- nchar(file) - 4
    inputFile <- paste0(folder, "/", file)
    outputFile <- paste0(folder, "/", substr(file, 1, len), "png")
    # convert .html to .png & embed the link
    webshot::webshot(inputFile, file = outputFile, selector = ".svglite", zoom = 2)
    md_auto <<- glue::glue(md_auto, "\n ![image](", outputFile, ")")
  })
  md_auto <<- glue::glue(md_auto, "\n")
})

### load the README constant
fileConn <- file("const.md")
md_const <- readLines(fileConn)
close(fileConn)

### Merge README constant and generated sections
fileConn <- file("README.md")
writeLines(glue::glue(paste0(md_const, collapse = "\n"), md_auto), fileConn)
close(fileConn)
