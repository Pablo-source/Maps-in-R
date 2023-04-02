# CITY MAPS SERIES

# 31/03/2023

# City map 02: Barcelona, Spain
# Features: roads, residential areas, coastline

# FIle: Barcelona_city_map.R

# 1. Install and Load required packages
if(!require(showtext)){
  install.packages("pacman", dependencies = TRUE)
}
if(!require(showtext)){
  install.packages("here", dependencies = TRUE)
}
if(!require(showtext)){
  install.packages("tidyverse", dependencies = TRUE)
}
if(!require(showtext)){
  install.packages("osmdata", dependencies = TRUE)
}
if(!require(showtext)){
  install.packages("sf", dependencies = TRUE)
}
if(!require(showtext)){
  install.packages("showtext", dependencies = TRUE)
}

# Load required packages 
pacman::p_load(here,tidyverse,osmdata,sf,showtext)

# 1 Using osmdata package start building layers for our map

# Check Barcelona LAT LONG location
getbb("Barcelona Spain")
#min       max
#x  2.052498  2.228356
#y 41.317035 41.467914

# MAP LAYER 01: roads 

roads_bcn <- getbb("Barcelona Spain") %>% 
             opq(timeout = 3500) %>% 
             add_osm_feature(key = "highway",
                             value = c("motorway","primary","secondary","tertiary",
                                       "residential","living street","unclassified")) %>% 
             osmdata_sf()
roads_bcn

# MAP LAYER 02: waterfront
avilable_features()
available_features("natural") # check list of available features to include in the map

# key = natural
# tag = coastline

coastline_bcn <- getbb("Barcelona Spain") %>% 
                 opq(timeout = 3500) %>% 
                 add_osm_feature(key = "natural", value = c("coastline")) %>% 
                 osmdata_sf()
coastline_bcn

# MAP 01: Check initial map 
road_color <- '#000000' #black
coastline_color <- '#000000' #black

Barcelona_map <- ggplot() +
                  # Layer 01 Roads
                  geom_sf(data = roads_bcn$osm_lines,inherit.aes=FALSE,color = road_color) +
                  # Layer 02 coastline
                  geom_sf(data = coastline_bcn$osm_lines, inherit.aes = FALSE, color = coastline_color) +
                  # Define BCN city coordinates using getbb() output for BCN
                  coord_sf(xlim = c(2.052498,  2.228356),
                           ylim = c(41.317035, 41.467914),
                           expand = FALSE)
Barcelona_map

#min       max
#x  2.052498  2.228356
#y 41.317035 41.467914

# MAP 02: Formatted map with custom theme
# Custom palette to choose from: cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

font_color <- '#f89507'

bcn_map_formatted <- ggplot() +
  # Include open map features
  theme_void() +
  geom_sf(data = roads_bcn$osm_lines,inherit.aes = FALSE,color = road_color, size = .5, alpha = .6) +
  geom_sf(data = coastline_bcn$osm_lines,inherit.aes = FALSE,color = coastline_color, size = .5, alpha = .6) +
  # Define city coordinates for maps. Given by getbb("Barcelona Spain")
  coord_sf(xlim = c(2.052498,  2.228356),ylim = c(41.317035, 41.467914),expand = FALSE) + 
  # Include Map title and subtitle 
  labs(title = "Barcelona city", subtitle = '39.4699° N, 0.3763° W') +
  # Setup custom map theme
  theme(
    plot.title = element_text(family = "Barlow",color = font_color,size = 15, 
                              hjust = 0, vjust = 1),
    plot.title.position = "plot",
    plot.subtitle = element_text(family = "Barlow",
                                 color = font_color,
                                 size = 9,
                                 hjust = 0 , vjust = 2.3),
    ) 

bcn_map_formatted


# MAP 03: Including background color
font_color <- '#f89507'
background_color <- "#4b9fb4"

bcn_map_print <- ggplot() +
  # Include open map features
  theme_void() +
  geom_sf(data = roads_bcn$osm_lines,inherit.aes = FALSE,color = road_color, size = .5, alpha = .6) +
  geom_sf(data = coastline_bcn$osm_lines,inherit.aes = FALSE,color = coastline_color, size = .5, alpha = .6) +
  # Define city coordinates for maps. Given by getbb("Barcelona Spain")
  coord_sf(xlim = c(2.052498,  2.228356),ylim = c(41.317035, 41.467914),expand = FALSE) + 
  # Include Map title and subtitle  
  labs(title = "Barcelona city", subtitle = '39.4699° N, 0.3763° W') +
  # Setup custom map theme
  theme(
    plot.title = element_text(family = "Barlow",color = font_color,size = 15, 
                              hjust = 0, vjust = 1),
    plot.title.position = "plot",
    plot.subtitle = element_text(family = "Barlow",
                                 color = font_color,
                                 size = 9,
                                 hjust = 0 , vjust = 2.3),
    # Setup background color for entire map 
    panel.border = element_rect(colour = background_color, fill = NA, size = 1),
    panel.margin = unit(c(0.6,1.6,1,1.6),"cm"),
    plot.background = element_rect(fill = background_color)
  ) 

bcn_map_print

# PNG output image file name and size (cm) 
name <-"Barcelona_city_map"
width = 20
height = 40

here()

# Save Barcelona city map as .png file (file outut size in cm)
ggsave(here::here(paste(name,".png", sep ="_")),
       device = "png", width = width, height = height, units = "cm", dpi = "retina", bg = "transparent")

