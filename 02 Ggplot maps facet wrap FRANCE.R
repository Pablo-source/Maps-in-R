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

# 1-2 Load geographical data from ggplot2 package

worldmap <- map_data("world")
view(worldmap)

worldmapd <- worldmap %>% select(long,lat,group, order,  
                                      country = region,subregion)

head(worldmapd)

# Give the TRUE indices of a logical object, allowing for array indices.
CHCKFRANCE <- worldmapd %>% 
              filter(country=="France")

head(CHCKFRANCE)
rm(worldmapprep)


# 2 Filter Worldmap geo data for France


FRANCEMAP <- worldmap %>% select(long,lat,group, order,  
                                 country = region,subregion)  %>% 
                          filter(country=="France")

# 3 JOIN MAP AND COVID19 DATA  
MAPDATAFR <- left_join(FRANCEMAP,datac,by = "country")

# 4 CLEAN UP MERGED DATA
MAPDATAFRC <- MAPDATAFR %>% filter(!is.na(MAPDATAFR$cases))


# 5 CREATE MAPS
# Produce map for 1st MARCH 2021

# 5.1 Produce map for 1st March 2021
MARMAPFR <- MAPDATAFRC %>%   filter(month == 3 & day == 1)
MARMAPFR

mapFRA <-ggplot(MARMAPFR, aes( x = long, y = lat, group=group )) 
mapFRA <- mapFRA + geom_polygon(aes(fill = cases),color = "black")
mapFRA <- mapFRA + labs(title ="COVID19 cases in France. 1st March 2021")
mapFRA


ggsave(paste0("COVID19 cases in France. March 2021","_",
              format(Sys.time(),"%Y-%m-%d_%H-%M"),".jpeg"),
       width = 30, height = 20, dpi = 150, units = "cm") 


# Keep just plot_leaflet_rates
rm(list=ls()[!(ls()%in%c('MAPDATAFRC','MARMAPFR','mapFRA'))])


# 5.2 Produce one map for each month using FACET_WRAP

# 5.2.1 Data Prep
FACET_9MFR <- MAPDATAFRC %>% 
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

FACET_9MFR
head(FACET_9MFR)


# 5.2.2 Create map 

# Using now facet_wrap split by month_n
# facet_wrap(~ month_n) : Wrap a 1d ribbon of panels into 2d
mapFRAWRAP <-ggplot(FACET_9MFR, aes( x = long, y = lat, group=group )) 
mapFRAWRAP <- mapFRAWRAP + geom_polygon(aes(fill = cases),color = "black")
mapFRAWRAP <- mapFRAWRAP + labs(title ="COVID19 cases in France. 1st February to October 2021")
mapFRAWRAP <- mapFRAWRAP + facet_wrap(vars(month_n)) 
mapFRAWRAP


ggsave(paste0("COVID19 cases in Franace. February-October 2021. Facet_wrap","_",
              format(Sys.time(),"%Y-%m-%d_%H-%M"),".jpeg"),
       width = 30, height = 20, dpi = 150, units = "cm") 
