library(tidyverse)
library(ggplot2)

sq <- read.csv("/home/rstudio/work/data/nyc_squirrels.csv") |> 
  suppressMessages()

samp_sizes <- paste0("n=", table(sq$eating))

plt <- sq %>% 
  dplyr::filter(!is.na(location)) %>% 
  ggplot(aes(x = eating, fill=location)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  annotate("text", x = 1, y = 1.05, label = samp_sizes[1]) +
  annotate("text", x = 2, y = 1.05, label = samp_sizes[2]) +
  theme_classic() +
  xlab("Eating") + ylab("Proportion") +
  scale_fill_discrete(name = "Location") +
  scale_fill_manual(values=c("#eaa6a6", "#d54d4d"))

ggsave(filename = "/home/rstudio/work/figures/eating_location_bar.png", 
       plot = plt, height = 3, width = 8)
