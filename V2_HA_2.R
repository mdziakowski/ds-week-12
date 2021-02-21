setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

tmap_mode("view")

bezirke <- st_read("bezirke/bezirksgrenzen.shp")
unfaelle <- read.csv2("Unfaelle.csv")
unfaellepoint <- st_as_sf(unfaelle, coords = c("XGCSWGS84", "YGCSWGS84"), crs = 4326)
unfaellepoint <- select(unfaellepoint, geometry)
unfaellepoint <- st_join(unfaellepoint, bezirke, join = st_within)
unfaellepoint <- na.omit(unfaellepoint)

joined <- st_join(bezirke,unfaellepoint)
joined <- joined %>%
  group_by("Gemeinde_n") %>%
  summarise(count = n())

tm_shape(joined)+
  tm_polygons(col = "count") 
