# CITY STREET MAPS SERIES

# City map 01: Valencia, Spain. 
# New feature: Coastline

# Valencia_coastline.R
pacman::p_load(here,tidyverse,osmdata,sf,showtext)

# Check set of features 
# 1.2 features
available_features()
# 2.2 Tags within features 
available_tags("highway")

# 3. Within the highway feature we choose several taga
# These are the coordinates we need for our Valencia map


# MAP LAYER 01: roads  
roads <- getbb("Valencia Spain") %>% 
         opq(timeout =  3500) %>% 
         add_osm_feature(key = "highway",
                        value = c("motorway","primary","secondary","tertiary",
                                  "residential","living_street","unclassified")) %>% 
         osmdata_sf()
roads

getbb("Valencia Spain")
help(getbb)

# getbb("Valencia Spain")
# min        max
# x -0.4325512 -0.2725205
# y 39.2784496 39.5666089
road_color <- '#000000'

Valencia_roads <- ggplot() +
                  geom_sf(data = roads$osm_lines,
                          inherit.aes = FALSE,
                          color = road_color) +
                  coord_sf(xlim = c(-0.4325512, -0.2725205),
                           ylim = c(39.2784496, 39.5666089),
                           expand = FALSE)
Valencia_roads


# MAP LAYER 02: waterfront 
# We want to add waterfrom to the map 
available_features()
# We want natural features from the list below 
# [166] "nat_name"                    "natural"                     "noexit"    
# So we obtain the available tags related to that feature
available_tags("natural")


# key = natural
# tag = "coastline" 
coastline <- getbb("Valencia Spain") %>% 
  opq(timeout =  3500) %>% 
  add_osm_feature(key = "natural",
                  value = c("coastline")) %>% 
  osmdata_sf()
coastline


# MAP LAYER 03: Rivers and  waterways

Vlc_water <- getbb("Valencia Spain") %>% 
  opq(timeout =  3500) %>% 
  add_osm_feature(key = "water") %>% 
  osmdata_sf()

Vlc_sea <- getbb("Valencia Spain") %>% 
  opq(timeout =  3500) %>% 
  add_osm_feature(key = "waterway",
                  value = "river") %>% 
  osmdata_sf()



# VALENCIA MAP
# Including previous road and streets and also water and waterways features
# Map colours




road_color <- '#000000'
coastline_color <- '#000000'
water_color <- '#0066CC'
waterway_color <- '#99CCFF'


Valencia_map <- ggplot() +
                  # Layer 01 Roads
                    geom_sf(data = roads$osm_lines,
                            inherit.aes = FALSE,
                            color = road_color) +
                  # Layer 02 coastline
                    geom_sf(data = coastline$osm_lines,
                            inherit.aes = FALSE,
                            color = coastline_color) +
                  # Layer 03 water
                  geom_sf(data = Vlc_water$osm_lines,
                          inherit.aes = FALSE,
                          color = water_color
                  ) +
                  # Layer 04 waterways
                  geom_sf(data = Vlc_sea$osm_lines,
                          inherit.aes = FALSE,
                          color = waterway_color
                  ) +
                  # Define city coordinates for maps. Given by getbb("Valencia Spain")
                      coord_sf(xlim = c(-0.4325512, -0.2725205),
                             ylim = c(39.2784496, 39.5666089),
                             expand = FALSE)
Valencia_map 

# Plot map with title and removing some features  
# theme(axis.text)

# Map colours
road_color <- '#000000'
coastline_color <- '#000000'
water_color <- '#0066CC'
waterway_color <- '#99CCFF'
font_color <-'#0000FF'

# Add google font 
font_add_google("Barlow", "barlow")

# PLOT MAP

vlc_map_formatted <- ggplot() +
  
  # Layer 01 Roads
  geom_sf(data = roads$osm_lines,
          inherit.aes = FALSE,
          color = road_color) +
  # Layer 02 coastline
  geom_sf(data = coastline$osm_lines,
          inherit.aes = FALSE,
          color = coastline_color) +
  # Layer 03 water
  geom_sf(data = Vlc_water$osm_lines,
          inherit.aes = FALSE,
          color = water_color) +
  # Layer 04 waterways
  geom_sf(data = Vlc_sea$osm_lines,
          inherit.aes = FALSE,
          color = waterway_color) +
  
  # Define city coordinates for maps. Given by getbb("Valencia Spain")
  coord_sf(xlim = c(-0.4325512, -0.2725205),
           ylim = c(39.2784496, 39.5666089),
           expand = FALSE) +
  
  # Apply several theme parameters
  theme_void() +
  theme(plot.title = element_text(family = "Barlow",color = font_color,size = 15, 
                                  hjust = 0, vjust = 1)) +
          
          labs(title = "Valencia ~ Spain", subtitle = '39.4699° N, 0.3763° W')
        
vlc_map_formatted
        
#  theme(
#    plot.title = element_text(family = "Barlow",color = font_color,size = 15, 
#                              hjust = 0, vjust = 1),
#    plot.title.position = "plot",
#    plot.subtitle = element_text(family = "Barlow",
#                                 color = font_color,
#                                 size = 9,
#                                 hjust = 0 , vjust = 2.3)) +



# Prepare output plot
name <-"Valencia_rivers"
width = 20
height = 40

here()
# Save Map as .png file
# Output size can be tailored to print out as a poster. Current setup width 20 cm and height 40 cm
ggsave(here::here(paste(name,".png")),
       device = "png", width = width, height = height, units = "cm", dpi = "retina", bg = "transparent")
