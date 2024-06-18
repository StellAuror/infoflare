library(rvest)
library(tidyverse)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

options(timeout = 300)
url <- "https://geodata-eu-central-1-kontur-public.s3.amazonaws.com/kontur_datasets/kontur_population_PL_20231101.gpkg.gz"
filename <- paste0("2024-06-18", basename(url))

if (!file.exists(filename)) {
  download.file(
    url = url,
    destfile = filename,
    mode = "wb"
  )
}

if (!file.exists(sub(".gz", "", filename))) {
  R.utils::gunzip(
    filename,
    remove = T
  )
}

pop_df <- 
  sf::st_read(
    dsn = gsub(
      pattern = ".gz",
      replacement = "",
      x = filename
    )
  ) %>%
  sf::st_transform(
    crs = "EPSG:4326"
  )

pal <- scales::col_quantile(
  "magma", reverse = T,
  pop_df$population,
  n = 6
)

pop_df$color <- pal(
  pop_df$population
)

properties <- list(
  stroked = T,
  filled = T,
  extruded = T,
  wireframe = F,
  elevationScale = 1,
  getFillColor = ~color,
  getLineColor = ~color,
  getElevation = ~population,
  getPolygon = deckgl::JS(
    "d => d.geom.coordinates"
  ),
  tooltip = "Population: {{population}}",
  opacity = .25
)

mao <- deckgl::deckgl(
  latitude = 51.9194,
  longitude = 19.1451,
  zoom = 6, pitch = 45
) %>%
  deckgl::add_polygon_layer(
    data = pop_df,
    properties = properties
  ) %>%
  deckgl::add_basemap(
    deckgl::use_carto_style(theme = "positron")
  )

htmlwidgets::saveWidget(
  mao, file = "map.html",
  selfcontained = F, 
)

### Change Widget Class \\ auto-readme generator req.
html_content <- readLines("2024-06-18/map.html")

html_content <- gsub(
  pattern = '<div id=htmlwidget_container>',
  replacement = '<div class="svglite" id=htmlwidget_container>',
  x = html_content,
  fixed = TRUE
)

writeLines(html_content, "2024-06-18/map.html")
