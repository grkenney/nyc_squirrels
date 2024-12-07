library(tidyverse)
library(ggplot2)
library(patchwork)

sq <- read.csv("/home/rstudio/work/data/nyc_squirrels.csv") |> 
  suppressMessages()

behavior_df <- sq %>% 
  select(approaches, indifferent, tail_twitches, tail_flags, runs_from) %>% 
  mutate(tail_movement = ifelse(tail_flags | tail_twitches, "Yes", "No")) %>% 
  mutate(approaches = ifelse(approaches, "approaches", ""),
         indifferent = ifelse(indifferent, "indifferent", ""),
         tail_twitches = ifelse(tail_twitches, "twitch", ""),
         tail_flags = ifelse(tail_flags, "flag", ""),
         runs_from = ifelse(runs_from, "runs", "")) %>% 
  unite(tail_movement_type, c("tail_twitches", "tail_flags"), sep = "") %>% 
  unite(behavior, c("approaches", "indifferent", "runs_from"), sep = "") %>% 
  filter(behavior %in% c("approaches", "indifferent", "runs"), 
         tail_movement_type != "twitchflag")

behavior_df$behavior <- factor(behavior_df$behavior,
                               levels=c("approaches", "runs", "indifferent"))

dodged_bar <- behavior_df %>%
  ggplot(aes(x = tail_movement, fill = behavior)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values=c("#f5d3d3", "#e59090", "#d54d4d"),
                    name = "Behavior",
                    labels = c("Approaches", "Indifferent", "Runs")) +
  xlab("Tail Movement") + ylab("# Squirrels") +
  theme_classic() +
  theme(legend.position = "bottom")

# Most squirrels run regardless of tail movement

stacked_bar <- behavior_df %>% 
  filter(tail_movement == "Yes") %>% 
  ggplot(aes(x = behavior, fill = tail_movement_type)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values=c("#eaa6a6", "#d54d4d"),
                    name = "Tail Movement",
                    labels = c("Flag", "Twitch")) +
  scale_x_discrete(labels = c("Approaches", "Runs", "Indifferent")) +
  theme_classic() +
  theme(legend.position = "bottom") +
  xlab("Behavior") + ylab("Proportion")

# Approaching squirrels twitch their tails more than squirrels that run or are indifferent

patched_plot <- (dodged_bar | stacked_bar) +
  plot_annotation(tag_levels = 'A')

ggsave(filename = "/home/rstudio/work/figures/tail_behavior_bar.png", 
       plot = patched_plot, height = 3, width = 8)
