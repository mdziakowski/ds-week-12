setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

unfaelle <- read.csv2("Unfaelle.csv")
unfaellepoint <- st_as_sf(unfaelle, coords = c("XGCSWGS84", "YGCSWGS84"), crs = 4326)
bezirke <- st_read("shp-bezirke/bezirke_berlin.shp")
bezirke <- st_transform(bezirke,crs =  4326)

unfaellepoint <- mutate(unfaellepoint, costs = if_else("UKATEGORIE"==1,1035165,if_else("UKATEGORIE"==2,110506,4403)) )

joined_data <- st_join(bezirke, unfaellepoint)

accident_summary <- joined_data %>%
  group_by(SCHLUESSEL) %>%
  summarize(num_accidents=sum(costs))

tm_shape(accident_summary) +
  tm_polygons(col = "num_accidents", title = "accident costs in millions per year") +
  tm_text("num_accidents", size = 0.9)

          