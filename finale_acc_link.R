setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

tmap_mode("view")

berlinstraßen <- st_read("edge_berlin3.csv", crs = 31468)
berlinstraßen$count <- as.numeric(berlinstraßen$count)
berlinstraßen$length <- as.numeric(berlinstraßen$length)
berlinstraßen$id <- as.numeric(berlinstraßen$id)

unfaelle <- read.csv2("Unfaelle.csv")
unfaellepoint <- st_as_sf(unfaelle, coords = c("XGCSWGS84", "YGCSWGS84"), crs = 4326)
unfaellepoint <- st_transform(unfaellepoint, crs = 31468)

acc <- read.csv("acc.csv")

berlinstraßen_acc <- left_join(berlinstraßen, acc, by = "id")
berlinstraßen_acc <- filter(berlinstraßen_acc, !is.na(acc))
berlinstraßen_acc <- mutate(berlinstraßen_acc, "accident rate" = (1000000*acc)/(365*count*length))
berlinstraßen_acc$"accident rate" <- as.numeric(berlinstraßen_acc$"accident rate")
berlinstraßen_acc <- filter(berlinstraßen_acc, "accident rate" > 0)
berlinstraßen_acc <- filter(berlinstraßen_acc, !is.na("accident rate"))

tm_shape(berlinstraßen_acc) +
  tm_lines(col = "accident rate", scale = 3, breaks = c(0,0.25,0.5,1,2,5,10))
