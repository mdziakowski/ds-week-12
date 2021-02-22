setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

tmap_mode("view")

berlinstraﬂen <- st_read("edge_berlin3.csv", crs = 31468)

with_centrality <- as_sfnetwork(berlinstraﬂen2) %>%
  activate(edges) %>%
  mutate(centrality = centrality_edge_betweenness()) %>%
  filter(centrality > 20000000)

tm_shape(st_as_sf(with_centrality, "edges")) + 
  tm_lines(col = "centrality", size = "centrality", scale = 3, style = "sd")


berlinstraﬂen

berlinstraﬂen <- mutate(berlinstraﬂen, lange = st_length(berlinstraﬂen))
berlinstraﬂen$lange <- as.numeric(berlinstraﬂen$lange)
berlinstraﬂen$length <- as.numeric(berlinstraﬂen$length)
b <- mutate(berlinstraﬂen, d = length - lange)
b <- select(b,d)
b <- filter(b, d > 1 || d < -1)

berlinstraﬂen2 <- select(berlinstraﬂen, id, from, to, x, y, wkt, geometry)
berlinstraﬂen2
