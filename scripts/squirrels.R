suppressPackageStartupMessages({
  library(tidyverse)
  library(ggplot2)
  library(mapview)
})

sq <- read_csv(here::here("data/nyc_squirrels.csv")) %>% 
  suppressMessages()

colnames(sq)

ggplot(sq, aes(long, lat)) +
  geom_point() +
  theme_classic()

mapviewOptions(vector.palette = c("#C17F69", "#77B8DA"))
mapview(sq, xcol = "long", ycol = "lat", crs = 4269, grid = FALSE,
        zcol = "shift", alpha = 1, cex=2)

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

ggplot(sq, aes(primary_fur_color)) +
  geom_bar(stat="count") +
  theme_classic()

ggplot(sq, aes(location)) +
  geom_bar(stat="count") +
  theme_classic()

mapviewOptions(vector.palette = c("#7DC1DA", "#6E9471"))
mapview(sq, xcol = "long", ycol = "lat", crs = 4269, grid = FALSE,
        zcol = "location", alpha = 1, cex=2)


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

mapviewOptions(vector.palette = c("green", "blue", "hotpink", "grey"))
mapview(sq, xcol = "long", ycol = "lat", crs = 4269, grid = FALSE,
        zcol = "tail_movement", alpha = 1, cex=2)

ggplot(sq, aes(x = tail_movement)) +
  geom_bar(stat="count", fill = c("green", "blue", "hotpink", "grey")) +
  theme_classic()
  
