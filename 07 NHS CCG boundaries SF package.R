# 07 NHS CCG boundaries SF package.R
library(sf)
library(here)
library(dplyr)
library(ggplot2)
library(readxl)
library(janitor)

# Check WD directory file system
here()
[1] "/home/pablo/Documents/Pablo_Desktop/R_warehouse/R_projects/Maps/R maps"

# We will use the unzipped CCG shape file we downloaded from NHS website
here("Shapefiles","Clinical_Commissioning_Groups_(April_2021)_EN_BFC")

# Check files insside CCG unzipped folder
list.files(here("Shapefiles","Clinical_Commissioning_Groups_(April_2021)_EN_BFC"))

# These are the files that comprise the shape file
[1] "CCG_APR_2021_EN_BFC.cpg"                               "CCG_APR_2021_EN_BFC.dbf"                              
[3] "CCG_APR_2021_EN_BFC.prj"                               "CCG_APR_2021_EN_BFC.shp"                              
[5] "CCG_APR_2021_EN_BFC.shx"                               "Clinical_Commissioning_Groups_(April_2021)_EN_BFC.xml"

# 1. Load  CCG file with Shapefile extension into R
#-------------------------------

# We need first to scan the downloaded Shape files folder for the .shp file
# CCG_APR_2021_EN_BFC.shp
CCG_Shapeflies_list <-list.files(here("Shapefiles","Clinical_Commissioning_Groups_(April_2021)_EN_BFC"),".shp")
CCG_Shapeflies_list
[1] "CCG_APR_2021_EN_BFC.shp"

# Then we  load the  .shp ccg file from the set of shape files
CCG_boundaries <- st_read(here("Shapefiles","Clinical_Commissioning_Groups_(April_2021)_EN_BFC","CCG_APR_2021_EN_BFC.shp"))
CCG_boundaries

# 2. Plot CCG MAP
# Now that we have the full path to the Shape file for our CCG map, we can read it into R using st_read() function 
GGC_map <- ggplot() +
            geom_sf(data = CCG_boundaries, size = 0.5, color = "black", fill ="coral") +
            ggtitle("CCG Boundaries plot. April 2021") +
            coord_sf()
GGC_map

ggsave(paste0("CCG Boundaries April 2021_coral",".jpeg"),width = 30, height = 20, dpi = 150, units = "cm")