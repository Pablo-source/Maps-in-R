# 11/11/2021  Project Directory setup


# Function to setup project structure
# Initial folder structure (data,Output,Shapefiles,Checks,Maps,Archive)

project_setup <-function(){
  
  if(!dir.exists("data")){dir.create("data")}
  if(!dir.exists("Output")){dir.create("Output")}  
  if(!dir.exists("Shapefiles")){dir.create("Shapefiles")} 
  if(!dir.exists("Checks")){dir.create("Checks")}
  if(!dir.exists("Maps")){dir.create("Maps")}
  if(!dir.exists("Archive")){dir.create("Archive")}
}

project_setup()