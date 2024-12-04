suppressPackageStartupMessages({
  library(tidyverse)
  library(ggplot2)
})

sq <- read_csv("/home/rstudio/work/data/nyc_squirrels.csv") %>% 
  suppressMessages()

colnames(sq)

ggplot(sq, aes(long, lat)) +
  geom_point() +
  theme_classic()

# squirrel activities
activities <- c("running", "chasing", "climbing", "eating", "foraging")
activity_counts <- sq[, activities] %>% 
  colSums() %>% 
  sort(decreasing = T) %>% 
  as.data.frame() %>% 
  rownames_to_column("activity")

colnames(activity_counts) <- c("activity", "count")

activity_counts$activity <- factor(activity_counts$activity, 
                                   levels = activity_counts$activity)

ggplot(activity_counts, aes(x = activity, y = count)) +
  geom_col() +
  theme_classic()

activity_df <- sq %>% select(activities) %>% 
  mutate(activity = pmap(across(where(is.logical)), 
                         ~ names(c(...))[which(c(...))]))

library(ggupset)
ggplot(activity_df, aes(x=activity)) +
  geom_bar() +
  geom_text(stat='count', aes(label=after_stat(count)), vjust=-1) +
  scale_x_upset(n_intersections = 20) +
  theme_classic()

ggplot(sq, aes(primary_fur_color)) +
  geom_bar(stat="count") +
  theme_classic()

ggplot(sq, aes(location)) +
  geom_bar(stat="count") +
  theme_classic()


tail_cols <- c("tail_flags", "tail_twitches")
tail_movement <- sq[, tail_cols] %>% 
  colSums() %>% 
  sort(decreasing = T) %>% 
  as.data.frame() %>% 
  rownames_to_column("movement")

colnames(tail_movement) <- c("movement", "count")

tail_movement$movement <- factor(tail_movement$movement, 
                                 levels = tail_movement$movement)

ggplot(tail_movement, aes(x = movement, y = count)) +
  geom_col() +
  theme_classic()

sq$tail_movement <- NA
for (i in 1:nrow(sq)) {
  if (sq$tail_flags[i] & sq$tail_twitches[i]){
    sq$tail_movement[i] <- "Both"
  } else if (sq$tail_flags[i]) {
    sq$tail_movement[i] <- "Flag"
  } else if (sq$tail_twitches[i]) {
    sq$tail_movement[i] <- "Twitch"
  } else {
    sq$tail_movement[i] <- "Neither"
  }
}

sq$tail_movement <- factor(sq$tail_movement, 
                           levels = c("Flag", "Twitch", "Both", "Neither"))

ggplot(sq, aes(x = tail_movement)) +
  geom_bar(stat="count", fill = c("green", "blue", "hotpink", "grey")) +
  theme_classic()


pca_colnames <- c("running", "chasing", "climbing", "eating", "foraging",
                  "kuks", "quaas", "moans", "tail_flags", "tail_twitches",
                  "approaches", "indifferent", "runs_from")
pca_df <- lapply(sq[, pca_colnames], as.numeric) %>% as.data.frame()
pc <- prcomp(pca_df)

ggplot(data.frame(pc$x), aes(x = PC1, y = PC2)) + geom_point()

clusters <- kmeans(pca_df, centers = 2)

clustered_df <- cbind(sq, pc$x)
clustered_df$cluters <- as.factor(clusters$cluster)

ggplot(clustered_df, aes(x = PC1, y = PC2, col=indifferent)) + 
  geom_point()

sq$clus <- as.factor(clusters$cluster)

ggplot(sq, aes(long, lat, col = clus)) +
  geom_point() +
  theme_classic()

sq <- sq %>% 
  mutate(eating_col = ifelse(eating, "red", "grey"))

sq <- sq %>% 
  mutate(indifferent_col = ifelse(indifferent, "red", "grey"))

# map views
library(leaflet)

# Create a leaflet map
my_map <- leaflet() |>
  addTiles() |>
  setView(lat = 40.7827252711707, lng = -73.96549757266935, zoom = 14) |>
  addProviderTiles("CartoDB.Voyager") |>
  addCircleMarkers(
    data = sq,
    lng = ~long,
    lat = ~lat,
    radius = 1, color = "#461220",
    fillOpacity = 0.5)

# Display the map
my_map

library(htmlwidgets)
library(webshot2)

saveWidget(my_map, "temp.html", selfcontained = FALSE)
webshot2::webshot("temp.html", 
                  file="figures/sq_map.png", 
                  cliprect="viewport")

library(corrr)

cor_mtx <- sq[, pca_colnames] %>%
  lapply(as.numeric) %>% 
  as.data.frame() %>% 
  correlate()
cor_mtx <- cor_mtx %>% 
  column_to_rownames("term") %>% 
  as.matrix() %>% 
  replace(is.na(.), 1)

library(corrplot)

corrplot(cor_mtx, 
         type="upper", 
         method="color", 
         tl.col=c(rep("#857885", 4), rep("#461220", 4), rep("#857885", 2), rep("#461220", 2)), 
         col = rev(COL2('BrBG', 200)),
         addCoef.col = "black", 
         number.cex = 0.6,
         tl.srt=45, 
         diag=FALSE)
text(1, 1, "labels")


