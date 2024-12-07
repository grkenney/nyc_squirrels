library(tidyverse)
library(ggplot2)
library(patchwork)

sq <- read.csv("/home/rstudio/work/data/nyc_squirrels.csv") |> 
  suppressMessages()

weather <- read_csv("/home/rstudio/work/data/October2018_Weather.csv") %>% 
  suppressMessages() %>% 
  mutate(formatted_date = ifelse(nchar(as.character(Date)) == 1, 
                                 paste0("100", as.character(Date), "2018"), 
                                 paste0("10", as.character(Date), "2018"))) %>% 
  filter(formatted_date %in% as.character(unique(sq$date)))

sq_shifts_plt <- ggplot(sq, aes(x = as.factor(date), fill=shift)) +
  geom_bar(position="dodge") +
  theme_classic() +
  theme(axis.text.x=element_text(angle=45, hjust=1)) +
  scale_fill_manual(values=c("#eaa6a6", "#d54d4d"),
                    name = "Shifts",
                    labels = c("AM", "PM")) +
  ylab("# Squirrels Sighted") + xlab("Date")

weahter_plt <- ggplot(data = weather, aes(x = as.factor(formatted_date), y = Avg_Temp)) +
  geom_line(group = 1) +
  theme_classic() +
  ylab("Avg Temp (F)") +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(), 
        axis.ticks.x = element_blank())

shift_weather <- (weahter_plt / sq_shifts_plt) + plot_layout(heights = c(1, 3))

ggsave(filename = "/home/rstudio/work/figures/shift_weather.png", 
       plot = shift_weather, height = 5, width = 8)
