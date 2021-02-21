setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

berlinstraﬂen <- st_read("edge_berlin3.csv", crs = 31468)
berlinstraﬂen$count <- as.numeric(berlinstraﬂen$count)
berlinstraﬂen$length <- as.numeric(berlinstraﬂen$length)
berlinstraﬂen$id <- as.numeric(berlinstraﬂen$id)

unfaelle <- read.csv2("Unfaelle.csv")
unfaellepoint <- st_as_sf(unfaelle, coords = c("XGCSWGS84", "YGCSWGS84"), crs = 4326)
unfaellepoint <- st_transform(unfaellepoint, crs = 31468)

acc <- read.csv("acc.csv")

berlinstraﬂen_acc <- left_join(berlinstraﬂen, acc, by = "id")
berlinstraﬂen_acc <- filter(berlinstraﬂen_acc, !is.na(acc))
berlinstraﬂen_acc <- mutate(berlinstraﬂen_acc, acc_rate = (1000000*acc)/(365*count*length))
berlinstraﬂen_acc$acc_rate <- as.numeric(berlinstraﬂen_acc$acc_rate)
berlinstraﬂen_acc <- filter(berlinstraﬂen_acc, acc_rate > 0)
berlinstraﬂen_acc <- filter(berlinstraﬂen_acc, !is.na(acc_rate))

tm_shape(berlinstraﬂen_acc) +
  tm_lines(col = "acc_rate", scale = 3)

berlinstraﬂen_acc
