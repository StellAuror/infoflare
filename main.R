###### LIBRARIES ###### 
pacman::p_load(
  # World Bank Open Data 
  "wbstats",
  # Data Manipulation
  "tidyverse",
  # Fonts for charts
  "extrafont",
  # .svg device
  "svglite",
  # mardkwon elements
  "ggtext",
  # strip conditional formatting
  "ggh4x",
  # weather
  "openmeteo",
  # Countrries, contients, capitols
  "r2country",
  # color palette
  "paletteer",
  # Side by side polots
  "patchwork",
  # OMG
  "ggforce",
  "gghighlight",
  "ggridges",
  # Manual Font Addition
  "showtext"
)

# Load Fonts
# loadfonts()

# Check avaiable fonts
# fonts()

# Add font
#font_add("Proxima Nova", "2024-09-06/ProximaNova-Light.ttf")
#font_add("Proxima Nova Bold", "2024-09-06/ProximaNova-Bold.ttf")

###### GGPLOT THEME ###### 
setTheme <- function(family = "Segoe UI") {
  theme_set(theme_minimal(base_family = family))
  theme_update(
    panel.grid.minor = element_line(size = 0.25),
    panel.grid.major = element_line(size = 0.75),
    plot.title = element_text(face = "bold", size = 22),
    plot.subtitle = element_text(size = 16),
    text = element_text(color = "#5d524b", family = family, size = 18),
    panel.background = element_rect(fill = '#fff9f5', color = '#fff9f5'),
    plot.background = element_rect(fill = '#fff9f5', color = '#fff9f5'),
    panel.grid = element_line(color = "#f3ede9"),
    axis.text.x = element_text(angle = 90, color = "#9b928c"),
    axis.title = element_text(face = "bold", size = 15),
    axis.title.y = element_text(vjust = +2),
    axis.title.x = element_text(vjust = -0.75),
    
  )
  ggplot_color <- scale_color_manual(values = c("#0274BD", "#C4AD9D", "#000000", "#F57251"))
  ggplot_fill <- scale_fill_manual(values = c("#0274BD", "#C4AD9D", "#000000", "#F57251"))
  
}



asSVG <- function(chart, width = 16, height = 9, scaling = 1, save = F, name = "") {
  s <- svgstring(width, height, scaling = scaling)  # Start the SVG device
  print(chart)          # Print the ggplot object to the SVG device
  svg_content <- s()    # Capture the SVG content
  invisible(dev.off())  # Close the SVG device
  if (save) htmltools::save_html(htmltools::HTML(svg_content), name)
  htmltools::HTML(svg_content)  # Return the SVG content as HTML
}
