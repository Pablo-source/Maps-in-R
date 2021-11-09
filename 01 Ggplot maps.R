# PRODUCE MAPS USING GGPLOT2
# Date 30 OCT 2021

install.packages("ggplot2", dependencies=TRUE)
install.packages("tidyverse", dependencies=TRUE)


#these libraries need to be loaded
library(tidyverse)

# Download data from ECDC website
# We use UTILS package to download required data
library(utils)

# 1 READ IN COVID DATA AND GEOSPATIAL DATA
# 1-1 Read in COVID19 data sheet into “R”. The dataset will be called "data".
data <- read.csv("https://opendata.ecdc.europa.eu/covid19/nationalcasedeath_eueea_daily_ei/csv", na.strings = "", fileEncoding = "UTF-8-BOM")

# EXPLORE DATASET
head(data)
names(data)
str(data)
names(data)

# 1-1.2 Rename variables to merge with geographical data
# countriesAndTerritories -> country
# select( new_name = prev_name )
datac <- data %>% 
         select(
           dateRep,day,                     
           month, year,                    
           cases,  deaths,                  
           country = countriesAndTerritories,   
           geoId,                   
           countryterritoryCode,      
           popData2020,             
           continentExp      
         )

head(datac)

#long      lat group order country subregion
#1 -69.89912 12.45200     1     1   Aruba      <NA>
#  2 -69.89571 12.42300     1     2   Aruba      <NA>
#  3 -69.94219 12.43853     1     3   Aruba      <NA>
  
# 1-2 Load geographical data from ggplot2 package

worldmap <- map_data("world")
view(worldmap)

worldmapprep <- worldmap
head(worldmapprep)

#long      lat group order region subregion
#1 -69.89912 12.45200     1     1  Aruba      <NA>
#  2 -69.89571 12.42300     1     2  Aruba      <NA>
#  3 -69.94219 12.43853     1     3  Aruba      <NA>
#  4 -70.00415 12.50049     1     4  Aruba      <NA>
#  5 -70.06612 12.54697     1     5  Aruba      <NA>
#  6 -70.05088 12.59707     1     6  Aruba      <NA>
  
# 2-2.1 Rename variables to merge with geographical data
# region -> country
# select( new_name = prev_name )
  
worldmapd <- worldmapprep %>% select(
                                      long,lat,group, order,  
                                      country = region,subregion)

rm(data,worldmap,worldmapprep)
rm(worldmapc,worlmapl)

head(worldmapd)
  
#  long      lat group order country subregion
#  1 -69.89912 12.45200     1     1   Aruba      <NA>
#  2 -69.89571 12.42300     1     2   Aruba      <NA>
  


# 3 JOIN MAP AND COVID19 DATA  
MAPDATA <- left_join(worldmapd,datac,
                     by = "country")

# 4 CLEAN UP MERGED DATA
# From this data set we are going to plot TWO metrics (cases,deaths)
# We need to ensure that we don't have any missing data

MAPDATAC <- MAPDATA %>% 
             filter(!is.na(MAPDATA$cases))

View(MAPDATAC)
head(MAPDATAC)

# PRODCE MAP
# we need to include group=group to ensure all the countries fit together
map1 <-ggplot(MAPDATAC, aes( x = long, y = lat, group=group )) 

# polygon, fill my aesthetic fill to cases
# color = "black" there will be a black line aroung each country
map1 <- map1 + geom_polygon(aes(fill = cases),color = "black")
map1

# Add title and subtitle
map2 <- map1
map2 <- map2 + ggtitle("Total COVID19 cases in Europe on 2021") 
map2


# FILTER DATA FOR A SINGLE MONTH
names(MAPDATAC)
table(MAPDATAC$year)
table(MAPDATAC$month)
table(MAPDATAC$day)


# Produce map for 1st March 2021
MARMAP <- MAPDATAC %>% 
          filter(month == 3 &
                 day == 1)

