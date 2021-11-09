# PRODUCE MAPS USING GGPLOT2
# Date 30 OCT 2021

#install.packages("ggplot2", dependencies=TRUE)   (Already installed)
#install.packages("tidyverse", dependencies=TRUE) (Already installed)


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

# 1-2 Load geographical data from ggplot2 package
# unique() unique returns a vector, data frame or array like x but with duplicate elements/rows removed.
worldmap_countries <- map_data("world")

# Find distinct number of countries from map shapefile
countries_n <- length(unique(worldmap_countries$region))
countries_n


n_distinct(x)

# 1-3 Identify set of countries 

LIST_COUNTRIES <- worldmap_countries$region

# Check full list of distinct countries
COUNTRIES <- worldmap_countries %>% 
                 select(region) %>% 
                 distinct(region)

COUNTRIES

head(worldmap_countries)

# 1 Subset set of countries: [France, Spain, Germany]
# Subset rows using column values: filter()

TARGET_C <- COUNTRIES %>% 
            filter(
                     region=="France" | region=="Spain" | region=="Germany"
                  )
TARGET_C

# 2 Filter Worldmap geo data for France
SETCOUNTRIES <- worldmap_countries %>% 
                select(long,lat,group, order,region) %>% 
                filter(
                      region=="France" | region=="Spain" | region=="Germany")

SETCOUNTRIES

head(SETCOUNTRIES)

# Rename region as country
# DPLYR: rename(new_name = old_name)
SETC <-SETCOUNTRIES

names(SETC)

SETC   <- SETC %>% 
          select(long,lat,group, order,region) %>% 
          rename(country = region)
head(SETC)

# 3 JOIN MAP AND COVID19 DATA 
head(SETC)
head(datac)

MAPSETC <- left_join(SETC,datac,by = "country")

# 4 CLEAN UP MERGED DATA
MAPSETCL <- MAPSETC %>% filter(!is.na(MAPSETC$cases))


# 5 CREATE MAPS
# Produce map for 1st MARCH 2021

# 5.1 Produce map for 1st March 2021
# [France, Spain, Germany]
MARMAPSETCL <- MAPSETCL %>%   filter(month == 3 & day == 1)
MARMAPSETCL

mapSETCLMAR <-ggplot(MARMAPSETCL, aes( x = long, y = lat, group=group )) 
mapSETCLMAR <- mapSETCLMAR + geom_polygon(aes(fill = cases),color = "black")
mapSETCLMAR <- mapSETCLMAR + labs(title ="COVID19 cases in France, Spain, Germany on 1st March 2021")
mapSETCLMAR


ggsave(paste0("COVID19 cases in FR SP GER March 2021","_",
              format(Sys.time(),"%Y-%m-%d_%H-%M"),".jpeg"),
       width = 30, height = 20, dpi = 150, units = "cm") 


# Keep just plot_leaflet_rates
rm(list=ls()[!(ls()%in%c('MAPSETCL','MARMAPSETCL'))])


# 5.2 Produce one map for each month using FACET_WRAP 

# 5.2.1 Data Prep
FACET_9SELC <- MAPSETCL %>% 
             filter(
                      (month == 2 & day == 1) |
                      (month == 3 & day == 1) |
                      (month == 4 & day == 1) |
                      (month == 5 & day == 1) |
                      (month == 6 & day == 1) |
                      (month == 7 & day == 1) |
                      (month == 8 & day == 1) |
                      (month == 9 & day == 1) |
                      (month == 10 & day == 1) ) %>% 
                  mutate(month_n = month.name[month])

FACET_9SELC
head(FACET_9SELC)


# 5.2.2 Create map 

# Using now facet_wrap split by month_n
# facet_wrap(~ month_n) : Wrap a 1d ribbon of panels into 2d
mapSETCLFEBOCT <-ggplot(FACET_9SELC, aes( x = long, y = lat, group=group )) 
mapSETCLFEBOCT <- mapSETCLFEBOCT + geom_polygon(aes(fill = cases),color = "black")
mapSETCLFEBOCT <- mapSETCLFEBOCT + labs(title ="COVID19 cases in France Spain and Germany, 1st Feb to Oct 2021")
mapSETCLFEBOCT <- mapSETCLFEBOCT + facet_wrap(vars(month_n)) 
mapSETCLFEBOCT


ggsave(paste0("COVID19 cases in FR SP GER. February-October 2021. Facet_wrap","_",
              format(Sys.time(),"%Y-%m-%d_%H-%M"),".jpeg"),
       width = 30, height = 20, dpi = 150, units = "cm") 
