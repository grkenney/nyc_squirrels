library(ggupset)
library(tidyverse)
library(ggplot2)
library(patchwork)
library(ggupset)

sq <- read.csv("data/nyc_squirrels.csv") %>% 
  suppressMessages()

activity_cols <- c("running", "chasing", "climbing", "eating", "foraging")

activity_df <- sq %>% select(activity_cols) %>% 
  mutate(activity = pmap(across(where(is.logical)), 
                         ~ names(c(...))[which(c(...))]))

activity_upset <- ggplot(activity_df, aes(x=activity)) +
  geom_bar() +
  geom_text(stat='count', aes(label=after_stat(count)), vjust=-1, size=2.8) +
  scale_x_upset(n_intersections = 20) +
  xlab("Activities") + ylab("Counts") +
  ylim(c(0, 1000)) +
  theme_classic()

behavior_cols <- c("kuks", "quaas", "moans",
                   "tail_flags", "tail_twitches")

behavior_df <- sq %>% select(all_of(behavior_cols)) %>% 
  mutate(behavior = pmap(across(where(is.logical)), 
                         ~ names(c(...))[which(c(...))]))

behavior_upset <- ggplot(behavior_df, aes(x=behavior)) +
  geom_bar() +
  geom_text(stat='count', aes(label=after_stat(count)), vjust=-1, size=2.8) +
  scale_x_upset(n_intersections = 20) +
  xlab("Behaviors") + ylab("Counts") +
  ylim(c(0, 2600)) +
  theme_classic()

patched_plt <- (activity_upset | behavior_upset) +
  plot_annotation(tag_levels = 'A')

ggsave(filename = "/home/rstudio/work/figures/behavior_upset.png",
       patched_plt, height = 3, width = 10)
