library(spdep)
library(tidyverse)

sq <- read.csv("/home/rstudio/work/data/nyc_squirrels.csv") |> 
  suppressMessages()

sq_filt <- sq %>% 
  filter(!is.na(primary_fur_color)) %>% 
  mutate(is_cinnamon = ifelse(primary_fur_color == "Cinnamon", 1, 0))

pts <- st_as_sf(data.frame(x=sq_filt$long, y=sq_filt$lat),
                coords=1:2)

pts$is_cinnamon <- factor(sq_filt$is_cinnamon)
nn <- knn2nb(knearneigh(pts, 10))
w <- nb2listw(nn, style="B")
spatial_corr <- joincount.test(pts$is_cinnamon, w)

cinnamon_spatial_corr_pval <- spatial_corr[[2]]$p.value
write(x = cinnamon_spatial_corr_pval,
      file = "/home/rstudio/work/derived_data/cinnamon_spatial_corr_pval.txt")
