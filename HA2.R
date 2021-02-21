setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/ds-week-12")

library(tidygraph)
library(sfnetworks)
library(tidyverse)
library(sf)
library(tmap)

bezirke <- st_read("bezirke/bezirksgrenzen.shp")
mitte <- filter(bezirke, Gemeinde_n == "Mitte")

mitte <- st_transform(mitte, crs = 31468)

st_write(mitte, paste0(tempdir(), "/", "mitte.shp"))

bezirke <- st_read("mitte/mitte.shp")
bezirke <- st_transform(bezirke,crs =  4326)

mittesf <- st_read("edge.csv", crs = 31468)
mittesf$count <- as.numeric(mittesf$count)


tmap_mode("view")

tm_shape(mittesf) +
  tm_lines(col = "count", scale = 2)

unfaelle <- read.csv2("Unfaelle.csv")
unfaellepoint <- st_as_sf(unfaelle, coords = c("XGCSWGS84", "YGCSWGS84"), crs = 4326)
unfaellepoint <- select(unfaellepoint, geometry)
unfaellepoint <- st_join(unfaellepoint, bezirke, join = st_within)
unfaellepoint <- na.omit(unfaellepoint)

tm_shape(mittesf) +
  tm_lines(col = "count", scale = 3) +
  tm_shape(unfaellepoint) +
  tm_dots(size = 0.01)
