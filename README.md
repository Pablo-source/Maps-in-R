![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)
![GitHub all releases](https://img.shields.io/github/downloads/Pablo-source/Maps-in-R/total?label=Downloads&style=flat-square)
![GitHub language count](https://img.shields.io/github/languages/count/Pablo-source/Maps-in-R)

# Maps-in-R

This repository will contain maps created in R, I will start by producing some general country level maps using ggplot2 and sf packages.

Besides, I will use this repository to draw a set of specific London maps. As an exercise on how to use the London statistical GIS boundaries provided by the Greater London Authoprity website: 

## City Maps

Taking inspiration from the 30 Day Map Challenge movement. I will start creating several city maps, exploring the different methods they explain and show in the meain repository: https://github.com/tjukanovt/30DayMapChallenge

This is the first City map I have created using osmdata and sf packages, you will find all the details to produce the map below in this script: https://github.com/Pablo-source/Maps-in-R/blob/main/City_maps/VALENCIA%20Street%20map_print.R 

### City of Valencia, in Spain. 

![Valencia_metropolitan_area ](https://user-images.githubusercontent.com/76554081/224561937-ccaefdc4-1ef1-49df-9e4b-9c124623e8bb.png)


## Shapefiles folder

This folder contains all shapefiles required to build maps for cities and countries

### The Open Geography portal from the Office for National Statistics (ONS) 

The Open Geography portal from the Office for National Statistics (ONS) provides free and open access to the definitive source of geographic products, web applications, story maps, services and APIs. All content is available under the Open Government Licence v3.0, except where otherwise stated.

https://geoportal.statistics.gov.uk/

From the Open Geography Portal website, you can download CCG Shape files navigating to Boundaries top page menu, then selecting Health Boundaries section. In there choose Shapefile option to download zipped file containing all necessary files to create a CCG map. You can then merge some indicators data to populate this shape file. To plot maps using  SF and GGPLOT packages in R, you would need all files included in the unzipped Shape file folder, not just the .sh file. It is advised to read all .sh files from the original unzipped folder on your local folder.

### The London Datastore 

The London Datastore is  a free and open data-sharing portal  where anyone can access data relating to the capital.  Whether you’re a citizen, business owner, researcher or developer, the site provides over 700 datasets to help you understand the city and develop solutions to London’s problems. 

Greater London Authority > Satatistical GIS Boundary Files for London

https://data.london.gov.uk/dataset/statistical-gis-boundary-files-london


The different GIS boundaries provide the following level of aggregation for London region maps: 

- Output Area (OA) 2011,

- Lower Super Output Area (LSOA) 2004 and 2011,

- Middle Super Output Area (MSOA) 2004 and 2011,

- London Wards (two files: City of London merged into single area and split into seperate wards). There are separate download file for 2014 & 2018 boundaries.

- London Boroughs

## NHS data for CCG maps

### CCG Outcomes Indicator Set - March 2022

The indicators aim to provide clear, comparative information for Clinical Commissioning Groups (CCGs) and Health and Wellbeing Boards (HWBs) about the quality of health services commissioned by CCGs and, as far as possible, the associated health outcomes.

https://digital.nhs.uk/data-and-information/publications/statistical/ccg-outcomes-indicator-set/march-2022

