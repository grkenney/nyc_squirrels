suppressPackageStartupMessages({
  library(tidyverse)
  library(ggplot2)
})

sq <- read_csv("/home/rstudio/work/data/nyc_squirrels.csv") %>% 
  suppressMessages()

long_lat_plot <- ggplot(sq, aes(long, lat)) +
  geom_point() +
  theme_classic()

ggsave(filename = "/home/rstudio/work/figures/long_lat.png",
       long_lat_plot)
