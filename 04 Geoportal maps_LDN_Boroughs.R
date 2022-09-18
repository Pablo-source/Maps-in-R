# 04 Map as the one I did for CCG

# 04 Geoportal maps
# Folder: N:\_Everyone\Pablo Leon\02 MY  WIP PROJECTS\02 10 Rightcare shiny app 28 JUL 2022\Rightcare_APP_new\Rightcare_new\Maps
# 1 . Download CCG shapefile from
# https://geoportal.statistics.gov.uk/

# This is a script to learn how to load shapefiles and produce chroplet maps in R 
#

# We will use sf package to work with vector data in R

# 1. Load required libraries

#install.packages("RPostgreSQL",dependencies = TRUE)
# install.packages("sf", dependencies = TRUE)
#install.packages("leaflet", dependencies = TRUE)
#install.packages("RPostgreSQL", dependencies = TRUE)

library(leaflet)
library(sf)
library(here)
library(dplyr)
library(ggplot2)
library(readxl)
library(janitor)

here()
[1] "/home/pablo/Documents/Pablo_Desktop/R_warehouse/R_projects/Maps/R maps"

# 1. Load Shapefile into R
#-------------------------------
# We will start by loading the above London boroughs shape file
# London_Borough_Excluding_MHW.shp

Path_boroughs <- here("Shapefiles","statistical-gis-boundaries-london","ESRI","London_Borough_Excluding_MHW.shp")
Path_boroughs

# Now that we have the full path to the Shape file for our map, we can read ut into R using st_read() function 
LDN_boroughs <- st_read(here("Shapefiles","statistical-gis-boundaries-london","ESRI","London_Borough_Excluding_MHW.shp"))
LDN_boroughs


# 2. Plot shapefile using GGPLOT2
#---------------------------------
# colours@ slategray3

Boroughs_shp <- ggplot() +
        geom_sf(data = LDN_boroughs, size = 0.5, color = "black", fill ="coral") +
        ggtitle("London Boroughs boundaries. April 2021") +
        coord_sf()
Boroughs_shp



