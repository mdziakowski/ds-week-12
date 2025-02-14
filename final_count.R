setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

berlinstraßen <- st_read("edge_berlin3.csv", crs = 31468)
berlinstraßen$count <- as.numeric(berlinstraßen$count)
berlinstraßen_count <- filter(berlinstraßen, count > 20000)

tm_shape(berlinstraßen_count) +
  tm_lines(col = "count", scale = 3)