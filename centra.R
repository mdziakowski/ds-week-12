setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

bezirke <- st_read("bezirke/bezirksgrenzen.shp")
bezirke <- st_transform(bezirke,crs =  4326)

mittesf <- st_read("edge_berlin3.csv", crs = 31468)
mittesf$count <- as.numeric(mittesf$count)
mittesf$cap <- as.numeric(mittesf$cap)
mittesf$speed <- as.numeric(mittesf$speed)
mittesf$length <- as.numeric(mittesf$length)

berlinstraﬂen <- mittesf %>%
  filter(cap > 1200.0)

berlinstraﬂen <- mittesf
tmap_mode("view")

tm_shape(berlinstraﬂen_count) +
  tm_lines(col = "count", scale = 3)


bezirke <- st_read("berlin/BerlinBrandenburg.shp")
tm_shape(bezirke) +
  tm_polygons()

berlinstraﬂen

  
berlinstraﬂen_count <- filter(berlinstraﬂen, count > 20000)

st_write(bezirke, paste0(tempdir(), "/", "berlin.shp"))


with_centrality <- as_sfnetwork(berlinstraﬂen) %>%
  activate(edges) %>%
  mutate(centrality = centrality_edge_betweenness()) %>%
  filter(centrality > 20000000)


tm_shape(st_as_sf(with_centrality, "edges")) + 
  tm_lines(col = "centrality", size = "centrality", scale = 3)

#tmap_options(basemaps = 'OpenStreetMap')

unfaelle <- read.csv2("Unfaelle.csv")
unfaellepoint <- st_as_sf(unfaelle, coords = c("XGCSWGS84", "YGCSWGS84"), crs = 4326)
unfaellepoint <- st_transform(unfaellepoint, crs = 31468)
unfaellepoint <- select(unfaellepoint, "geometry")
write.csv2(unfaellepoint, paste0(tempdir(), "/", "unfall.csv"))


acc <- read.csv("acc.csv")

berlinstraﬂen$id <- as.numeric(berlinstraﬂen$id)
berlinstraﬂen_acc <- left_join(berlinstraﬂen, acc, by = "id")
#berlinstraﬂen_acc$acc <- replace_na(berlinstraﬂen_acc$acc,0)
berlinstraﬂen_acc <- filter(berlinstraﬂen_acc, !is.na(acc))
berlinstraﬂen_acc
tm_shape(berlinstraﬂen_acc) + 
  tm_lines(col = "acc", scale = 5)

berlinstraﬂen

with_centrality_speed <- as_sfnetwork(berlinstraﬂen) %>%
  activate(edges) %>%
  mutate(centrality = centrality_edge_betweenness(weights = length/speed)) %>%
  filter(centrality > 50000000)

tmap_options(basemaps = NULL )

tm_shape(st_as_sf(with_centrality_speed, "edges")) + 
  tm_lines(col = "centrality", size = "centrality", scale = 3)

