library(leaflet)

sq <- read.csv("/home/rstudio/work/data/nyc_squirrels.csv") |> 
  suppressMessages()

# Create a leaflet map
my_map <- leaflet(leafletOptions(minZoom = 14)) |>
  addTiles() |>
  setView(lat = 40.7827252711707, lng = -73.96549757266935, zoom = 14) |>
  addProviderTiles("CartoDB.Voyager") |>
  addCircleMarkers(
    data = sq,
    lng = ~long,
    lat = ~lat,
    radius = 1, color = "#d54d4d",
    fillOpacity = 0.5)

save(my_map, file = "/home/rstudio/work/derived_data/sq_map.rda")
