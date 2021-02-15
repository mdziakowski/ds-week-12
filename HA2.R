setwd("D:/UNI/Aktuell/Data Science for agent-based transport simulations/HA2")

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

#edgecsv <- read.csv2("edge.csv")
#nodecsv <- read.csv2("node.csv")

mittesf <- st_read("edge.csv", crs = 31468)
mittesf$count <- as.numeric(mittesf$count)
tmap_mode("view")
tm_shape(mittesf) +
  tm_lines(col = "count", scale = 2)

unfaelle <- read.csv2("Unfaelle.csv")
head(unfaelle)

unfaelle <- unfaelle %>%
  mutate(wkt = st_point(XGCSWGS84, YGCSWGS84))

unfaellepoint <- st_as_sf(unfaelle, coords = c("XGCSWGS84", "YGCSWGS84"), crs = 4326)
unfaellepoint <- filter()

tm_shape(mittesf) +
  tm_lines(col = "count", scale = 2) +
  tm_shape(unfaellepoint) +
  tm_dots()
  
