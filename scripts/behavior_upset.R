library(ggupset)
library(tidyverse)
library(ggplot2)

sq <- read.csv("data/nyc_squirrels.csv") %>% 
  suppressMessages()

behavior_cols <- c("kuks", "quaas", "moans",
                   "tail_flags", "tail_twitches")

behavior_df <- sq %>% select(all_of(behavior_cols)) %>% 
  mutate(behavior = pmap(across(where(is.logical)), 
                         ~ names(c(...))[which(c(...))]))

behavior_upset <- ggplot(behavior_df, aes(x=behavior)) +
  geom_bar() +
  geom_text(stat='count', aes(label=after_stat(count)), vjust=-1, size=3) +
  scale_x_upset(n_intersections = 20) +
  xlab("Behaviors") + ylab("Counts") +
  ylim(c(0, 2500)) +
  theme_classic()

ggsave(filename = "/home/rstudio/work/figures/behavior_upset.png",
       behavior_upset, height = 4, width = 6)
