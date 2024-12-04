library(tidyverse)
library(ggplot2)

sq <- read.csv("/home/rstudio/work/data/nyc_squirrels.csv") |> 
  suppressMessages()

behavior_df <- sq %>% 
  select(approaches, indifferent, tail_twitches, tail_flags) %>% 
  mutate(approaches = ifelse(approaches, "approaches", ""),
         indifferent = ifelse(indifferent, "indifferent", ""),
         tail_twitches = ifelse(tail_twitches, "twitch", ""),
         tail_flags = ifelse(tail_flags, "flag", "")) %>% 
  unite(tail_movement, c("tail_twitches", "tail_flags"), sep = "") %>% 
  unite(behavior, c("approaches", "indifferent"), sep = "") %>% 
  filter(behavior != "", tail_movement != "", 
         behavior != "approachesindifferent", tail_movement != "twitchflag")

samp_sizes <- paste0("n=", table(behavior_df$behavior))

tail_plot <- behavior_df %>% 
  ggplot(aes(x = behavior, fill=tail_movement)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  theme_classic() +
  annotate("text", x = 1, y = 1.05, label = samp_sizes[1]) +
  annotate("text", x = 2, y = 1.05, label = samp_sizes[2]) +
  xlab("Behavior") + ylab("Proportion") +
  scale_fill_discrete(name = "Tail Movement", labels = c("Flag", "Twitch")) +
  scale_x_discrete(labels = c("Approaches", "Indifferent")) +
  scale_fill_manual(values=c("#ebadad", "#b45454"))

ggsave(filename = "/home/rstudio/work/figures/tail_behavior_bar.png", 
       plot = tail_plot, height = 3, width = 8)