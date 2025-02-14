setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

tmap_mode("view")

berlinstraßen <- st_read("edge_berlin3.csv", crs = 31468)

with_centrality <- as_sfnetwork(berlinstraßen2) %>%
  activate(edges) %>%
  mutate(centrality = centrality_edge_betweenness()) %>%
  filter(centrality > 20000000)

tm_shape(st_as_sf(with_centrality, "edges")) + 
  tm_lines(col = "centrality", size = "centrality", scale = 3, style = "sd")


berlinstraßen

berlinstraßen <- mutate(berlinstraßen, lange = st_length(berlinstraßen))
berlinstraßen$lange <- as.numeric(berlinstraßen$lange)
berlinstraßen$length <- as.numeric(berlinstraßen$length)
b <- mutate(berlinstraßen, d = length - lange)
b <- select(b,d)
b <- filter(b, d > 1 || d < -1)

berlinstraßen2 <- select(berlinstraßen, id, from, to, x, y, wkt, geometry)
berlinstraßen2
