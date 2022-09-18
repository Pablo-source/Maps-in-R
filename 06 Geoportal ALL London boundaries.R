# 06 Geoportal ALL London Boundaries

# 04 Geoportal maps
# 1 . Download CCG shape file files from
# https://geoportal.statistics.gov.uk/

# This is a script to learn how to load shape files using SF package from different shapefiles  
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

# 0. List all .shp files in the project folder containing all UNZIPPED shapefiles required to plot London maps
# We use list.files() function inside unzipped "statistical-gis-boundaries-london.zip" file to identify .sh files
here()
# [1] "/home/pablo/Documents/Pablo_Desktop/R_warehouse/R_projects/Maps/R maps"

# We have unzipped London shape files inside Shapefiles folder in our working directory (.sh)
Shapeflies_list <-list.files("Shapefiles/statistical-gis-boundaries-london/ESRI/",".shp")
Shapeflies_list

# We know that we have a total of 15 different shapefiles to choose for a different level of gepgraphical aggregation
[1] "London_Borough_Excluding_MHW.shp"         "London_Borough_Excluding_MHW.shp.xml"     "London_Ward_CityMerged.shp"              
[4] "London_Ward_CityMerged.shp.xml"           "London_Ward.shp"                          "London_Ward.shp.xml"                     
[7] "LSOA_2004_London_Low_Resolution.shp"      "LSOA_2011_London_gen_MHW.shp"             "LSOA_2011_London_gen_MHW.shp.xml"        
[10] "MSOA_2004_London_High_Resolution.shp"     "MSOA_2004_London_High_Resolution.shp.xml" "MSOA_2011_London_gen_MHW.shp"            
[13] "MSOA_2011_London_gen_MHW.shp.xml"         "OA_2011_London_gen_MHW.shp"               "OA_2011_London_gen_MHW.shp.xml"   


# 1. London Boroughs

# Now that we have the full path to the Shape file for our map, we can read ut into R using st_read() function 
# File: London_Borough_Excluding_MHW.shp
LDN_boroughs <- st_read(here("Shapefiles","statistical-gis-boundaries-london","ESRI","London_Borough_Excluding_MHW.shp"))
LDN_boroughs

# 2. London Wards
# File: London_Ward.shp
LDN_wards <- st_read(here("Shapefiles","statistical-gis-boundaries-london","ESRI","London_Ward.shp"))
LDN_wards

# 3. London. Lower Super Output Area (LSOA).2011
# File: LSOA_2011_London_gen_MHW.shp
LDN_lsoa <- st_read(here("Shapefiles","statistical-gis-boundaries-london","ESRI","LSOA_2011_London_gen_MHW.shp"))
LDN_lsoa

# 4. London. Middle Super Output Area (MSOA).2011
# File:  MSOA_2011_London_gen_MHW.shp
LDN_msoa <- st_read(here("Shapefiles","statistical-gis-boundaries-london","ESRI","MSOA_2011_London_gen_MHW.shp"))
LDN_msoa

# 5. London. Output Area (OA). 2011
# FIle: OA_2011_London_gen_MHW.shp
LDN_oa <- st_read(here("Shapefiles","statistical-gis-boundaries-london","ESRI","OA_2011_London_gen_MHW.shp"))
LDN_oa


# 2. Plot shapefile using GGPLOT2
#---------------------------------
# colours@ coral slategray3 dodgerblue1

# 1. London Boroughs
# File: London_Borough_Excluding_MHW.shp
Boroughs_LDN <- ggplot() +
        geom_sf(data = LDN_boroughs, size = 0.5, color = "black", fill ="coral") +
        ggtitle("London Boroughs boundaries. April 2021") +
        coord_sf()
Boroughs_LDN


# 2. London Wards
# File: London_Ward.shp 
Wards_LDN <- ggplot() +
              geom_sf(data = LDN_wards, size = 0.5, color = "black", fill ="dodgerblue1") +
              ggtitle("London Wards boundaries. April 2021") +
              coord_sf()
Wards_LDN

# 3. London. Lower Super Output Area (LSOA).2011
# File: LSOA_2011_London_gen_MHW.shp
SOA_LDN <- ggplot() +
                geom_sf(data = LDN_lsoa, size = 0.5, color = "black", fill ="thistle") +
                ggtitle("London Super Output Area (LSOA). April 2021") +
                coord_sf()
SOA_LDN

# 4. London. Middle Super Output Area (MSOA).2011
# File:  MSOA_2011_London_gen_MHW.shp
MSOA_LDN <- ggplot() +
                geom_sf(data = LDN_msoa, size = 0.5, color = "black", fill ="springgreen2") +
                ggtitle("London Middle Super Output Area (MSOA). April 2021") +
                coord_sf()
MSOA_LDN

# 5. London. Output Area (OA). 2011
# FIle: OA_2011_London_gen_MHW.shp
OA_LDN <- ggplot() +
              geom_sf(data = LDN_oa, size = 0.5, color = "black", fill ="aquamarine4") +
              ggtitle("London Output Area (OA). April 2021") +
              coord_sf()
OA_LDN
