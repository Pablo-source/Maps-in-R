# Valencia_open_street_map.R

# OpenStreetMap (OSM) project information can be accessed via overpassqueries using  **osmdata** package in R. 
# This package obtain OSM data from the overpass API, which is a read-only API that serves up custom selected parts of the the OSM map data. 

# This is a small tutorial on how to build a city map of using osmdata package of the city of Valencia, Spain. 

# 1. Install and load required packages
# install.packages("osmdata",dependencies = TRUE)

# 1.1 Load remaining libraries 
if(!require(pacman)){
  install.packages("pacman", dependencies = TRUE)
}
if(!require(here)){
  install.packages("here", dependencies = TRUE)
}
if(!require(tidyverse)){
  install.packages("tidyverse", dependencies = TRUE)
}
if(!require(osmdata)){
  install.packages("osmdata", dependencies = TRUE)
}
if(!require(sf)){
  install.packages("sf", dependencies = TRUE)
}
if(!require(showtext)){
  install.packages("showtext", dependencies = TRUE)
}

# 1.Load required libraries 
pacman::p_load(here,tidyverse,osmdata,sf,showtext)

## Visualize Valencia city map using OpenStreetMap 

getbb("Valencia Spain")

# Check available features and tags to choose which ones to include in our map
available_features()
available_tags("highway")

## 2. EXAMPLE OF ADDING ONE CITY MAP LAYER

## 2.1 Choosing elements for map first layer highway

# We name each layer with the key and values we want to plot in the map. 
# So for this first example, I want to see several types of roads in the metropolitan area of Valencia

# MAP LAYER 01: roads  
roads <- getbb("Valencia Spain") %>% 
  opq(timeout =  3500) %>% 
  add_osm_feature(key = "highway",
                  value = c("motorway","primary","secondary","tertiary",
                            "residential","living_street","unclassified")) %>% 
  osmdata_sf()
roads

## Building maps in layers by adding natural and urban features

# MAP 01: Create a standard ggplot() object using geom_sf() and osm features defined as roads

## Set colour palette for road, residential and highway features
# Remember to enclose Hexadecimal colors in apostrophes 
road_color <- '#000000'
coastline_color <- '#000000'

Valencia_roads_map <- ggplot() +
                        geom_sf(data = roads$osm_lines,
                                inherit.aes = FALSE,
                                color = road_color
                        ) +
                        # Define city coordinates for maps. Given by getbb("Valencia Spain") function
                        coord_sf(xlim = c(-0.4325512, -0.2725205),
                                 ylim = c(39.2784496, 39.5666089),
                                 expand = FALSE)
Valencia_roads_map

## BUILDING VALENCIA CITY MAP

### 3.1 Initial Valencia city map showing roads and highways 

roads <- getbb("Valencia Spain") %>% 
  opq(timeout =  3500) %>% 
  add_osm_feature(key = "highway",
                  value = c("motorway","primary","secondary","tertiary",
                            "residential","living_street","unclassified")) %>% 
  osmdata_sf()
roads

### 3.2 Valencia city map including roads and coastline and also adding coastline features

available_tags("natural")

Vlc_coastline <- getbb("Valencia Spain") %>% 
  opq(timeout =  3500) %>% 
  add_osm_feature(key = "natural",
                  value = c("bay","water","beach","wetland","dune","coastline")) %>% 
  osmdata_sf()
Vlc_coastline

# In order to display the sea bay in front of Valencia we define it as multipolygons object
Vlc_coastline_multipolygons <- Vlc_coastline$osm_multipolygons

# Roads features are defined as lines whilst coastline and water features are defined as polygons



# MAP 02: This is a new map combining roads and coastline layers

# Set colour palette for road and coastline features
road_color <- '#1E212B'
coastline_color <- '#D4B483'

# This is the ggplot2() MAP02

Valencia_coastline_map <- ggplot() +
  # roads
  geom_sf(data = roads$osm_lines,
          inherit.aes = FALSE,
          color = road_color
  ) +
  # coastline as multipolygons
  geom_sf(data = Vlc_coastline_multipolygons,
          inherit.aes = FALSE,
          color = coastline_color
  ) +
  # Define city coordinates for maps. Given by getbb("Valencia Spain") function
  coord_sf(xlim = c(-0.4325512, -0.2725205),
           ylim = c(39.2784496, 39.5666089),
           expand = FALSE)
Valencia_coastline_map


### 3.3 New Water bodies features added to Valencia city map

# We want to include the see and different water bodies such as reservoirs and natural lagoons in the map, 
# in the South part of the City of Valencia ther is a big lagoon called "La Albufera" we want to display it in hues of blue colors.

Vlc_water <- getbb("Valencia Spain") %>% 
  opq(timeout =  3500) %>% 
  add_osm_feature(key = "water") %>% 
  osmdata_sf()

Vlc_sea <- getbb("Valencia Spain") %>% 
  opq(timeout =  3500) %>% 
  add_osm_feature(key = "waterway",
                  value = "river") %>% 
  osmdata_sf()

# To display these water features in the map, we define them as multipolygon objects
Vlc_water_multipolygons <- Vlc_water$osm_multipolygons
Vlc_sea_multipolygons <- Vlc_sea$osm_multipolygons


# MAP 03: Map including these new water features (we build them on the previous road and highways features included on previous steps)

# Set colour palette for water features 
road_color <- '#1E212B'
coastline_color <- '#D4B483'
water_color <- '#0066CC'
waterway_color <- '#99CCFF'

# This is the ggplot2() MAP03

