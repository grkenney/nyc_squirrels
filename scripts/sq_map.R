library(leaflet)

sq <- read.csv("/home/rstudio/work/data/nyc_squirrels.csv") |> 
  suppressMessages()

# Create a leaflet map
my_map <- leaflet() %>% 
  addTiles(options = providerTileOptions(minZoom = 10, maxZoom = 25)) %>%
  setView(lat = 40.7827252711707, lng = -73.96549757266935, zoom = 14) %>% 
  addProviderTiles("CartoDB.Voyager", 
                   options = providerTileOptions(minZoom = 10, maxZoom = 25)) %>% 
  addCircleMarkers(
    data = sq,
    lng = ~long,
    lat = ~lat,
    radius = 1, color = "#d54d4d",
    fillOpacity = 0.5,
    clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = F)) %>% 
  addEasyButton(easyButton(
    states = list(
      easyButtonState(
        stateName="unfrozen-markers",
        icon="ion-toggle",
        title="Freeze Clusters",
        onClick = JS("
          function(btn, map) {
            var clusterManager =
              map.layerManager.getLayer('cluster', 'quakesCluster');
            clusterManager.freezeAtZoom();
            btn.state('frozen-markers');
          }")
      ),
      easyButtonState(
        stateName="frozen-markers",
        icon="ion-toggle-filled",
        title="UnFreeze Clusters",
        onClick = JS("
          function(btn, map) {
            var clusterManager =
              map.layerManager.getLayer('cluster', 'quakesCluster');
            clusterManager.unfreeze();
            btn.state('unfrozen-markers');
          }")
      )
    )))


save(my_map, file = "/home/rstudio/work/derived_data/sq_map.rda")
