setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

berlinstraßen <- st_read("edge_berlin3.csv", crs = 31468)
berlinstraßen$speed <- as.numeric(berlinstraßen$speed)
berlinstraßen$length <- as.numeric(berlinstraßen$length)

with_centrality_speed <- as_sfnetwork(berlinstraßen) %>%
  activate(edges) %>%
  mutate(centrality = centrality_edge_betweenness(weights = length/speed)) %>%
  filter(centrality > 50000000)

tm_shape(st_as_sf(with_centrality_speed, "edges")) + 
  tm_lines(col = "centrality", size = "centrality", scale = 3)