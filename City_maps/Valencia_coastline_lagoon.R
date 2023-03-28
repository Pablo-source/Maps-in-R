# Valencia_coastline_lagoon.R 
# Date: 27 March 2023

# AIM: This map combines city elements such as buildings and roads, including 
# also natural features such as l'Albufera the biggest freshwater lagoon in the Valencian Community

# l'Albufera is the largest freshwater lagoon in Spain, spanning more than 2,800 hectares.

# Check if relevant libraries are installed at the start of script
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

# 1. Load required libraries 
pacman::p_load(here,tidyverse,osmdata,sf,showtext)

# 2. Define the bounding box for Valencia
vlc_bb <- getbb(place_name = "Valencia Spain")
vlc_bb

# 3. Check which features to include in the map 

# Check set of features 
# 3.1 features
available_features()


# 3.2 Tags within features 

# As I am going to plot urban city features and also natural features, I choose these two main keys:
# key = "highway" (for urban features)
# key = "natural" (for natural features such as l'Albufera freshwater lagoon and several beaches within Valencia metropolitan area)
available_tags("highway")
available_tags("natural")


# 4. Create objects with arch features

# 4.1 Urban features

# MAP LAYER 01: roads and residential streets
roads <- getbb("Valencia Spain") %>% 
                    opq(timeout =  3500) %>% 
                    add_osm_feature(key = "highway",
                                    value = c("motorway","primary","secondary","tertiary",
                                              "residential","living_street","unclassified")) %>% 
                    osmdata_sf()
roads

# 4.2 Geological and natural features

# MAP LAYER 02: Coastline
# key = natural
# tag = "coastline" 
coastline <- getbb("Valencia Spain") %>% 
                opq(timeout =  3500) %>% 
                add_osm_feature(key = "natural",
                                value = c("coastline")) %>% 
                osmdata_sf()
coastline

# We choose multipolygons from shapefile to be plotted in the map 
beach_multiligons <- coastline$osm_multipolygons

# MAP LAYER 03: l'Albufera freshwater lagoon
Natural_features  <- getbb("Valencia Spain") %>% 
                        opq() %>% 
                        add_osm_feature(key = "natural") %>% 
                        osmdata_sf()
Natural_features

# New feature from previous maps, now we filter the "natural" key object by specific name
# This is the way to find and plot a specific natural feature such as l'Albufera freshwater lagooon

# Then and finally we need to locate the name of l'Albufera to plot it 
Albufera_lagoon  <- getbb("Valencia Spain") %>% 
                      opq() %>% 
                      add_osm_feature(key = "natural") %>% 
                      add_osm_feature(key = "name", value = "l'Albufera", value_exact = FALSE) %>% 
                      osmdata_sf()
View(Albufera_lagoon)

# We choose multipolygons from shapefile to be plotted in the map 
Albufera <- Albufera_lagoon$osm_multipolygons
View(Albufera)

# VALENCIA COASTLINE L'ALBUFERA LAGOON MAP
## Include now roads and coastline to our Valencia map  
# Map colours
road_color <- '#000000'
coastline_color <- "#D4B483"
rivers_lagoon <- "#0ACDFF"

# getbb("Valencia Spain")
# min        max
# x -0.4325512 -0.2725205
# y 39.2784496 39.5666089

vlc_metropolitan_map <- ggplot() +
  # Layer 01-03 Roads
  geom_sf(data = roads$osm_lines,inherit.aes = FALSE,color = road_color) +
  # Layer 02-03 coastline
  geom_sf(data = beach_multiligons,inherit.aes = FALSE, fill = coastline_color, color = coastline_color) +
  # Layer 03-03 l'Albufera lagoon
  geom_sf(data = Albufera, fill =  rivers_lagoon, colour = rivers_lagoon) +
  # Define city coordinates for maps. Given by getbb("Valencia Spain")
  coord_sf(xlim = c(-0.4325512, -0.2725205),
           ylim = c(39.2784496, 39.5666089),
           expand = FALSE)
vlc_metropolitan_map

