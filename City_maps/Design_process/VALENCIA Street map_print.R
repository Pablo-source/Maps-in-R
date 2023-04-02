# CITY STREET MAPS SERIES

# City map 01: Valencia, spain. 

# R Script: VALENCIA Street map_print.R

# R Tutorial to build City maps based oh OSM Data
# Load required packages
pacman::p_load(here,tidyverse,osmdata,sf,showtext)

# add_osm_feature() function arguments
# ?add_osm_feature
# getbb{osmdata}
# This function uses the free Nominatim API provided by OpenStreetMap to find the bounding box (bb) associated with place names.

# 1. INCLUDE FEATURES in the map to plot
# 1.1 Add motorways
streets <- getbb("Valencia Spain") %>% 
           opq() %>% 
           add_osm_feature(key = "highway",
                           value = c("motorway", "primary",
                                     "secondary", "tertiary")) %>% 
            osmdata_sf()
streets

# 1.2. Add residential streets 
residential <-   getbb("Valencia Spain") %>% 
                  opq() %>% 
                  add_osm_feature(key = "highway",
                                  value = c("residential", "living_street",
                                            "service", "footway")) %>% 
                  osmdata_sf()
residential

# 1.3. Add river bed
# I use osmdata to get all the geographical features for the map
# https://stackoverflow.com/questions/69250795/how-to-plot-river-banks-instead-of-a-single-line-in-r
# https://cran.r-project.org/web/packages/osmdata/vignettes/osmdata.html

# first API call - rivers as lines
# You can try to add water features using river_water call to the APT (not show in this example) 
# riverbed <- getbb("Valencia Spain") %>% 
#            opq() %>% 
#            add_osm_feature(key = "waterway") %>% 
#            osmdata_sf()

# You can try to add water features using river_water call to the APT (not show in this example) 
# river_water <- getbb("Valencia Spain") %>% 
#  opq() %>% 
#  add_osm_feature(key = 'water', value = 'lagoon') %>%
#  osmdata_sf() 


# 2. Define specific colours for the map 
background_color <- '#1E212B'
street_color <- '#FAD399'
small_street_color <- '#D4B483'
river_color <- '#0ACDFF'
font_color <-'#FFFFFF'
  
# 3. Add tailored font from Google in both Main title and subtitle
## https://somethingaboutmaps.wordpress.com/2018/02/12/cartographers-preferred-typefaces/
# font_add_google("Roboto", "roboto")
font_add_google("Barlow", "barlow")

# 4. PLOT VALENCIA METROPOLITAN AREA MAP

# This is the new map with all features
vlc_city <- ggplot() +
  
  geom_sf(data = streets$osm_lines,inherit.aes = FALSE,color = street_color, size = .5, alpha = .6) +
  geom_sf(data = residential$osm_lines,inherit.aes = FALSE,color = street_color, size = .3, alpha = .6) +

  theme_void() +
  theme(
      plot.title = element_text(family = "Barlow",color = font_color,size = 15, hjust = 0.1, vjust = -12.0),
                   plot.title.position = "plot",
      plot.subtitle = element_text(family = "Barlow",
                                   color = font_color,
                                   size = 9,                    # Negative vjust to move subtitle in the plot area
                                   #  center subtitle using the hjust argument (0.5)
                                   # Adjusting hjust to place sub-stile below the map
                                   # hjust = 0.5 , vjust = -285), # Size to be visualized within our laptop
                                   hjust = 0.5 , vjust = -530),  # Size to printi it out
      panel.border = element_rect(colour = "#D4B483", fill = NA, size = 1),
      panel.margin = unit(c(0.6,1.6,1,1.6),"cm"),
      plot.background = element_rect(fill = "#D4B483")
      
      ) +
    labs(title = "Valencia ~ Spain", subtitle = '39.4699° N, 0.3763° W')

vlc_city

name <-"Valencia_metropolitan_area"
width = 20
height = 40

here()
# Save chart
# Output size can be tailored to print out as a poster. Current setup width 20 cm and height 40 cm
ggsave(here::here(paste(name,".png")),
       device = "png", width = width, height = height, units = "cm", dpi = "retina", bg = "transparent")