Valencia_waterways_map <- ggplot() +
  # roads
  geom_sf(data = roads$osm_lines,
          inherit.aes = FALSE,
          color = road_color
  ) +
  # coastline as multipolygons
  geom_sf(data = Vlc_coastline_multipolygons,
          inherit.aes = FALSE,
          color = coastline_color
  ) +
  
  # water colour as multipolygons
  geom_sf(data = Vlc_water_multipolygons,
          inherit.aes = FALSE,
          color = water_color
  ) +
  # waterway colour as multipolygons
  geom_sf(data = Vlc_sea_multipolygons,
          inherit.aes = FALSE,
          color = waterway_color
  ) +
  # Define city coordinates for maps. Given by getbb("Valencia Spain") function
  coord_sf(xlim = c(-0.4325512, -0.2725205),
           ylim = c(39.2784496, 39.5666089),
           expand = FALSE)
Valencia_waterways_map   

### 3.4 Including specific feature by name in the map 

# This new map layer provides us with an efficient way of locating specific geological features by its common name. 
# In this example I will include the l'Albufera freshwater lagoon. It is the largest freshwater lagoon in Spain, spanning more than 2,800 hectares.

# We need to locate the name of l'Albufera to plot it 
Albufera_lagoon  <- getbb("Valencia Spain") %>% 
                      opq() %>% 
                      add_osm_feature(key = "natural") %>% 
                      add_osm_feature(key = "name", value = "l'Albufera", value_exact = FALSE) %>% 
                      osmdata_sf()
View(Albufera_lagoon)

# Again we define this lagoon as a polygon object in the map 

Albufera_multipolygons <- Albufera_lagoon$osm_multipolygons
View(Albufera_multipolygons)

# Specific geological feature included by name in the map

# MAP 04: Map including highway and road features, and also water features and l'Albufera lagoon as a new feature.

# Set colour palette for l'Albufera map 


Valencia_lagoon_map <- ggplot() +
  # roads
  geom_sf(data = roads$osm_lines,inherit.aes = FALSE,color = road_color) +
  # coastline
  geom_sf(data = Vlc_coastline_multipolygons,inherit.aes = FALSE, fill = waterway_color, color = waterway_color) +
  # water colour as multipolygons
  geom_sf(data = Vlc_water_multipolygons,inherit.aes = FALSE, fill = water_color, color = water_color) +
  # waterway colour as multipolygons
  geom_sf(data = Vlc_sea_multipolygons,inherit.aes = FALSE, fill = waterway_color, color = waterway_color) +
  # Adding l'Albufera lagoon to the map
  geom_sf(data = Albufera_multipolygons,inherit.aes = FALSE, fill = albufera_lagoon, color = albufera_lagoon) +
  # Define city coordinates for maps. Given by getbb("Valencia Spain") function
  coord_sf(xlim = c(-0.4325512, -0.2725205),ylim = c(39.2784496, 39.5666089),expand = FALSE)

Valencia_lagoon_map  

# 4. VALENCIA OPEN STREET MAP (including all previous features)

# 4.1 Combining all features into a single map and applying specific Theme

# Now that we have defined several features to be plotted in our map (roads,coastline,waterways and rivers), we can combine them all into an output map. Again we add each of these feature using the geom_sf() function. 

# This final step also includes making the map prettier by applying several theme options and adding a background colour to the map as well as Title and Subtitle:
#  - Include Map title and subtitle 
#  - Setup background colour
#  - Set map margins

# Set colour palette for VALENCIA OPEN STREET MAP
road_color <- '#1E212B'
coastline_color <- '#D4B483'
water_color <- '#0066CC'
waterway_color <- '#99CCFF'
albufera_lagoon <- "#0ACDFF"
font_color <-'#D2691E' 
background_color <- "#D4B483"

# MAP 05: VALENCIA OPEN STREET MAP, ALL PREVIOUS FEATURES INCLUDED 

Valencia_city_map <- ggplot() +
  # roads
  geom_sf(data = roads$osm_lines,inherit.aes = FALSE,color = road_color) +
  # coastline
  geom_sf(data = Vlc_coastline_multipolygons,inherit.aes = FALSE, fill = waterway_color, color = waterway_color) +
  # water colour as multipolygons
  geom_sf(data = Vlc_water_multipolygons,inherit.aes = FALSE, fill = water_color, color = water_color) +
  # waterway colour as multipolygons
  geom_sf(data = Vlc_sea_multipolygons,inherit.aes = FALSE, fill = waterway_color, color = waterway_color) +
  # Adding l'Albufera lagoon to the map
  geom_sf(data = Albufera_multipolygons,inherit.aes = FALSE, fill = albufera_lagoon, color = albufera_lagoon) +
  # Define city coordinates for maps. Given by getbb("Valencia Spain") function
  coord_sf(xlim = c(-0.4325512, -0.2725205),ylim = c(39.2784496, 39.5666089),expand = FALSE) +
  # Include Map title and subtitle 
  labs(title = "Valencia ~ l'Albufera", subtitle = '39.4699° N, 0.3763° W') +
  # Apply specific theme to map title and sub-title
  theme_void() +
  theme(
    plot.title = element_text(family = "Barlow",color = font_color,size = 9, 
                              hjust = 0, vjust = 1),
    plot.title.position = "plot",
    plot.subtitle = element_text(family = "Barlow",
                                 color = font_color,
                                 size = 5,
                                 hjust = 0 , vjust = 2.3),  
    # Setup background color for entire map 
    panel.border = element_rect(colour = background_color, fill = NA, size = 1),
    panel.margin = unit(c(0.6,1.6,1,1.6),"cm"),
    plot.background = element_rect(fill = background_color)
  ) 

Valencia_city_map 

# Save output map
name <- "Valencia_open_street_map"
width = 20
height = 40

# Save chart
ggsave(here::here(paste(name,".png", sep ="_")),
       device = "png", width = width, height = height, units = "cm", dpi = "retina", bg = "transparent")