MARMAP
View(MARMAP)

# Now we can plot our map
head(MARMAPUNIC)

# Clean dataset. Retain just data sets for maps

# Keep just plot_leaflet_rates
rm(list=ls()[!(ls()%in%c('MARMAP','OCTMAP','MAPDATAC'))])

################
# PLOTS
# 
# Produce map for 1st MARCH 2021
map3 <-ggplot(MARMAP, aes( x = long, y = lat, group=group )) 
map3 <- map3 + geom_polygon(aes(fill = cases),color = "black")
map3 <- map3 + labs(title ="COVID19 cases in Europe. 1st March 2021")
map3

ggsave(paste0("COVID19 cases in Europe. 1st March 2021","_",
              format(Sys.time(),"%Y-%m-%d_%H-%M"),".jpeg"),
       width = 30, height = 20, dpi = 150, units = "cm") 


# Produce map for 1st OCTOBER 2021
OCTMAP <- MAPDATAC %>% 
                  filter(month == 10 & day == 1)
OCTMAP

map4 <-ggplot(OCTMAP, aes( x = long, y = lat, group=group )) 
map4 <- map4 + geom_polygon(aes(fill = cases),color = "black")
map4 <- map4 + labs(title ="COVID19 cases in Europe. 1st October 2021")
map4

ggsave(paste0("COVID19 cases in Europe. 1st October 2021","_",
              format(Sys.time(),"%Y-%m-%d_%H-%M"),".jpeg"),
       width = 30, height = 20, dpi = 150, units = "cm") 

# produce facet grid with these two maps

# Condition for MARCH21 data OR condition for OCT21 data
10564+316920

FACET_MAPS <- MAPDATAC %>% 
            filter(
                      (month == 3 & day == 1) |
                      (month == 10 & day == 1)  
                  )
FACET_MAPS

head(FACET_MAPS)

table(FACET_MAPS$month)

# Dataset: FACET_MAPS
map5facet <-ggplot(FACET_MAPS, aes( x = long, y = lat, group=group )) 
map5facet <- map5facet + geom_polygon(aes(fill = cases),color = "black")
map5facet <- map5facet + facet_grid(~ month)
map5facet


# Include new variable to display month as Text 
# month.abb[rnum]
# month.name
# mnth <- c(11,9,4,2)
# month.name[mnth]

head(FACET_MAPS)

FACET_MAPSL <- FACET_MAPS %>% 
               mutate(month_n = month.name[month])

head(FACET_MAPSL)


# FACET MAP COMPARING TWO MONTHS SIDE BY SIDE (MONTH NAMES ON TOP)

# Include map now with month names in it 
# Dataset: FACET_MAPSL

map6facet <-ggplot(FACET_MAPSL, aes( x = long, y = lat, group=group )) 
map6facet <- map6facet + geom_polygon(aes(fill = cases),color = "black")
map6facet <- map6facet + labs(title ="COVID19 cases in Europe. 1st March and October 2021")
map6facet <- map6facet + facet_grid(~ month_n, scales = "free_x", space ="free_x")
map6facet

ggsave(paste0("COVID19 cases in Europe. March vs October 2021","_",
              format(Sys.time(),"%Y-%m-%d_%H-%M"),".jpeg"),
       width = 30, height = 20, dpi = 150, units = "cm") 

# Save worksapce
# save.image("C:/Pablo UK/43 R projects 2021/22 Maps in R NOV21/Maps/05 Facet_maps.RData")

# FACET_MONTH ALL MONTHS
names(MAPDATAC)
table(MAPDATAC$month)

MONTHS <- unique(MAPDATAC$month)
length(MONTHS)

#      2      3      4      5      6      7      8      9     10 

FACET_MAPS <- MAPDATAC %>% 
  filter(
    (month == 3 & day == 1) |
      (month == 10 & day == 1)  
  )
FACET_MAPS