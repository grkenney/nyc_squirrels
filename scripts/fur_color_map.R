library(leaflet)
library(tidyverse)

sq <- read.csv("/home/rstudio/work/data/nyc_squirrels.csv") |> 
  suppressMessages() %>% 
  mutate(sq_col = primary_fur_color)

sq$sq_col <- gsub(pattern = "Cinnamon",
                             replacement = "#e08409", 
                             sq$primary_fur_color)
sq$sq_hlght <- replace_na(sq$highlight_fur_color, "None")


# Create a leaflet map
fur_col_map <- leaflet(leafletOptions(minZoom = 14)) |>
  addTiles() |>
  setView(lat = 40.7827252711707, lng = -73.96549757266935, zoom = 14) |>
  addProviderTiles("CartoDB.Voyager") |>
  addCircleMarkers(
    data = sq,
    lng = ~long,
    lat = ~lat,
    radius = 1,
    color = sq$sq_col,
    fillOpacity = 0.5,
    label = paste("Highlight: ", sq$sq_hlght)) |>
  addLegend("bottomright", 
            colors = c("Black",  "#e08409", "Grey"),
            labels = c("Black", "Cinnamon", "Grey"),
            title = "Fur Colors",
            opacity = 1)

save(fur_col_map, file = "/home/rstudio/work/derived_data/fur_color_map.rda")
