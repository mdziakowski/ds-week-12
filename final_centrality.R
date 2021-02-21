setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

berlinstraﬂen <- st_read("edge_berlin3.csv", crs = 31468)

with_centrality <- as_sfnetwork(berlinstraﬂen) %>%
  activate(edges) %>%
  mutate(centrality = centrality_edge_betweenness()) %>%
  filter(centrality > 20000000)

tm_shape(st_as_sf(with_centrality, "edges")) + 
  tm_lines(col = "centrality", size = "centrality", scale = 3)
