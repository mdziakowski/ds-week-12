setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

berlinstraﬂen <- st_read("edge_berlin3.csv", crs = 31468)
berlinstraﬂen$count <- as.numeric(berlinstraﬂen$count)
berlinstraﬂen_count <- filter(berlinstraﬂen, count > 20000)

tm_shape(berlinstraﬂen_count) +
  tm_lines(col = "count", scale = 3)