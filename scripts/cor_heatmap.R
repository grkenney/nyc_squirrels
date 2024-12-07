library(corrr)
library(corrplot)
library(tidyverse)

sq <- read.csv("data/nyc_squirrels.csv") %>% 
  suppressMessages()

behavior_cols <- c("running", "chasing", "climbing", "eating", "foraging",
                   "kuks", "quaas", "moans", "tail_flags", "tail_twitches",
                   "approaches", "indifferent", "runs_from")

cor_mtx <- sq[, behavior_cols] %>%
  lapply(as.numeric) %>% 
  as.data.frame() %>% 
  correlate()

cor_mtx <- cor_mtx %>% 
  column_to_rownames("term") %>% 
  as.matrix() %>% 
  replace(is.na(.), 1)

png(height=1500, width=1500, file="figures/cor_heatmap.png")
corrplot(cor_mtx, 
         type="upper", 
         method="color", 
         tl.col="black", 
         col = rev(COL2('BrBG', 200)),
         addCoef.col = "black", 
         number.cex = 2,
         cl.cex = 2.5,
         tl.cex = 2.5,
         tl.srt=45, 
         diag=FALSE)
dev.off()

