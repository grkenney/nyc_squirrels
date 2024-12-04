library(ggupset)
library(tidyverse)
library(ggplot2)

sq <- read.csv("data/nyc_squirrels.csv") %>% 
  suppressMessages()

activity_cols <- c("running", "chasing", "climbing", "eating", "foraging")

activity_df <- sq %>% select(activity_cols) %>% 
  mutate(activity = pmap(across(where(is.logical)), 
                         ~ names(c(...))[which(c(...))]))

activity_upset <- ggplot(activity_df, aes(x=activity)) +
  geom_bar() +
  geom_text(stat='count', aes(label=after_stat(count)), vjust=-1, size=3) +
  scale_x_upset(n_intersections = 20) +
  xlab("Activities") + ylab("Counts") +
  ylim(c(0, 1000)) +
  theme_classic()

ggsave(filename = "figures/activity_upset.png",
       activity_upset, height = 4, width = 6)
