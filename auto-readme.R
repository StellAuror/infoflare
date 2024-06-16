# webshot::install_phantomjs()
pacman::p_load(
  "webshot",
  "magick"
)
subfolder <- list.files()[1]
html <- list.files(list.files()[1], pattern = "\\.html")[1]

webshot::webshot(paste0(subfolder, "/", html), file = "test.png")


md_const <- glue::glue("
                      # InfoFlare

                      ## Description
                      
                      A collection of source codes for the Info Flare project run on the x.com platform. The aim of the project is to share interesting insights based on reliable sources of information.
                      
                      ## Structure
                      
                      Folders are named by the creation (or the latest modification) date. Each folder contains a collection of visualizations (mostly .svg outputs saved as .html) and the source code (.qmd).

                       ")

md_auto <- glue::glue(
  "
  ## Gallery
  
  ![image](test.png)
  "
)

fileConn <- file("output.md")
writeLines(glue::glue(md_const, md_auto), fileConn)
close(fileConn)