# 5 CUSTOMIZE PREVIOUS MAP 

# Enhance this initial plot applying custom Themes
# theme(axis.text)
# Hexadecimal Map colors
road_color <- '#000000'
coastline_color <- "#D4B483"
rivers_lagoon <- "#0ACDFF"
font_color <-'#D2691E' 

# Plot map with title and removing some features 

vlc_lagoon_map  <- ggplot() +
  # Format color and width for roads and residential areas in the map
  theme_void() +
  geom_sf(data = roads$osm_lines,inherit.aes = FALSE,color = road_color, size = .5, alpha = .6) +   # Layer 01-03 Roads and urban features
  geom_sf(data = coastline$osm_lines,inherit.aes = FALSE,color = coastline_color, size = .5, alpha = .6) +  # Layer 02-03 coastline
  geom_sf(data = Albufera, fill =  rivers_lagoon, colour = rivers_lagoon) +   # Layer 03-03 l'Albufera lagoon 
  # Set city coordinates for maps. Given by getbb("Valencia Spain")
  coord_sf(xlim = c(-0.4325512, -0.2725205),ylim = c(39.2784496, 39.5666089),expand = FALSE) +

  # Include Map title and subtitle 
  labs(title = "Valencia ~ l'Albufera freshwater lagoon", subtitle = '39.4699° N, 0.3763° W') +
# Apply specific theme to map title and sub-title
theme(
  plot.title = element_text(family = "Barlow",color = font_color,size = 15, 
                            hjust = 0, vjust = 1),
  plot.title.position = "plot",
  plot.subtitle = element_text(family = "Barlow",
                               color = font_color,
                               size = 9,
                               hjust = 0 , vjust = 2.3),  
)
vlc_lagoon_map

# 6 FINAL THEME FOR PRINTOUT  
# Including background colour to apply a consitent theme to the map
road_color <- '#000000'
coastline_color <- "#D4B483"
rivers_lagoon <- "#66B2FF"
font_color <-'#D2691E' 
background_color <- "#D4B483"

vlc_lagoon_map  <- ggplot() +
  # Format color and width for roads and residential areas in the map
  theme_void() +
  geom_sf(data = roads$osm_lines,inherit.aes = FALSE,color = road_color, size = .5, alpha = .6) +   # Layer 01-03 Roads and urban features
  geom_sf(data = coastline$osm_lines,inherit.aes = FALSE,color = coastline_color, size = .5, alpha = .6) +  # Layer 02-03 coastline
  geom_sf(data = Albufera, fill =  rivers_lagoon, colour = rivers_lagoon) +   # Layer 03-03 l'Albufera lagoon 
  # Set city coordinates for maps. Given by getbb("Valencia Spain")
  coord_sf(xlim = c(-0.4325512, -0.2725205),ylim = c(39.2784496, 39.5666089),expand = FALSE) +
  
  # Include Map title and subtitle 
  labs(title = "Valencia ~ l'Albufera", subtitle = '39.4699° N, 0.3763° W') +
  # Apply specific theme to map title and sub-title
  theme(
    plot.title = element_text(family = "Barlow",color = font_color,size = 14, 
                              hjust = 0, vjust = 1),
    plot.title.position = "plot",
    plot.subtitle = element_text(family = "Barlow",
                                 color = font_color,
                                 size = 8,
                                 hjust = 0 , vjust = 2.3),  
      # Setup background color for entire map 
    panel.border = element_rect(colour = background_color, fill = NA, size = 1),
    panel.margin = unit(c(0.6,1.6,1,1.6),"cm"),
    plot.background = element_rect(fill = background_color)
  ) 
vlc_lagoon_map

# 6 SAVE OUTPUT PLOT
# Output map file name "Valencia Albufera feshwater lagoon"
name <- "Valencia_Albufera_feshwater_lagoon"
width = 20
height = 40

# Save chart
ggsave(here::here(paste(name,".png", sep ="_")),
       device = "png", width = width, height = height, units = "cm", dpi = "retina", bg = "transparent")